__precompile__()


module Jfire

export Fire

using Dates

function Fire(the_called::Union{Function, Module, Tuple};time::Bool=false, color::Symbol=:green)
	printstyled("$(now()) ... start fire\n", color=color)	
	the_called_type = check_called_type(the_called)
	need, kws, the_called = parse_args(ARGS, the_called_type, the_called)
	
	if the_called_type  == "module"
		the_func = ARGS[1]
		if time
			@time call_module(the_called, the_func, need, kws)
		else
			call_module(the_called, the_func, need, kws)
		end
	elseif the_called_type == "modules"
		the_func = replace(ARGS[1], r"^.*\."=>"")
		if time
			@time call_module(the_called, the_func, need, kws)
		else
			call_module(the_called, the_func, need, kws)
		end
	elseif the_called_type == "function" || the_called_type == "functions" 
		if time
			@time call_function(the_called, need, kws)
		else
			call_function(the_called, need, kws)
		end
	else
		error("sorry, not support the_called_type = $the_called_type for $the_called yet")
	end

	printstyled("$(now()) ... end fire\n", color=color)	

end

function check_called_type(the_called::Union{Function, Module, Tuple})
	the_called_type = typeof(the_called)
	if the_called_type == Module
		the_called_type = "module"
	elseif occursin(r"^Tuple{Module", string(the_called_type))
		the_called_type = "modules"
	elseif occursin(r"^typeof", string(the_called_type))
		the_called_type = "function"
	elseif occursin(r"^Tuple{typeof", string(the_called_type))
		the_called_type = "functions"
	else
		error("sorry, not support the_called_type = $the_called_type for $the_called yet")
	end
	return the_called_type
end

function module_help(the_called::Module,args)
	if length(args) < 1
		error("sorry, you should specific a funciton name, not just a module name")
	end
	if occursin(r"^-?-help" ,args[1])
		error("you should first specific a function name then --help")
	elseif occursin(r"^-?-" ,args[1])
		error("sorry, should start with function name, not $(args[1])")
	end
	if length(args) >=2 && occursin(r"^-?-help" ,args[2])
		help(getfield(the_called, Symbol(args[1])))
	end
	return 1
end

function parse_args(args, the_called_type, the_called)
	if the_called_type == "module"
		module_help(the_called, args)
		need, kws = parse_kws(args[2:end])
		return need, kws, the_called
	elseif the_called_type == "modules"
		if length(args) == 0
			error("error, you shold give Module and function name")
		end
		if ! occursin(r"\.", args[1])
			error("format should like: module_name.fuction_name , not $(args[1]) for $the_called")
		end
		for m in the_called
			the_type = typeof(m)
			if the_type != Module
				error("error, $m is not a Module name")
			end
			if replace(string(m), r".*\."=>"") == replace(args[1], r"\..*"=>"")
				module_help(m, args)
				need, kws = parse_kws(args[2:end])
				return need, kws, m
			end
		end
		error("error: cannot find module $(args[1])")
	elseif the_called_type == "function"
		function_help(args, the_called)
		need, kws = parse_kws(args)
		return need, kws, the_called
	elseif the_called_type == "functions"
		if length(args) == 0
			error("error, you shold give function name")
		end
		for func in the_called
			if string(func) == args[1]
				function_help(args, func)
				need, kws = parse_kws(args[2:end])
				return need, kws, func
			end
		end
		error("error, cannot find Function $(args[1]) in $the_called")
	else
		error("sorry, not support $the_called_type yet, only Module or Funciton or tuple like (Module1,Module2)")
	end
end

function function_help(args, the_called::Function)
	if length(args) >=1 && occursin(r"^-?-help" ,args[1])
		help(the_called)
	end

end
function get_help(the_called)
	if typeof(the_called) == Module
		println("here")
		funcs = names(the_called)
		for i in firstindex(funcs):lastindex(funcs)
			func = funcs[i]
			the_type = typeof(getfield(the_called, func))
			if the_type != Module
				println(the_type)
				println(Main.myth.hello)
			end
		end
	else
		println("dd")
	end

end
#methods(the_called.hello) # it works too !

function parse_kws(args)
	need = param_keys = param_values = []
	flag = 0
	# gather must need parameter
	for (i,j) in enumerate(args)
		if flag == 0
			if ! occursin(r"^-", j)
				push!(need, convert_type(j))
			else
				flag = i
			end
		end
	end
	
	need = tuple(need...)
	if flag == 0
		if length(need) != 0
			println("position arguments: $need\n")
		end
		return need,NamedTuple{tuple()}(tuple())
	end
	args = args[flag:end]
	if ! (iseven(length(args)) || length(args) == 0)
		error("sorry, parameter $args number should >=0 and is odd number")
	end

	# check parameter if start with --
	[ occursin("-", args[i]) || error("sorry, $(args[i]) maybe is paramter, should start with --, like --$(args[i])") for i in 1:2:length(args)]
	
	# gather keys of parameter
	param_keys = [ Symbol(replace(args[i], '-' => "")) for i in 1:2:length(args)]

	# gather value of parameter
	param_values = [convert_type(args[i]) for i in 2:2:length(args)]
		
	kws = NamedTuple{tuple(param_keys...)}(tuple(param_values...)) # genearate keywords argument for function, ... mean unpack the array, convert array to tuple
	if length(need) != 0
		println("position arguments: $need")
	end
	if length(kws) != 0
		println("optional arguments: $kws\n")
	end
	return need, kws
end

function convert_type(str::String)
	m = match(r"^([^:]*)::(.*)", str)
	if m === nothing
		return str
	end
	if m[1] == "string" ||  m[1] == "String"
		return string(m[2])
	end
	try
		the_type = getfield(Main, Symbol(m[1]))
		return parse(the_type, m[2])
	catch
		error("error: $(m[1]) in $str is not support by julia Main Module")
	end
end

function str2number(str::String)
	if occursin(r"^[\d]+$", str)
		return parse(Int, str)
	elseif occursin(r"^[\d\.]+$", str)
		if Sys.WORD_SIZE == 64
			return parse(Float64, str)
		elseif Sys.WORD_SIZE == 32
			return parse(Float32, str)
		else
			error("error: Sys.WORD_SIZE is $(Sys.WORD_SIZE) is not supported, only support 32 o r 64")
		end
	else
		return str
	end
end


function call_module(the_called::Module, the_func, need::Tuple, kws::NamedTuple)
	the_func = replace(the_func, r"^.*\."=>"")
	funcs = names(the_called)
	flag = 1
	for i in firstindex(funcs):lastindex(funcs)
		#println(typeof(i).name.mt.name)
		func = funcs[i]
		the_type = typeof(getfield(the_called, func))
		if the_type != Module && string(func) == the_func
			flag = 0
			#println("match $(hello) $(func)")
			#getfield(the_called, func)(;NamedTuple{(Symbol(hello_k1), )}((hello_w1, ))...) # it works!
			#ins = Symbol(hello_k1) => hello_w1, Symbol("greet") => "how is today?" # it works too !
			#ins = NamedTuple{(Symbol(hello_k1), Symbol("greet"))}((hello_w1, "hot is today")) # it works !
			getfield(the_called, func)(need...;kws...) # it works too !
			#getfield(the_called, func)(;Symbol(hello_k1) => hello_w1, Symbol("greet") => "how is today?") # it works too !
			#getfield(the_called, func)(;Symbol(hello_k1) = hello_w1) # it not works 
			#getfield(the_called, func)(;(Symbol(hello_k1) => hello_w1, Symbol("greet") => "how is today?")...) # it works too !
		end
	end

	if flag == 1
		error("sorry, not find function $the_func in $the_called")
	end
	# thanks to https://discourse.julialang.org/t/how-to-set-variable-to-key-of-keyword-arguments-of-function/18995
	#
end

function call_function(the_called::Function, need::Tuple, kws::NamedTuple)
	the_called(need...;kws...)
end

function help(func::Function)
	vinfo = code_lowered(func)
	vinfo_type = code_typed(func)
	println(vinfo_type)
	println("\n")
	println(split(string(vinfo[1]), r"Main.:")[end])
	println("\n")
	println(vinfo[1].slotnames)
	println(func.kwargs)
	error()
end


end
