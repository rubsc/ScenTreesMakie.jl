using Optim
using ScenTreesMakie

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

trr1 = Tree(404);
trr2 = Tree(404);
n = length(trr1.state);
trr1.state[2:end] = max.(trr1.state[trr1.parent[2:end]] .- trr1.state[2:end],0) + trr1.state[2:end];
x0 = trr1.state; 
                
result = Optim.optimize(myRegularizedFunction, x0, ParticleSwarm(n_particles = 5), Optim.Options(iterations=2000, show_trace=false)  )

#result = Optim.optimize(myRegularizedFunction, x0, NelderMead(), Optim.Options(g_tol = 1e-12, show_trace=true)  )
Optim.minimizer(result)

plot(trr1)
plot(trr2)