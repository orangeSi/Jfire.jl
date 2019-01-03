
include("../src/Jfire.jl")
#using fire

function myth_func(wow::String; name::String="sikaiwei", greet::String="how is the weather?", number::Int=8)
	println("$wow, hello, $name ~ $greet")
end

if abspath(PROGRAM_FILE) == @__FILE__
	Jfire.Fire(myth_func)
end

