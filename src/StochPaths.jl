
"""
	gaussian_path(n::Int64 = 4)

Returns a 'nx1' dimensional array of Gaussian random walk.
"""
function gaussian_path(n::Int64 = 4)
    return vcat(0.0, cumsum(randn(rng, n-1, 1), dims = 1)) #n stages
end


"""
	running_maximum(n::Int64 = 4)

Returns a 'nx1' dimensional array of Running Maximum process.
"""
function running_maximum(n::Int64 = 4)
    rmatrix = vcat(0.0, cumsum(randn(rng, 3, 1), dims = 1))
    for i = 2 : 4
        rmatrix[i] = max.(rmatrix[i-1], rmatrix[i])
    end
    return rmatrix
end



