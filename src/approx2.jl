function tree_approximation2!(newtree, path::Function, nIterations::Int64, p::Int64=2, r::Int64=2)
    leaf, omegas, probaLeaf = leaves(newtree)      # leaves, indexes and probabilities of the leaves of the tree
    dm = size(newtree.state, 2)                    # dm = dimension of the states of the nodes of the tree.
    T = height(newtree)                            # height of the tree = number of stages - 1
    n = length(leaf)                               # number of leaves = no of omegas
    d = zeros(Float64, dm, length(leaf))
    samplepath = zeros(Float64, T+1, dm)           # T + 1 = the number of stages in the tree.
    probaLeaf = zero(probaLeaf)
    probaNode = nodes(newtree)                                # all nodes of the tree
    path_to_leaves = [root(newtree, i) for i in leaf]         # all the paths from root to the leaves
    path_to_all_nodes = [root(newtree, j) for j in probaNode] # all paths to other nodes
    for k = 1 : nIterations

        critical = max(0.0, 0.2 * sqrt(k) - 0.1 * n)
        #tmp = findall(xi -> xi <= critical, probaLeaf)
        tmp = Int64[inx for (inx, ppf) in enumerate(probaLeaf) if ppf <= critical]
        samplepath .= path()  # a new trajectory to update the values on the nodes
        #The following part addresses the critical probabilities of the tree so that we don't loose the branches
        if !isempty(tmp) && !iszero(tmp)
            probaNode = zero(probaNode)
            probaNode[leaf] = probaLeaf
            for i = leaf
                while newtree.parent[i] > 0
                    probaNode[newtree.parent[i]] = probaNode[newtree.parent[i]] + probaNode[i]
                    i = newtree.parent[i]
                end
            end
            for tmpi = tmp
                rt = path_to_leaves[tmpi]
                #tmpi = findall(pnt -> pnt <= critical, probaNode[rt])
                tmpi = Int64[ind for (ind, pnt) in enumerate(probaNode[rt]) if pnt <= critical]
                newtree.state[rt[tmpi],:] .= samplepath[tmpi,:]
            end
        end
        #To the step  of STOCHASTIC COMPUTATIONS
        endleaf = 0 #start from the root
        for t = 1 : T+1
            tmpleaves = newtree.children[endleaf + 1]
            disttemp = Inf #or fill(Inf,dm)
            for i = tmpleaves
                dist = norm(view(samplepath, 1 : t) - view(newtree.state, path_to_all_nodes[i]), p)
                if dist < disttemp
                    disttemp = dist
                    endleaf = i
                end
            end
        end
        #istar = findall(lf -> lf == endleaf, leaf)
        istar = Int64[idx for (idx, lf) in enumerate(leaf) if lf == endleaf]
        probaLeaf[istar] .+= 1.0                                                            #counter  of probabilities
        StPath = path_to_leaves[endleaf - (leaf[1] - 1)]
        #println(StPath)
        delta = newtree.state[StPath,:] - samplepath
        #println()
        #println(delta)
        d[:,istar] .+= norm(delta, p).^(r)
        delta .=  r .* norm(delta, p).^(r - p) .* abs.(delta)^(p - 1) .* sign.(delta)
        #println(delta)
        ak = 1.0 ./ (30.0 .+ probaLeaf[istar]) #.^ 0.75        # step size function - sequence for convergence
        newtree.state[StPath,:] = newtree.state[StPath,:] - delta .* ak
    end
    probabilities  = map(plf -> plf / sum(probaLeaf), probaLeaf) #divide every element by the sum of all elements
    t_dist = (d * hcat(probabilities) / nIterations) .^ (1 / r)
    newtree.name = "$(newtree.name) with d=$(t_dist) at $(nIterations) iterations"
    newtree.probability .= build_probabilities!(newtree, hcat(probabilities)) #build the probabilities of this tree
    return newtree
end



################
# Benchmark view function
samplepath = collect(1:1000)
using LinearAlgebra

function test01(samplepath)
for t = 1:length(samplepath)
    dist = norm(view(samplepath, 1 : t) - view(samplepath.^2, 1:t),2);
end
end

function test02(samplepath)
for t = 1:length(samplepath)
    dist = (sum((view(samplepath, 1 : t) - view(samplepath.^2, 1:t)).^2))^0.5;
end
end

function test03(samplepath)
    for t = 1:length(samplepath)
        dist = norm(samplepath[1:t] - samplepath[1:t].^2,2);
    end
    end

function test04(samplepath)
    for t = 1:length(samplepath)
        dist = (sum((samplepath[1:t] - samplepath[1:t].^2).^2))^0.5;
    end
end


@time test01(samplepath) # with norm and view is best
@time test02(samplepath)
@time test03(samplepath)
@time test04(samplepath)


#Benchmarking list comprehensions
leaf =  collect(16384:32767000); endleaf = 32767000;
function l_test01(leaf,endleaf)
    istar = Int64[idx for (idx, lf) in enumerate(leaf) if lf == endleaf]

end


function l_test02(leaf,endleaf)
    for i=1:length(leaf)
        if leaf[i] == endleaf
            return(i)
        end
    end
end

@time l_test01(leaf,endleaf)
@time l_test02(leaf,endleaf)

