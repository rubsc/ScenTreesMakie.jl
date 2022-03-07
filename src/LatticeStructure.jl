

mutable struct Lattice
    name::String
    state
    probability
    
    Lattice(name::String, state, probability) = new(name, state, probability)
	
    

function Lattice(identifier::Int64)
    self= new()
    if identifier == 302
        self.name = "Lattice 1x2x2"
        self.state = [[0.0],[-0.856;0.933],[-1.27;1.307]]
        self.probability = [[1.0],[0.52;0.48],[0.75 0.25;0.26 0.74]]
    elseif identifier == 303
        self.name = "Lattice 1x1x4"
        self.state = [[0.0],[0.02],[-1.27;1.307;2.2;1.4]]
        self.probability = [[1.0],[1.0],[0.25 0.25 0.25 0.25]]
    elseif identifier == 304
        self.name = "Tree 1x2x3x4"
        self.state = [[0.0],[-0.856;0.933],[-1.27;1.307;2.0],[-2.5;-0.5;2.5;0.5]]
        self.probability = [[1.0],[0.52;0.48],[0.35 0.35 0.3; 0.1 0.5 0.4],[0.25 0.25 0.25 0.25;0.25 0.25 0.25 0.25;0.25 0.25 0.25 0.25]]
    end
    return self
end
end

######################################################################################
# Include helper functions for lattices here
# similar to Tree structure
"""
    structure(lat::Lattice)

Provides a summary on the branching structure of the lattice `lat`.

# Values
   - `bs`: vector indicating the number of nodes in each stage, i.e. the branching structure.
   - `nodes`: the total number of nodes.
   - `edges`: the total number of edges.
   - `paths`: the total number of unique paths.


# Example
```julia-repl
julia> lat = Lattice(304);
julia> structure(lat)
([1, 2, 3, 4], 10, 20, 24)
```

"""
function structure(lat::Lattice)
    bs = [length(lat.state[i]) for i=1:length(lat.state)]; 

    edges = 0
    for i=2:length(bs)
        edges += bs[i-1]*bs[i]
    end

    nodes = sum(bs)
    paths = prod(bs)

    return bs, nodes,edges, paths
end




"""
    part_lattice(lat, hist=nothing)

Provides a subtree given an observed history `hist`. If no history is provided the lattice is returned.


# Example
	lat = Lattice(304);
	hist = [1 2]
	part_lattice(lat, hist)
"""
function part_lattice(lat, hist=nothing)
    if (hist === nothing || hist == [])
        return(lat)
    end
    tmp_states = []; tmp_prob = [];
    lat2 = deepcopy(lat)
    for t=1:length(hist)
        push!(tmp_states,lat.state[t][Int(hist[t]),1,1 ])
        push!(tmp_prob,lat.probability[t][1,Int(hist[t]),1])
        if t>1
            deleteat!(lat2.state, 2) # delete everything after initial node up to observed history
            deleteat!(lat2.probability, 2) # stages move up hence 2nd entry is deleted mulitple times
        end
    end

    lat2.state[1] .= tmp_states[end];
    

    return(lat2)
 
    
end
