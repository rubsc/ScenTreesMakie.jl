



# can we write a function adjusting the states so that process becomes monotone?
# resulting tree should be very close (in nested distance) to original process


trr1 = Tree([1,2,1]); trr1.state = [2, 3,2,3,1]; trr1.probability = [1; 0.5; 0.5; 1; 1];
trr2 = Tree([1,1,2]); trr2.state = [2,2,3,1]; trr2.probability = [1;0.5;0.5];

distMatrix = distFunction(trr1.state[4:5],trr2.state[3:4])
distMatrix = distMatrix .+ distFunction(trr1.state[2:3],[trr2.state[2]])
Wasserstein()

trr1.state = collect(1:15)
nestedWasserstein(trr1,trr2,1)










#########################################

function myfunc(x::Vector)
    
    trr1.state = x # update states Vector
    dist = nestedWasserstein(trr1,trr2,1)

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