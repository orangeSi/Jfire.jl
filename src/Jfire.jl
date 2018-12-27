module Jfire

export Fire

function Fire(the_called)
	printstyled("... start fire\n", color=:green)	
	#kws = parse_args_kws(ARGS)
	the_called_type = typeof(the_called)
	need, kws = parse_args(ARGS, the_called_type)

	if the_called_type  == Module
		the_func = ARGS[1]
		call_module(the_called, the_func, need, kws)
	#elseif the_called_type == Function
	else
		call_function(the_called, need, kws)
	#else
		#error("sorry, not support $the_called_type yet, only Module or Funciton")
	end
	printstyled("... end fire\n", color=:green)	

end


function parse_args(args, the_called_type)
	if the_called_type == Module
		println("parse args for Module")
		#if length(args) < 1
		#	error("sorry, parameter $args number should >=1")
		#end
		if occursin(r"^-" ,args[1])
			error("sorry, should start with function name, not $(args[1])")
		end
		#need = ("orange","good day")
		need, kws = parse_kws(args[2:end])
		return need, kws
	#elseif the_called_type == Function
	else
		println("assum parse args for Function")
		#if length(args) < 1
		#	error("sorry, parameter length should >=1 ")
		#end
		#need = ("orange","good day")
		need, kws = parse_kws(args)
		return need, kws
	#else
		#error("sorry, not support $the_called_type yet, only Module or Funciton")
	end
end


function parse_kws(args)
	need = param_keys = param_values = []
	flag = 0
	# gather must need parameter
	for (i,j) in enumerate(args)
		if flag == 0
			if ! occursin(r"^-", j)
				push!(need, j)
			else
				flag = i
			end
		end
	end
	
	need = tuple(need...)
	if flag == 0
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
	param_values = [args[i] for i in 2:2:length(args)]
		
	kws = NamedTuple{tuple(param_keys...)}(tuple(param_values...)) # genearate keywords argument for function, ... mean unpack the array, convert array to tuple
	return need, kws
end




function call_module(the_called::Module, the_func, need::Tuple, kws::NamedTuple)
	funcs = names(the_called)
	flag = 1
	for i in firstindex(funcs):lastindex(funcs)-1
		#println(typeof(i).name.mt.name)
		func = funcs[i]
		if string(func) == the_func
			flag = 0
			#println("match $(hello) $(func)")
			#getfield(the_called, func)(;NamedTuple{(Symbol(hello_k1), )}((hello_w1, ))...) # it works!
			#ins = Symbol(hello_k1) => hello_w1, Symbol("greet") => "how is today?" # it works too !
			#ins = NamedTuple{(Symbol(hello_k1), Symbol("greet"))}((hello_w1, "hot is today")) # it works !
			#println("need is $need")
			#println("ksw is $kws")
			getfield(the_called, func)(need...;kws...) # it works too !
			#getfield(the_called, func)(;Symbol(hello_k1) => hello_w1, Symbol("greet") => "how is today?") # it works too !
			#getfield(the_called, func)(;Symbol(hello_k1) = hello_w1) # it not works 
			#getfield(the_called, func)(;(Symbol(hello_k1) => hello_w1, Symbol("greet") => "how is today?")...) # it works too !
		end
	end

	if flag == 1
		error("sorry, not find function $hello in $the_called")
	end
	# thanks to https://discourse.julialang.org/t/how-to-set-variable-to-key-of-keyword-arguments-of-function/18995
	#
end

function call_function(the_called::Function, need::Tuple, kws::NamedTuple)
	the_called(need...;kws...)
end




end
