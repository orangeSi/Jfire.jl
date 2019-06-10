io = open("myths.jl", "r")
content = read(io, String)
#println(content)

function ParSelf(content::String, type::String, key::String)
	if type == "module" || type == "function"
		for i in eachmatch(r"", content)
			println("match is $(i.match)\n\n")
		end
	end

end
ParSelf(content, "module", "myth1")
