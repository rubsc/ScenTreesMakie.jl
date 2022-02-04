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

    return(states[:][Int(chosenPath[:,1]) ,1,1  ])

end