

#This defines the tree structure.
mutable struct Tree{String <: A <: AbstractString, B <: Vector{Int}, C<: Vector{Vector{Int}}, D<: Vector{Float64}, Float64 <: E <: Float64}
    name::String                 # name of the tree
    parent::B               # parents of nodes in the tree
    children::C             # successor nodes of each parent
    state::D                # states of nodes in the tree
    probability::D          # probability to go from one node to another
    dist::Float64             	# distance calculated in tree_approx

    """
    	child(parent::Vector{Int64})

    Returns a vector of successors of each of the parent nodes.
    """
    function child(parent::B) where {B}
        allchildren = Vector{B}([])
        for node in unique(parent)
            push!(allchildren, [i for i = 1 : length(parent) if parent[i] == node])
        end
        return allchildren
    end


    Tree(name::A,parent::B, children::C,
    state::D, probability::D, dist::E) where {A,B,C,D,E} =new{A, B,C,D, E}(name, parent, child(parent), state, probability,dist)
    Tree() = Tree("", Int64[], child(Int64[]), zeros(Float64, 0), ones(Float64, 0),0.0)

    #Tree(name::String,parent::Vector{Int64},
    #children::Vector{Vector{Int64}},S
    #state::Matrix{Float64}, probability::Matrix{Float64}, dist::Float64)=new(name, parent, child(parent), state, probability,dist)

    """
    	Tree(identifier::Int64)

    Returns some examples of predefined trees.
    - These are (0, 302, 303, 304, 305, 306, 307, 402, 404, 405).
    - You can call any of the above tree and plot to see the properties of the tree.
    """
    function Tree(identifier::Int64)
        dist = 0.0
        if identifier==0
            name = "Empty Tree"
            parent = zeros(Int64 , 0)
            children = child(parent)
            state = zeros(Float64, 0)
            probability = ones(Float64, 0)
            self = Tree(name, parent, child(parent), state, probability,dist)
        elseif identifier == 302
            name = "Tree 1x2x2"
            parent =[0,1,1,2,2,3,3]
            children = child(parent)
            state = vec([2.0 2.1 1.9 4.0 1.0 3.0])
            probability = vec([1.0 0.5 0.5 0.5 0.5 0.5 0.5])
            self = Tree(name, parent, child(parent), state, probability,dist)
        elseif identifier == 303
            name = "Tree 1x1x4"
            parent = [0,1,2,2,2,2]
            children = child(parent)
            state = vec([3.0 3.0 6.0 4.0 2.0 0.0])
            probability = vec([1.0 1.0 0.25 0.25 0.25 0.25])
            self = Tree(name, parent, child(parent), state, probability,dist)
        elseif identifier == 304
            name = "Tree 1x4x1x1"
            parent = [0,1,2,0,4,5,0,7,8,0,10,11]
            children = child(parent)
            state = vec([0.1 2.1 3.0 0.1 1.9 1.0 0.0 -2.9 -1.0 -0.1 -3.1 -4.0])
            probability = vec([0.14 1.0 1.0 0.06 1.0 1.0 0.48 1.0 1.0 0.32 1.0 1.0])
            self = Tree(name, parent, child(parent), state, probability,dist)
        elseif identifier == 305
            name = "Tree 1x1x4"
            parent = [0,1,2,2,2,2]
            children = child(parent)
            state = vec([0.0 10.0 28.0 22.0 21.0 20.0])
            probability = vec([1.0 1.0 0.25 0.25 0.25 0.25])
            self = Tree(name, parent, child(parent), state, probability,dist)
        elseif identifier == 306
            name = "Tree 1x2x2"
            parent = [0,1,1,2,2,3,3]
            children = child(parent)
            state = vec([0.0 10.0 10.0 28.0 22.0 21.0 20.0])
            probability = vec([1.0 0.5 0.5 0.5 0.5 0.5 0.5])
            self = Tree(name, parent, child(parent), state, probability,dist)
        elseif identifier == 307
            name = "Tree 1x4x1"
            parent = [0,1,1,1,1,2,3,4,5]
            children = child(parent)
            state = vec([0.0 10.0 10.0 10.0 10.0 28.0 22.0 21.0 20.0])
            probability = vec([1.0 0.25 0.25 0.25 0.25 1.0 1.0 1.0 1.0])
            self = Tree(name, parent, child(parent), state, probability,dist)
        elseif identifier == 401
            name = "Tree 1x1x2x2"
            parent = [0,1,2,2,3,3,4,4]
            children = child(parent)
            state = vec([10.0 10.0 8.0 12.0 9.0 6.0 10.0 13.0])
            probability = vec([1.0 1.0 0.66 0.34 0.24 0.76 0.46 0.54])
            self = Tree(name, parent, child(parent), state, probability,dist)
        elseif identifier == 402
            name = "Tree 1x2x2x2"
            parent = [0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
            children = child(parent)
            state = vec([10.0 12.0 8.0 15.0 11.0 9.0 5.0 18.0 16.0 13.0 11.0 10.0 7.0 6.0 3.0])
            probability = vec([1.0 0.8 0.2 0.3 0.7 0.8 0.2 0.6 0.4 0.5 0.5 0.4 0.6 0.7 0.3])
            self = Tree(name, parent, child(parent), state, probability,dist)
        elseif identifier ==404
            name = "Tree 1x2x2x2"
            parent = [0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
            children = child(parent)
            state = (0.2+0.6744).*vec([0.0 1.0 -1.0 2.0 0.1 0.0 -2.0 3.0 1.1 0.9 -1.1 1.2 -1.2 -0.8 -3.2])
            probability = vec([1.0 0.3 0.7 0.2 0.8 0.1 0.9 0.5 0.5 0.6 0.4 0.4 0.6 0.3 0.7])
            self = Tree(name, parent, child(parent), state, probability,dist)
        elseif identifier == 405
            name = "Tree 5"
            parent = [0,1,2,3,3,2,6,6,6,1,10,10,11,12,12,12]
            children = child(parent)
            state = vec([7.0 12.0 14.0 15.0 13.0 9.0 11.0 10.0 8.0 4.0 6.0 2.0 5.0 0.0 1.0 3.0])
            probability = vec([1.0 0.7 0.4 0.7 0.3 0.6 0.2 0.3 0.5 0.3 0.2 0.8 1.0 0.3 0.5 0.2])
            self = Tree(name, parent, child(parent), state, probability,dist)
        end
        return self
    end

    """
    	Tree(bstructure::Vector{Int64}, dimension=Int64[])

    Returns a tree according to the specified branching vector and the dimension.

    Args:
    - bstructure - the branching structure of the scenario tree.

    The branching vector must start with 1 for the root node.
    """
    function Tree(bstructure::Vector{Int64})
        dist = 0.0
        self = Tree()
        leaves = bstructure
        for stage = 1 : length(bstructure)
            if stage == 1
                leaves = 1
                self.name = "Tree $(bstructure[1])"
                self.parent = zeros(Int64, bstructure[1])
                self.children = child(self.parent)
                self.state = randn(rng, bstructure[1])
                self.probability = ones(bstructure[1])
            else
                leaves = leaves * bstructure[stage-1]
                newleaves = vec(ones(Int64, bstructure[stage]) .* transpose(length(self.parent) .+ (1 .- leaves : 0)))
                self.parent =  vcat(self.parent, newleaves)
                self.children = child(self.parent)
                self.state = vcat(self.state, randn(length(newleaves)))
                self.name = "$(self.name)x$(bstructure[stage])"
                tmp = rand(rng, Uniform(0.3, 1.0), bstructure[stage], leaves)
                tmp = tmp ./ (transpose(ones(1, bstructure[stage])) .* sum(tmp, dims = 1))
                self.probability = vcat(self.probability, vec(tmp))
            end
        end

        return self
    end
end

"""
	stage(trr::Tree, node=Int64[])

Returns the stage of each node in the tree.

Args:
- trr - an instance of a Tree.
- node - the number of node in the scenario tree you want to know its stage.
"""
function stage(trr::Tree{A,B,C,D,E}  , node = Int64[]) where {A,B,C,D,E}
    if isempty(node)
        node = 1 : length(trr.parent) 
    elseif isa(node, Int64)
        node = Int64[node]
    end
    #stage = zeros(length(collect(node))) #you can also use this
    stage = zero(node)
    for i = 1 : length(node)
        pred = node[i]
        while pred > 0 && trr.parent[pred] > 0
            pred = trr.parent[pred]
            stage[i] += 1
        end
    end
    return stage
end

"""
	height(trr::Tree)

Returns the height of the tree which is just the maximum number of the stages of each node.

Args:
- trr - an instance of a Tree.
"""
function height(trr::Tree{A,B,C,D,E}) where {A,B,C,D,E}
    return maximum(stage(trr))
end

"""
	leaves(trr::Tree,node=Int64[])

Returns the leaf nodes, their indexes and the conditional probabilities.

Args:
- trr - an instance of a Tree.
- node - a node in the tree you want to its children.
"""
function leaves(trr::Tree{A,B,C,D,E}, node = Int64[]) where {A,B,C,D,E}
    nodes = 1 : length(trr.parent)
    leaves = setdiff(nodes, trr.parent)
    #leaves are all nodes which are not parents
    #setdiff(A,B) finds all the elements that belongs to A and are not in B
    omegas = 1 : length(leaves)
    if !isempty(node) && isa(node,Int64)
        node = Int64[node]
    end
    if !isempty(node) && (0 ∉ node)
        omegas = Set{Int64}()
        nodes = leaves
        while any(j !=0 for j ∈ nodes)
            omegas = union(omegas, (ind for (ind, j) ∈ enumerate(nodes) if j ∈ node))
            nodes = Int64[trr.parent[max(0 , j)] for j ∈ nodes]
        end
        omegas = collect(omegas)
    end
    leaves = Int64[leaves[j] for j ∈ omegas]
    prob = ones(Float64 , length(leaves))
    nodes = leaves
    while any(j !=0 for j ∈ nodes)
        prob = prob .* trr.probability[[j for j in nodes]]
        nodes = Int64[trr.parent[max(0 , j)] for j ∈ nodes]
    end
    return leaves, omegas, prob
end

"""
	nodes(trr::Tree,t=Int64[])

Returns the nodes in the tree, generally the range of the nodes in the tree.

Args:
- trr - an instance of a Tree.
- t  - stage in the tree.

Example : nodes(trr,2) - gives all nodes at stage 2.
"""
function nodes(trr::Tree{A,B,C,D,E}, t = Int64[]) where {A,B,C,D,E}
    nodes = 1 : length(trr.parent)
    if isempty(t) #if stage t is not given, return all nodes of the tree
        return nodes
    else # else return nodes at the given stage t
        stg = stage(trr)
        return Int64[i for i in nodes if stg[i] == t]
    end
end

"""
	root(trr::Tree,nodes=Int64[])
Returns the root of the tree if the node is not specified.

Args:
- trr - an instance of Tree.
- nodes - node in the tree you want to know the sequence from the root.

If `nodes` is not specified, it returns the root of the tree.

If `nodes` is specified, it returns a sequence of nodes from the root to the specified node.
"""
function root(trr::Tree{A,B,C,D,E}, nodes = Int64[]) where {A,B,C,D,E}
    if isempty(nodes)
        nodes = trr.children[1]
    elseif isa(nodes , Int64)
        nodes = Int64[nodes]
    end
    root = 1 : length(trr.parent)
    for i in nodes
        iroot = Vector{Int64}([])       # parameterize with B
        tmp = i
        while tmp > 0
            push!(iroot , tmp)
            tmp = trr.parent[tmp]
        end
        root = Int64[i for i in reverse(iroot) if i in root]
    end
    return root
end

"""
	part_tree(trr::Tree)

Returns a vector of trees in d-dimension.

Args:
- trr - an instance of Tree.
"""
function part_tree(trr::Tree{A,B,C,D,E}) where {A,B,C,D,E}
    trees = Tree[]
    for col = 1:size(trr.state , 2)
        subtree = Tree("Tree of state $col", trr.parent, trr.children, hcat(trr.state[:,col]), trr.probability)
        push!(trees,subtree)
    end
    return trees
end



"""
	build_probabilities!(trr::Tree,probabilities::Array{Float64,2})

Returns the probabilities of the nodes without probabilities
if the array of probabilities is less than the length of parents
in the stochastic approximation procedure.
"""
function build_probabilities!(trr::Tree{A,B,C,D,E}, probabilities::Array{Float64,2}) where {A,B,C,D,E}
    leaf, omegas, probaLeaf = leaves(trr)
    if length(probabilities) == length(nodes(trr))
        trr.probability .= probabilities
    else
        probabilities .= max.(0.0,probabilities)
        j = leaf; i = trr.parent[j]; j .= j[i .> 0]; i .= i[i .> 0]
        trr.probability .= zeros(length(trr.state), 1)[:,1]
        trr.probability[j] = probabilities
        while !isempty(i)
            for k = 1:length(i)
                trr.probability[i[k]] = trr.probability[i[k]] + trr.probability[j[k]]
            end
            trr.probability[j] .= trr.probability[j] ./ trr.probability[i]
            trr.probability[isnan.(trr.probability)] .= 0.0
            j = unique(i); i = trr.parent[j]; j = j[i .> 0] ; i = i[i .> 0]
        end
    end
    return trr.probability
end


# Checks if probabilities are strictly positive and if not adjusts slightly. 
# What adjustments can be justified have to be determined in each instance.

function checkTree(tree0::Tree{A,B,C,D,E}, eps) where {A,B,C,D,E}

    # For every parent node going backwards
    tmp = reverse(unique(tree0.parent)); pop!(tmp)
    for i in tmp
        #Note that the probs are the conditional ones
        prob = tree0.probability[tree0.children[i+1]]
        if any(x->x>0,prob)
          #do nothing
        else
          prob = prob .+ eps
          prob = prob./ sum(prob)
          println()
          println("updated tree")
        end
      end
    
    end
    