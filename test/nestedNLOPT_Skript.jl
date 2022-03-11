
# Nested optimization skript with NLopt
#########################################

trr1 = Tree(404);
trr2 = Tree(404);


function myfunc(x::Vector)
    
    trr1.state = x # update states Vector
    dist = nestedWasserstein(trr1,trr2,1.0)

    return dist
end

 dim = length(trr1.state)

function myconstraint(x::Vector) #, grad::Vector
    #  (a*x[1] + b)^3 - x[2]  means term is <= 0
    lb = trr1.state[trr1.parent[2:end]]
    return([0;lb] .- x) 
    
end

opt = Opt(:LN_COBYLA, dim)
opt.xtol_rel = 1e-8

opt.min_objective = myfunc
#inequality_constraint!(opt, x -> myconstraint(x), 1e-8)


(minf,minx,ret) = optimize(opt,collect(1:15))
numevals = opt.numevals # the number of function evaluations
println("got $minf at $minx after $numevals iterations (returned $ret)")

trr1.state = minx

tree_plot(trr1)
tree_plot(trr2)