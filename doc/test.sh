set -vex
which julia
alias julia="julia --color=yes"
# call from single module
julia myth.jl hello --name world --number Int::5
julia myth.jl hello -h
julia myth.jl  -h

# call from multiple modules 
julia myths.jl  myth1.hello1 --name world --number Int::5

julia myths.jl  myth2.hello2 --name myth --number Float32::5

julia myths.jl  -h

julia myths.jl myth2.hello2 -h

# call from single function
julia  func.jl wow
julia  func.jl -h


# call from multiple functions
julia  funcs.jl  myth_func1 well --greet 'nice day' --fishing Bool::true

julia  funcs.jl  myth_func2 well --greet 'nice day'

julia  funcs.jl  -h
julia  funcs.jl myth_func1 -h
echo test done
