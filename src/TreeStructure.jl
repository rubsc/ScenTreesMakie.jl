

#This defines the tree structure.
mutable struct Tree{String <: A <: String, Vector{Int64}<:B <: Vector{Int64}, Vector{Vector{Int64}} <:C<: Vector{Vector{Int64}}, D<: Vector{Float64}}
    name::String                 # name of the tree
    parent::B               # parents of nodes in the tree
    children::C             # successor nodes of each parent
    state::D                # states of nodes in the tree
    probability::D          # probability to go from one node to another

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
    state::D, probability::D) where {A,B,C,D} =new{A, B,C,D}(name, parent, child(parent), state, probability)
    Tree() = Tree("", Int64[], child(Int64[]), zeros(Float64, 0), ones(Float64, 0))


    """
    	Tree(identifier::Int64)

    Returns some examples of predefined trees.
    - These are (0, 302, 303, 304, 305, 306, 307, 402, 404, 405).
    - You can call any of the above tree and plot to see the properties of the tree.
    """
    function Tree(identifier::Int64)
        if identifier==0
            name = "Empty Tree"
            parent = zeros(Int64 , 0)
            children = child(parent)
            state = zeros(Float64, 0)
            probability = ones(Float64, 0)
            self = Tree(name, parent, child(parent), state, probability)
        elseif identifier == 302
            name = "Tree 1x2x2"
            parent =[0,1,1,2,2,3,3]
            children = child(parent)
            state = vec([2.0 2.1 1.9 4.0 1.0 3.0])
            probability = vec([1.0 0.5 0.5 0.5 0.5 0.5 0.5])
            self = Tree(name, parent, child(parent), state, probability)
        elseif identifier == 303
            name = "Tree 1x1x4"
            parent = [0,1,2,2,2,2]
            children = child(parent)
            state = vec([3.0 3.0 6.0 4.0 2.0 0.0])
            probability = vec([1.0 1.0 0.25 0.25 0.25 0.25])
            self = Tree(name, parent, child(parent), state, probability)
        elseif identifier == 304
            name = "Tree 1x4x1x1"
            parent = [0,1,2,0,4,5,0,7,8,0,10,11]
            children = child(parent)
            state = vec([0.1 2.1 3.0 0.1 1.9 1.0 0.0 -2.9 -1.0 -0.1 -3.1 -4.0])
            probability = vec([0.14 1.0 1.0 0.06 1.0 1.0 0.48 1.0 1.0 0.32 1.0 1.0])
            self = Tree(name, parent, child(parent), state, probability)
        elseif identifier == 305
            name = "Tree 1x1x4"
            parent = [0,1,2,2,2,2]
            children = child(parent)
            state = vec([0.0 10.0 28.0 22.0 21.0 20.0])
            probability = vec([1.0 1.0 0.25 0.25 0.25 0.25])
            self = Tree(name, parent, child(parent), state, probability)
        elseif identifier == 306
            name = "Tree 1x2x2"
            parent = [0,1,1,2,2,3,3]
            children = child(parent)
            state = vec([0.0 10.0 10.0 28.0 22.0 21.0 20.0])
            probability = vec([1.0 0.5 0.5 0.5 0.5 0.5 0.5])
            self = Tree(name, parent, child(parent), state, probability)
        elseif identifier == 307
            name = "Tree 1x4x1"
            parent = [0,1,1,1,1,2,3,4,5]
            children = child(parent)
            state = vec([0.0 10.0 10.0 10.0 10.0 28.0 22.0 21.0 20.0])
            probability = vec([1.0 0.25 0.25 0.25 0.25 1.0 1.0 1.0 1.0])
            self = Tree(name, parent, child(parent), state, probability)
        elseif identifier == 401
            name = "Tree 1x1x2x2"
            parent = [0,1,2,2,3,3,4,4]
            children = child(parent)
            state = vec([10.0 10.0 8.0 12.0 9.0 6.0 10.0 13.0])
            probability = vec([1.0 1.0 0.66 0.34 0.24 0.76 0.46 0.54])
            self = Tree(name, parent, child(parent), state, probability)
        elseif identifier == 402
            name = "Tree 1x2x2x2"
            parent = [0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
            children = child(parent)
            state = vec([10.0 12.0 8.0 15.0 11.0 9.0 5.0 18.0 16.0 13.0 11.0 10.0 7.0 6.0 3.0])
            probability = vec([1.0 0.8 0.2 0.3 0.7 0.8 0.2 0.6 0.4 0.5 0.5 0.4 0.6 0.7 0.3])
            self = Tree(name, parent, child(parent), state, probability)
        elseif identifier ==404
            name = "Tree 1x2x2x2"
            parent = [0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
            children = child(parent)
            state = (0.2+0.6744).*vec([0.0 1.0 -1.0 2.0 0.1 0.0 -2.0 3.0 1.1 0.9 -1.1 1.2 -1.2 -0.8 -3.2])
            probability = vec([1.0 0.3 0.7 0.2 0.8 0.1 0.9 0.5 0.5 0.6 0.4 0.4 0.6 0.3 0.7])
            self = Tree(name, parent, child(parent), state, probability)
        elseif identifier == 405
            name = "Tree 5"
            parent = [0,1,2,3,3,2,6,6,6,1,10,10,11,12,12,12]
            children = child(parent)
            state = vec([7.0 12.0 14.0 15.0 13.0 9.0 11.0 10.0 8.0 4.0 6.0 2.0 5.0 0.0 1.0 3.0])
            probability = vec([1.0 0.7 0.4 0.7 0.3 0.6 0.2 0.3 0.5 0.3 0.2 0.8 1.0 0.3 0.5 0.2])
            self = Tree(name, parent, child(parent), state, probability)
        end
        return self
    end


    """
    	Tree(bs::Vector{Int64})

    Returns a tree according to the specified branching vector and the dimension.

    Args:
    - bs - the branching structure of the scenario tree.

    The branching vector must start with 1 for the root node.
    """
    function Tree(bs::Vector{B}) where {B}
        #self = Tree("Tree $(bstructure)",  )
        self = Tree()
        self.name = "Tree $(bs)"

        leaves = cumprod(bs[1:end-1]) #probably not needed, as immediately overwritten in loop
        self.parent = Int32.([0])
        self.state = [1.0]
        self.children = [[1]]
        idx = 2
        for stage = 2 : length(bs)
            newleaves = vec(ones(Int64, bs[stage]) .* transpose(length(self.parent) .+ (1 .- leaves[stage-1] : 0)))
            self.parent =  vcat(self.parent, newleaves)
            for j=1:cumprod(bs)[stage-1]
                push!(self.children,collect(idx:idx+bs[stage]-1) ); idx += bs[stage];
            end
        end

        #self.children = child(self.parent)
        self.state = ones(length(self.parent));
        self.probability = similar(self.state);
        return self
    end
end


function children(parent)
    allchildren = Vector([])
    for node in unique(parent)
        push!(allchildren, [i for i = 1 : length(parent) if parent[i] == node])
    end
    return allchildren
end

"""
	stage(trr::Tree, node=Int64[])

Returns the stage of each node in the tree.

# Arguments:
- trr - an instance of a Tree.
- node - the number of node in the scenario tree you want to know its stage.
"""
function stage(trr::Tree{A,B,C,D}  , node = Int64[]) where {A,B,C,D}
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

Returns the height of the tree `trr` which is just the maximum number of the stages of each node.
"""
function height(trr::Tree{A,B,C,D}) where {A,B,C,D}
    return maximum(stage(trr))
end

"""
	leaves(trr::Tree,node=Int64[])

Returns the leaf nodes, their indexes and the conditional probabilities based on parent `node`.

# Arguments:
- trr - an instance of a Tree.
- node - a node for which all leaf nodes are found.

# Values
- leaves - a vector of leaf nodes.
- omegas - a vector of indizes indicating the order of the elements in `leaves`.
- prob - the conditional probability of each leaf node conditional on `node`.

If `node` is not given, then `node` is treated as the root node. 

"""
function leaves(trr::Tree{A,B,C,D}, node = Int64[]) where {A,B,C,D}
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

Returns the nodes in the tree `trr` at stage `t`.

# Example:

```julia-repl
julia> trr = Tree(404);
julia> nodes(trr,1)
2-element Vector{Int64}:
 2
 3
```
"""
function nodes(trr::Tree{A,B,C,D}, t = Int64[]) where {A,B,C,D}
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

#Arguments:
- trr - an instance of Tree.
- nodes - target node from root.

If `nodes` is not specified, it returns the root of the tree.

If `nodes` is specified, it returns a sequence of nodes from the root to the specified node.
"""
function root(trr::Tree{A,B,C,D}, nodes = Int64[]) where {A,B,C,D}
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
	part_tree(trr::Tree,node)

Returns a reduced tree starting at `node`. If `node` is the root node then original tree is returned. 

# Arguments:
- trr - an instance of Tree
- node - a node of trr which becomes the new root node.
"""
function part_tree(trr, node::Int64=0)
    if node == 0 || node == 1
        return(trr)
    end
    trr2 = deepcopy(trr)
    trr2.state[1] = trr2.state[node] 
    tmp = reverse(unique(trr2.parent)); pop!(tmp)
    for i in tmp
        if !(node ∈ root(trr2,[i]))
            # delete i from parents, children and states
            deleteat!(trr2.state, i .∈ trr2.parent)
            deleteat!(trr2.probability, i .∈ trr2.parent)
            deleteat!(trr2.parent, i .∈ trr2.parent)
        end
    end
       
    tmp = unique(trr2.parent[2:end])
    for j=1:length(tmp)
        trr2.parent[trr2.parent .== tmp[j]] .= j
    end
    
    trr2.children = children(trr2.parent)
    
    #trr2.parent[2:end] = trr2.parent[2:end] .- trr2.parent[2].+1
    return(trr2)
    
end



"""
	build_probabilities!(trr::Tree,probabilities::Array{Float64,2})

Returns the probabilities of the nodes without probabilities
if the array of probabilities is less than the length of parents
in the stochastic approximation procedure.
"""
function build_probabilities!(trr::Tree{A,B,C,D}, probabilities::Array{Float64,2}) where {A,B,C,D}
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
"""
    checkTree(tree0::Tree{A,B,C,D}, eps) where {A,B,C,D}

Transitions with zero probability are given positive probability `eps` such that conditional probabilities sum up to 1.0.

The correct adjustment can only be justified for each individual tree. Be careful in using this function as it can drastically alter
the tree process described by `tree0`.

"""
function checkTree(trr::Tree{A,B,C,D}, eps) where {A,B,C,D}

    # For every parent node going backwards
    tmp = reverse(unique(trr.parent)); pop!(tmp)
    for i in tmp
        #Note that the probs are the conditional ones
        prob = trr.probability[trr.children[i+1]]
        if any(x->x>0,prob)
          #do nothing
        else
          prob = prob .+ eps
          prob = prob./ sum(prob)
          trr.probability[trr.children[i+1]] = prob
        end

     end
     
end
    

"""
    cumulProb!(trr::Tree{A,B,C,D}) where {A,B,C,D}

modifies the probability vector of `trr` to show cumulative probabilities instead of conditional ones.
"""
function cumulProb!(trr::Tree{A,B,C,D}) where {A,B,C,D}
    for (index, node) in enumerate(trr.parent)
        if node==0
            #do nothing
        else
            trr.probability[index] = trr.probability[index] * trr.probability[node]
        end
    end 
    return(trr)
end