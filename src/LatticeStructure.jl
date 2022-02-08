

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


function path_ident(lat::Lattice, path::Function, nIteration::Int64, r::Int64=2)
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
