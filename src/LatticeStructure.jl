

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