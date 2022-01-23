
using Statistics, LinearAlgebra

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
    for n = 1 : nIterations
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

"""
	PlotLattice(lt::Lattice,fig=1)

Returns a plot of a lattice.
"""
function plot_lattice(lt::Lattice,fig = nothing, title = nothing)
    
    tmpX = []; tmpY = [];

    for t = 2:length(lt.state)
        for i=1:length(lt.state[t-1])
            for j=1:length(lt.state[t])
                x=[t-1;t]; y= [lt.state[t-1][i];lt.state[t][j]];
                append!(tmpX,x,NaN); append!(tmpY,y,NaN);                
            end
        end
    end
    
    f = plot(tmpX,tmpY, legend=:topleft);
    return(f)

end

