# Jfire
#### Why Jfire <br>
&nbsp;&nbsp;&nbsp;&nbsp;inspired by python-fire(https://github.com/google/python-fire) and Fire(https://github.com/ylxdzsw/Fire.jl) <br>
#### Install<br>
```
julia> ] 
julia> add Jfire # need julia 0.7.0+
```
#### Feature<br>
&nbsp;&nbsp;&nbsp;&nbsp;1. support call single/multiple Function or single/multiple Module. <br>
#### Thanks<br>
&nbsp;&nbsp;&nbsp;&nbsp;thanks the  people: I learned from https://discourse.julialang.org/t/how-to-set-variable-to-key-of-keyword-arguments-of-function/18995/7, after that, I tried to write Jfire. <br>
#### Dependence<br>
```
julia 0.7.0/1.0.3/1.1.0-rc1
```

#### Usage<br>
doc/myth.jl is an example call from single Module:<br>
```
using Jfire

module myth
export hello
function hello(;name::String="sikaiwei", greet::String="how is the weather?", number::Number=3)
	println("hello, $name. $greet. $number")
end
end

if abspath(PROGRAM_FILE) == @__FILE__
	Jfire.Fire(myth, time=true, color=:yellow)
end
```
then run :
```
$ julia myth.jl hello --name world
2019-01-09T16:37:32.302 ... start fire
optional arguments: (name = "world",)

hello, world. how is the weather?. 3
  0.057381 seconds (65.33 k allocations: 3.304 MiB, 16.71% gc time)
2019-01-09T16:37:32.867 ... end fire
```
doc/myths.jl is an example call from multiple Module:<br>
```
using Jfire

module myth1
export hello1
function hello1(;name::String="sikaiwei", greet::String="how is the weather?", number::Number=3)
	println("hello, $name. $greet. $number")
end
end

module myth2
export hello2
function hello2(;name::String="sikaiwei", greet::String="how is the weather?", number::Number=3)
	println("hello, $name. $greet. $number")
end
end

if abspath(PROGRAM_FILE) == @__FILE__
	ms = (myth1, myth2)
	Jfire.Fire(ms)
end
```
then run :
```
$ julia myths.jl  myth1.hello1 --name world
2019-01-09T16:37:34.934 ... start fire
optional arguments: (name = "world",)

hello, world. how is the weather?. 3
2019-01-09T16:37:35.467 ... end fire
```
doc/func.jl is an example call from single Function:<br>
```
using Jfire
function myth_func1(wow;name::String="sikaiwei", greet::String="how is the weather?")
	println("$wow, hello, $name ~ $greet")
end
if abspath(PROGRAM_FILE) == @__FILE__
	Jfire.Fire((myth_func1))
end
```
then run :
```
$ julia  func.jl wow
2019-01-09T16:37:37.632 ... start fire
position arguments: ("wow",)

wow, hello, sikaiwei ~ how is the weather?
2019-01-09T16:37:38.189 ... end fire
```
doc/func.jl is an example call from multiple Function:<br>
```
using Jfire
function myth_func1(wow;name::String="sikaiwei", greet::String="how is the weather?")
	println("$wow, hello, $name ~ $greet")
end
function myth_func2(wow;name::String="sikaiwei", greet::String="how is the weather?")
	println("$wow, hello, $name ~ $greet")
end

if abspath(PROGRAM_FILE) == @__FILE__
	Jfire.Fire((myth_func1,myth_func2), time=true, color=:yellow)
end
```
then run :
```
$ julia  funcs.jl  myth_func1 well --greet 'nice day'
2019-01-09T16:37:40.052 ... start fire
position arguments: ("well",)
optional arguments: (greet = "nice day",)

well, hello, sikaiwei ~ nice day
  0.013463 seconds (10.47 k allocations: 596.311 KiB)
2019-01-09T16:37:40.831 ... end fire
```
<br>
detail test script is doc/test.sh<br>

#### Support function parameter types:<br>
&nbsp;&nbsp;&nbsp;&nbsp;default is String,you also can specify the type, like --parameter Int::32, support julia build-in type which is argument of parse(), like Int,Float32,Float64,etc<br>
&nbsp;&nbsp;&nbsp;&nbsp;position arguments or optional keywords argument<br>

#### Not support function parameter types:<br>
&nbsp;&nbsp;&nbsp;&nbsp;--help<br>

