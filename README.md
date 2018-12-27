# Jfire
### why Jfire ? <br>
&nbsp;&nbsp;&nbsp;&nbsp;inspired by python-fire(https://github.com/google/python-fire) and Fire(https://github.com/ylxdzsw/Fire.jl) <br>
### feature<br>
&nbsp;&nbsp;&nbsp;&nbsp;1. only support fire Function or Module yet, then call only one funciton in command line. <br>

#### thanks<br>
&nbsp;&nbsp;&nbsp;&nbsp;thank the  people: I learned from https://discourse.julialang.org/t/how-to-set-variable-to-key-of-keyword-arguments-of-function/18995/7, after that, I tried to write Jfire. <br>
#### only test in julia v1.02 yet. <br><br>

#### usage<br>
doc/myth.jl is an example call from Module
```
include("../Jfire.jl")
module myth

export hello
function hello(;name::String="sikaiwei", greet::String="how is the weather?")
	println("hello, $name. $greet")
end

end

if abspath(PROGRAM_FILE) == @__FILE__
	Jfire.Fire(myth)
end
```
then run command line like this:
```
$ julia  doc/myth.jl hello --name 'myth' --greet 'what a good day!'
... start fire
parse args for Module
hello, xx. how is the weather?
... end fire
```
<br> doc/func.jl is an example call form Function directly:
```
include("../src/Jfire.jl")
#using fire
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
assum parse args for Function
wow, hello, sikaiwei ~ how is the weather?
... end fire

$ julia doc/func.jl  wow --name wold --greet ' nice day! '
... start fire
assum parse args for Function
wow, hello, wold ~  nice day!
... end fire
```
