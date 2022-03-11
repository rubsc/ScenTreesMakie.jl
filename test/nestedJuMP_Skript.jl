
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



#######################################################################################################
using ScenTreesMakie
trr1 = Tree(404);
trr2 = Tree(404);
n = length(trr1.state)
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