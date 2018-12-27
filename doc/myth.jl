
include("../src/Jfire.jl")

module myth

export hello

function hello(;name::String="sikaiwei", greet::String="how is the weather?")
	println("hello, $name. $greet")
end
#println(typeof(hello).name.mt.name)
#println(string(typeof().name.mt.name))


end

if abspath(PROGRAM_FILE) == @__FILE__
	Jfire.Fire(myth)
end
