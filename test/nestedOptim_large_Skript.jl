# Nested distance optimization with Optim for large trees

using ScenTreesMakie
using Optim
using JLD


Tree0 = load("Trees/311000/binary.jld","Tree0");

#############################
# Regularization Ansatz

function myfunc(x)

    trr1.state = x # update states Vector
    #trr1.state[1] = trr2.state[1]
    dist = nestedWasserstein(trr1,trr2,2.0).^2.0

    return dist
    
end

###################
function myConstraint(x)
    
    # lower bound such that process is monotonically increasing
    lb = trr1.state[trr1.parent[2:end]]
    tmp = sum( max.([0;lb] .- x,0))

    #upper bound such that fitted tree does not exceed original tree (significantly)
    ub = maximum(trr2.state);
    tmp2 = sum(max.(x .- ub,0) )

    return( tmp + tmp2 )    
end

function myRegularizedFunction(x)
    return( myfunc(x) + 1000*myConstraint(x) )

end

bla =[1,2,4,8,16,33,66,133,267,535,1070,2141,4282,8565,17131,34263,68527] # from other laptop; works only with CBDX_simple_binary
plot(Tree0)

# Save list of trees in stage
t = 6; trrs = [];
#for i=1:length(nodes(Tree0,stage))
#    println(i)
#    push!(trrs,part_tree(Tree0,nodes(Tree0,stage)[i]  ))
#end
#save("partialTrees06-CBDXsimpleBinary.jld","trrs",trrs)

initialTree = deepcopy(Tree0);
lastNode = nodes(Tree0,t-1)[end]
initialTree.state=initialTree.state[1:lastNode];
initialTree.probability=initialTree.probability[1:lastNode];
initialTree.parent=initialTree.parent[1:lastNode];
initialTree.children=initialTree.children[1:lastNode];


trrs= load("partialTrees06-CBDXsimpleBinary.jld","trrs");
for i=1:(length(trrs)-63)
    global trr1 = deepcopy(trrs[i]);
    global trr2 = deepcopy(trrs[i]);
    n = length(trr1.state);
    trr1.state[2:end] = max.(trr1.state[trr1.parent[2:end]] .- trr1.state[2:end],0) + trr1.state[2:end];
    x0 = trr1.state;

               
    result = Optim.optimize(myRegularizedFunction, x0, ParticleSwarm(n_particles = 5), Optim.Options(iterations=200, show_trace=true)  )
#    result = Optim.optimize(myRegularizedFunction, x0, NelderMead(), Optim.Options(g_tol = 1e-8, iterations=500, show_trace=true)  )
    trrs[i] = trr1;
end


target = deepcopy(Tree0)
target = combine_tree(target,initialTree,trrs)

             
result = Optim.optimize(myRegularizedFunction, x0, ParticleSwarm(n_particles = 5), Optim.Options(iterations=200, show_trace=true)  )

#result = Optim.optimize(myRegularizedFunction, x0, NelderMead(), Optim.Options(g_tol = 1e-8, iterations=500, show_trace=true)  )
Optim.minimizer(result)

plot(trr1,nothing,true)
plot(trr2,nothing,true)