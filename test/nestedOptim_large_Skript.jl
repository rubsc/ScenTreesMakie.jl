# Nested distance optimization with Optim for large trees

using ScenTreesMakie
using Optim
using JLD


Tree0 = load("Trees/311000/CBDX_simple_binary.jld","Tree0");

#############################
# Regularization Ansatz

function myfunc(x)

    trr1.state = x # update states Vector
    #trr1.state[1] = trr2.state[1]
    dist = nestedWasserstein(trr1,trr2,1.0)

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

Tree3 = part_tree(Tree0,bla[10])
trr1 = deepcopy(Tree3);
trr2 = deepcopy(Tree3);
n = length(trr1.state);
trr1.state[2:end] = max.(trr1.state[trr1.parent[2:end]] .- trr1.state[2:end],0) + trr1.state[2:end];
x0 = trr1.state;
#x0 = collect(1:n)*1.0;  # ---> need better start tree

result = Optim.optimize(myRegularizedFunction, x0, NelderMead(), Optim.Options(g_tol = 1e-8, iterations=500, show_trace=true)  )
Optim.minimizer(result)

plot(trr1,nothing,true)
plot(trr2,nothing,true)