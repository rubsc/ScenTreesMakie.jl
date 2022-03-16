using Optim
using ScenTreesMakie

# Simple optimization to fit an arbitrary tree to a given tree where both have the same 
# branching structure
function myfunc(x)

    trr1.state = x # update states Vector
    trr1.state[1] = trr2.state[1]
    dist = nestedWasserstein(trr1,trr2,1.0)

    return dist
    
end



# add lagrangian formulation for myConstraint
# xmin aus optimization is not in order, in jedem teilbaum/stage
# sollte absteigend sortiert sein!
# sortierung pro stage schon automatisch erfüllt! Das reicht schon
###################
function myConstraint(x,alpha)
    #return(sum(x))
    #trr3 = Tree("tmp",trr1.parent,trr1.children, x, trr1.probability)
    
    lb = trr1.state[trr1.parent[2:end]]
    return( sum(alpha .* ([0;lb] .- x)  ))

    
end

function myLagrangeFunction(x,alpha)
    return( myfunc(x) + myConstraint(x,alpha) )

end




function myDualFunction(alpha)
    x0 = collect(1:length(alpha)).*1.0
    function myDualFunction_inner(x)
        return (myLagrangeFunction(x,alpha))
    end
    tmp = Optim.optimize(myDualFunction_inner, x0, NelderMead(), Optim.Options(g_tol = 1e-12)  )

    return(tmp)
end

trr1 = Tree(303);
trr2 = Tree(303);
n = length(trr1.state);
alpha0 = collect(1:n)*1.0;

function Max_myDualFunction(alpha)
    return (-myDualFunction(alpha))
end

result = Optim.optimize(Max_myDualFunction, alpha0, NelderMead(), Optim.Options(g_tol = 1e-12)  )



xmin = Optim.minimizer(result)[1:n]
alpha_opot = Optim.minimizer(result)[n+1:end]
trr2.state



#############################
# Regularization Ansatz

function myfunc2(x)

    trr1.state = x # update states Vector
    trr1.state[1] = trr2.state[1]
    dist = nestedWasserstein(trr1,trr2,1.0)

    return dist
    
end

###################
function myConstraint2(x)
    
    # lower bound such that process is monotonically increasing
    lb = trr1.state[trr1.parent[2:end]]
    tmp = sum( max.([0;lb] .- x,0))

    #upper bound such that fitted tree does not exceed original tree (significantly)
    ub = maximum(trr2.state);
    tmp2 = sum(max.(x .- ub,0) )

    return( tmp + tmp2 )    
end

function myRegularizedFunction(x)
    return( myfunc2(x) + 10*myConstraint2(x) )

end

trr1 = Tree(404);
trr2 = Tree(404);
n = length(trr1.state);
x0 = collect(1:n)*1.0; 

result = Optim.optimize(myRegularizedFunction, x0, NelderMead(), Optim.Options(g_tol = 1e-12, show_trace=true)  )
Optim.minimizer(result)

tree_plot(trr1)
tree_plot(trr2)