

mutable struct Lattice
    name::String
    state::Array{Array{Float64,3},1}
    probability::Array{Array{Float64,3},1}
    Lattice(name::String, state::Array{Array{Float64,3},1}, probability::Array{Array{Float64,3},1}) = new(name, state, probability)
	
    

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


function path_ident(lat::Lattice, path::Function, nIteration::Int64, r::Int64=2, dim::Int64=1)
    tdist = zeros(dim)
    if dim >1
        return("ERROR, dimension not 1")
    end
    T = length(lat.state)

    states = lat.state
    probabilities = lat.probability

    Z = Array{Float64}(undef, T, 1) # Array to hold the new samples generated7
    chosenPath = Array{Float64}(undef,T,1)

    #Stochastic approximation step starts here
    for n = 1 : nIterations
        Z .= path() # Draw a new sample Gaussian path
        dist = zeros(dim)
        for t = 1 : T
            # corrective action to include lost nodes
            min_dist, new_index = findmin(abs.(vec(states[t][:, :, 1] .- Z[t,1]))) # find the closest lattice entry
            dist[i] += min_dist^2  # Euclidean distance for the paths
            chosenPath[t,1] = new_index
        end
        # calculate the multistage distance
        dist = dist .^ (1/2); tdist = (tdist .* (n - 1) + dist .^r )/ n
        #tdist = (tdist*(n-1) + dist)/n
    end

    return( [ states[t][Int(chosen[t,1]),1,1 ] ]  )

end
