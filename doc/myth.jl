
include("../src/Jfire.jl")

module myth

export hello

function hello(;name::String="sikaiwei", greet::String="how is the weather?", number::Number=3)
	doc="""
	I am a function named hello from a module named myth~
	"""
	println("hello, $name. $greet. $number")
end

end

if abspath(PROGRAM_FILE) == @__FILE__
	Jfire.Fire(myth)
end
