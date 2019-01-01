# Jfire
### Why Jfire ? <br>
&nbsp;&nbsp;&nbsp;&nbsp;inspired by python-fire(https://github.com/google/python-fire) and Fire(https://github.com/ylxdzsw/Fire.jl) <br>
### Feature<br>
&nbsp;&nbsp;&nbsp;&nbsp;1. only support fire Function or Module yet, then call only one funciton in command line. <br>

#### Thanks<br>
&nbsp;&nbsp;&nbsp;&nbsp;thanks the  people: I learned from https://discourse.julialang.org/t/how-to-set-variable-to-key-of-keyword-arguments-of-function/18995/7, after that, I tried to write Jfire. <br>
#### Dependence<br>
```
julia v1.02
```

#### Usage<br>
doc/myth.jl is an example call from Module
```
include("../Jfire.jl")
module myth

export hello
function hello(;name::String="sikaiwei", greet::String="how is the weather?", number::Number=3)
	println("hello, $name. $greet")
end

end

if abspath(PROGRAM_FILE) == @__FILE__
	Jfire.Fire(myth)
end
```
then run command line like this:
```
$ julia  doc/myth.jl hello --name 'myth' --greet 'what a good day!' --number 3.0
... start fire
optional arguments: (name = "myth", greet = "what a good day!", number = 3.0)

hello, myth. what a good day!. 3.0
... end fire
```
<br> doc/func.jl is an example call form Function directly:
```
include("../src/Jfire.jl")
function myth_func(wow;name::String="sikaiwei", greet::String="how is the weather?")
	println("$wow, hello, $name ~ $greet")
end

if abspath(PROGRAM_FILE) == @__FILE__
	Jfire.Fire(myth_func)
end
```
then run this:
```
$ julia doc/func.jl  wow
... start fire
wow, hello, sikaiwei ~ how is the weather?
... end fire

$ julia doc/func.jl  wow --name wold --greet ' nice day! '
... start fire
wow, hello, wold ~  nice day!
... end fire
```
<br>
#### Support function parameter types:<br>
&nbsp;&nbsp;&nbsp;&nbsp;Int, Float32 or Float64, String(default)<br>
&nbsp;&nbsp;&nbsp;&nbsp;position arguments or optional keywords argument<br>

#### Not support function parameter types:<br>
&nbsp;&nbsp;&nbsp;&nbsp;Bool<br>
&nbsp;&nbsp;&nbsp;&nbsp;--help<br>



