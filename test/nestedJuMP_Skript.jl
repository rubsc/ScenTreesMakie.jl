
# Nested optimization skript with JuMP + NLopt
################################################

using JuMP
using NLopt

model = Model(NLopt.Optimizer)
set_optimizer_attribute(model, "algorithm", :LD_MMA)

a1 = 2
b1 = 0
a2 = -1
b2 = 1

@variable(model, x1)
@variable(model, x2 >= 0)

@NLobjective(model, Min, sqrt(x2))
@NLconstraint(model, x2 >= (a1*x1+b1)^3)
@NLconstraint(model, x2 >= (a2*x1+b2)^3)

set_start_value(x1, 1.234)
set_start_value(x2, 5.678)

JuMP.optimize!(model)

println("got ", objective_value(model), " at ", [value(x1), value(x2)])



###########################################################################
using JuMP, NLopt
model = Model(NLopt.Optimizer)
set_optimizer_attribute(model, "algorithm", :LN_COBYLA)


@variable(model, 0<= x[1:15])
#@variable(model, x1)
#@variable(model, x2 >= 0)

@NLobjective(model, Min, sum( sqrt(x[i]) for i in 1:15) )

#@NLconstraint(model, x2 >= (a1*x1+b1)^3)
#@NLconstraint(model, x2 >= (a2*x1+b2)^3)

set_start_value.(x, 1.234)

set_start_value(x[1], 1.234)
set_start_value(x[2], 5.678)
set_start_value(x[3], 5.678)


JuMP.optimize!(model)

println("got ", objective_value(model), " at ", [value.(x)])






#######################################################################################################
using ScenTreesMakie
trr1 = Tree(306);
trr2 = Tree(306);
n = length(trr1.state)
###########################################################################
using JuMP, NLopt
model = Model(NLopt.Optimizer)
set_optimizer_attribute(model, "algorithm", :LN_COBYLA)
set_optimizer_attribute(model, "output_flag", true)


@variable(model, x[1:n])


function myfunc2(x...)
    x = [i for i in x]
    #return(sum(x))
    trr3 = Tree("tmp",trr1.parent,trr1.children, x, trr1.probability)
    println(trr3)
    trr1.state = x # update states Vector
    println(trr1.state)
    dist = nestedWasserstein(trr3,trr2,1.0)
    println(dist)
    return dist
    
end

JuMP.register(model,:myfunc2, n, myfunc2, autodiff=true)
@NLobjective(model, Min, myfunc2(x[1],x[2],x[3],x[4],x[5],x[6],x[7]  ) )

#@NLconstraint(model, x2 >= (a1*x1+b1)^3)
#@NLconstraint(model, x2 >= (a2*x1+b2)^3)

#set_start_value.(x, 1.234)

set_start_value(x[1], 1.0)
set_start_value(x[2], 2.0)
set_start_value(x[3], 3.0)
set_start_value(x[4], 4.0)
set_start_value(x[5], 5.0)
set_start_value(x[6], 6.0)
set_start_value(x[7], 7.0)



JuMP.optimize!(model)

termination_status(model)
println("got ", objective_value(model), " at ", [value.(x)])

