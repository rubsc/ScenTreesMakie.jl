#All these examples of path are in 4 stages



"""
	gaussian_path1D()

Returns a '4x1' dimensional array of Gaussian random walk
"""
function gaussian_path1D(n::Int64 = 4)
    return vcat(0.0, cumsum(randn(rng, n-1, 1), dims = 1)) #n stages
end

"""
	gaussian_path2D()

Returns a '4x2' dimensional array of Gaussian random walk
"""
function gaussian_path2D(n::Int64 = 4)
    gsmatrix = randn(rng, 4, 2) * [1.0 0.0 ; 0.9 0.3] #will create an (dimension x nstages) matrix
    gsmatrix[1,:] .= 0.0
    return cumsum(gsmatrix .+ [1.0 0.0], dims = 1)
end

"""
	running_maximum1D()

Returns a '4x1' dimensional array of Running Maximum process.
"""
function running_maximum1D(n::Int64 = 4)
    rmatrix = vcat(0.0, cumsum(randn(rng, 3, 1), dims = 1))
    for i = 2 : 4
        rmatrix[i] = max.(rmatrix[i-1], rmatrix[i])
    end
    return rmatrix
end

"""
	running_maximum2D()

Returns a '4x2' dimensional array of Running Maximum process.
"""
function running_maximum2D(n::Int64 = 4)
    rmatrix = vcat(0.0, cumsum(randn(rng, 3, 1), dims = 1))
    rmatrix2D = zeros(4, 2)
    rmatrix2D[:,1] .= vec(rmatrix)
    for j = 2 : 2
        for i = 2 : 4
            rmatrix2D[i,j] = max.(rmatrix[i-1], rmatrix[i])
        end
    end
    return rmatrix2D * [1.0 0.0; 0.9 0.3]
end

"""
	path()

Returns a sample of stock prices following the a simple random random process.
"""
function path(n::Int64 = 4)
    return  100 .+ 50 * vcat(0.0, cumsum(randn(rng, n-1, 1), dims = 1))
end
