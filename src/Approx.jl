"""
	tree_approximation!(newtree::Tree, path::Function, nIterations::Int64, p::Int64=2, r::Int64=2)

Returns a valuated probability scenario tree approximating the input stochastic process.

Args:
- *newtree* - Tree with a certain branching structure,

- *path* - function generating samples from the stochastic process to be approximated,

- *nIterations* - number of iterations for stochastic approximation procedure,

- *p* - choice of norm (default p = 2 (Euclidean distance)), and,

- *r* - transportation distance parameter
"""
function tree_approximation!(newtree::Tree{A,B,C,D}, path::Function, nIterations::Int64, p::Int64=2, r::Int64=2) where {A,B,C,D}
    leaf, ~, probaLeaf = leaves(newtree)      # leaves, indexes and probabilities of the leaves of the tree
    T = height(newtree)                            # height of the tree = number of stages - 1
    n = length(leaf)                               # number of leaves = no of omegas
    d = zeros(Float64, length(leaf))
    samplepath = zeros(Float64, T+1)           # T + 1 = the number of stages in the tree.
    probaLeaf = zero(probaLeaf)
    probaNode = nodes(newtree)                                # all nodes of the tree
    path_to_leaves = [root(newtree, i) for i in leaf]         # all the paths from root to the leaves
    path_to_all_nodes = [root(newtree, j) for j in probaNode] # all paths to other nodes
    @showprogress 100 "Computing..." for k = 1 : nIterations

        # Critical == 0 if n >4!!! This is almost always the case
        critical = max(0.0, 0.2 * sqrt(k) - 0.1 * n)
        #tmp = findall(xi -> xi <= critical, probaLeaf)

        tmp = Int64[inx for (inx, ppf) in enumerate(probaLeaf) if ppf <= critical]
        samplepath .= vec(path())  # a new trajectory to update the values on the nodes
        
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
                newtree.state[rt[tmpi]] .= samplepath[tmpi]
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
        delta = newtree.state[StPath] - samplepath
        tmpNorm = sum(delta.^p).^(1/p)
        d[istar] .+= tmpNorm.^(r)
        delta .=  r .* tmpNorm.^(r - p) .* abs.(delta).^(p - 1) .* sign.(delta)
        ak = 1.0 ./ (30.0 .+ probaLeaf[istar]) #.^ 0.75        # step size function - sequence for convergence
        newtree.state[StPath] = newtree.state[StPath] - delta .* ak
    end

    #probabilities  = map(plf -> plf / sum(probaLeaf), probaLeaf) #divide every element by the sum of all elements
    probabilities = probaLeaf./sum(probaLeaf)   # this is faster than map()
    t_dist = (sum(d .* hcat(probabilities)) / nIterations) .^ (1 / r)
    newtree.name = "$(newtree.name) with d=$(t_dist) at $(nIterations) iterations"
    newtree.probability .= build_probabilities!(newtree, hcat(probabilities)) #build the probabilities of this tree

    return newtree
end



#######################################################################################################################################


"""
	lattice_approximation(bstructure::Array{Int64,1}, path::Function, nIterations::Int64, r::Int64 = 2, dim::Int64 = 1)
Returns a valuated approximated lattice for the stochastic process provided in any dimension. The default dimension is dim = 1 for a lattice in 1 dimension.

Args:
- bstructure - Branching structure of the scenario lattice e.g., bstructure = [1,2,3,4,5] represents a 5-staged lattice
- path - Function generating samples from a known distribution with length equal to the length of bstructure of the lattice.
- nIterations - Number of iterations to be performed.
- r - Parameter for the transportation distance.
- dim - dimension of the lattice to be generated. This depends entirely on the dimension of the samples generated.
"""
function lattice_approximation(bstructure::Array{Int64,1}, path::Function, nIterations::Int64, r::Int64 = 2, dim::Int64 = 1)
    tdist = zeros(dim)         # multistage distance
    T = length(bstructure)     # number of stages in the lattice
    states = [zeros(bstructure[j], 1, dim) for j = 1 : T] # States of the lattice at each time t
    probabilities = vcat([zeros(bstructure[1], 1, dim)],[zeros(bstructure[j-1], bstructure[j], dim) for j = 2 : T]) # Probabilities of the lattice at each time t
    init_path = path()
	
    #Check the dimension of the sample path if it is equal to the dimension of the lattice.
    #if dim != size(init_path)[2]
    #    @error("Dimension of lattice ($dim) is not equal to the dimension of the input array ($(size(init_path)[2]))")
    #end
    # Initialize the states of the nodes of the lattice
    for t = 1 : T
        states[t] .= init_path[t]
    end
    Z = Array{Float64}(undef, T, dim) # Array to hold the new samples generated
    #Stochastic approximation step starts here
    @showprogress 100 "Computing..." for n = 1 : nIterations
        Z .= path() # Draw a new sample Gaussian path
        last_index = Int64.(ones(dim))
        dist = zeros(dim)
        for t = 1 : T
            for i = 1 : dim
                # corrective action to include lost nodes
                states[t][:, :, i][findall(sum(probabilities[t][:, :, i], dims = 2) .< 1.3 * sqrt(n) / bstructure[t])] .= Z[t,i]
                min_dist, new_index = findmin(abs.(vec(states[t][:, :, i] .- Z[t,i]))) # find the closest lattice entry
                dist[i] += min_dist^2  # Euclidean distance for the paths
                probabilities[t][last_index[i], new_index, i] += 1.0  # increase the counter for the nodes
                # use stochastic approximation algorithm to calculate for the new states of the nodes in the lattice.
                states[t][new_index, :, i] = states[t][new_index, :, i] - r * (min_dist)^(r-1) * (states[t][new_index, :, i] .- Z[t,i]) / ((Z[1] + 30 + n))
                last_index[i] = new_index
            end
        end
        # calculate the multistage distance
        dist = dist .^ (1/2); tdist = (tdist .* (n - 1) + dist .^r )/ n
        #tdist = (tdist*(n-1) + dist)/n
    end
    # calculate the probabilities
    probabilities = probabilities ./ nIterations
    
    # functions to print the results of the lattices
    # these functions depends on the dimension of the lattice
    if dim == 1
        # Round the results to make sure that they are neat.
        # Remember it is a 3D array, so a loop will do.
        for i=length(probabilities):-1:2
            for j=1:size(probabilities[i])[1]
                probabilities[i][j,:,1] = round.(probabilities[i][j,:,1] ./ sum(probabilities[i-1][:,j,1]) , digits=6)
            end
        end

        return Lattice("Approximated Lattice with $bstructure branching structure and distance=$(tdist .^ (1 / r)) at $(nIterations) iterations",
        [round.(states[i], digits = 6) for i = 1 : length(states)], [round.(probabilities[j], digits = 6) for j = 1 : length(probabilities)])
    else
        lattices = Lattice[] # create an empty array of type Lattice to hold the resulting lattices
        for i = 1 : length(states[1])
            st = [zeros(bstructure[j], 1, 1) for j = 1 : length(states)]
            pp = vcat([zeros(bstructure[1], 1, 1)],[zeros(bstructure[j-1] , bstructure[j], 1) for j = 2 : length(states)])

            for j = 1 : length(states)
                st[j] .= states[j][:, :, i]
                pp[j] .= probabilities[j][:, :, i]
            end
            sublattice = Lattice("Lattice $i with distance=$((tdist.^(1/r))[i])",
            [round.(st[i], digits = 6) for i = 1 : length(st)], [round.(pp[j], digits = 6) for j = 1 : length(pp)])
            push!(lattices,sublattice)
        end
        return lattices
    end
end





function path_ident(trr, path::Function, nIterations::Int64, r::Int64=2, p::Int64=2)
    leaf, ~, probaLeaf = leaves(trr)      # leaves, indexes and probabilities of the leaves of the tree
    T = height(trr)                            # height of the tree = number of stages - 1
    n = length(leaf)                               # number of leaves = no of omegas
    d = zeros(Float64, length(leaf))
    samplepath = zeros(Float64, T+1)           # T + 1 = the number of stages in the tree.
    chosenPath = zeros(Int64, T+1)  

    probaLeaf = zero(probaLeaf)
    probaNode = nodes(trr)                                # all nodes of the tree
    path_to_leaves = [root(trr, i) for i in leaf]         # all the paths from root to the leaves
    path_to_all_nodes = [root(trr, j) for j in probaNode] # all paths to other nodes
    for k = 1 : nIterations
        
        critical = max(0.0, 0.2 * sqrt(k) - 0.1 * n)
        tmp = Int64[inx for (inx, ppf) in enumerate(probaLeaf) if ppf <= critical]

        samplepath .= vec(path())  # a new trajectory to update the values on the nodes

        #To the step  of STOCHASTIC COMPUTATIONS
        endleaf = 0 #start from the root
        for t = 1 : T+1
            tmpleaves = trr.children[endleaf + 1]
            disttemp = Inf #or fill(Inf,dm)
            for i = tmpleaves
                dist = norm(view(samplepath, 1 : t) - view(trr.state, path_to_all_nodes[i]), p)
                if dist < disttemp
                    disttemp = dist
                    endleaf = i
                    chosenPath[t] = i
                end
            end
        end

    end
    return(chosenPath, trr.state[chosenPath])

end



function path_ident(lat::Lattice, path::Function, nIterations::Int64, r::Int64=2)
    tdist = 0.0
    T = length(lat.state)

    states = lat.state
    probabilities = lat.probability

    Z = Array{Float64}(undef, T) # Array to hold the new samples generated7
    chosenPath = Array{Float64}(undef,T)

    #Stochastic approximation step starts here
    for n = 1 : nIterations
        Z .= vec(path()) # Draw a new sample Gaussian path
        dist = 0
        for t = 1 : T
            # corrective action to include lost nodes
            min_dist, new_index = findmin(abs.(vec(states[t][:, :, 1] .- Z[t]))) # find the closest lattice entry
            dist += min_dist^2  # Euclidean distance for the paths
            chosenPath[t] = new_index
        end
        # calculate the multistage distance
	tdist = (tdist .* (n - 1) + dist .^(r/2) )/ n
    end

    return( [ states[t][Int(chosenPath[t]),1,1 ] ]  )

end
