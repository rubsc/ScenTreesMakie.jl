
using JuMP, Clp



function distFunction(states1::Vector{Float64}, states2::Vector{Float64})::Array{Float64,2}
    n1= length(states1); n2= length(states2)
    dMatrix= Array{Float64}(undef, (n1,n2))
    for i= 1:n1, j= 1:n2
		dMatrix[i,j]= abs(states2[j]- states1[i])
    end
    return dMatrix
end


#	computes the Wasserstein distance
function Wasserstein(p1::Vector{Float64}, p2::Vector{Float64}, distMatrix::Array{Float64,2}, rWasserstein::Float64=1.)
	ontoSimplex!(p1); ontoSimplex!(p2)
    n1= length(p1);   n2= length(p2)

    A= kron(ones(n2)', Matrix{Float64}(I, n1, n1))
    B= kron(Matrix{Float64}(I, n2, n2), ones(n1)')

	model = Model(Clp.Optimizer)
	@variable(model, x[i=1:n1*n2] >= 0)
	@objective(model, Min, vec(distMatrix.^rWasserstein)' * x)
	@constraint(model, [A;B] * x .== [p1;p2])
	optimize!(model)
    return (distance= (objective_value(model))^(1/ rWasserstein), π= reshape(value.(x), (n1, n2)))
end


#	Sinkhorn-Knopp iteration algorithm
function Sinkhorn(p1::Vector{Float64}, p2::Vector{Float64}, distMatrix::Array{Float64,2}, rWasserstein::Float64= 1., λ::Float64= 1.)
	ontoSimplex!(p1); ontoSimplex!(p2); count= 0
	βr= Array{Float64}(undef, length(p1));
	γc= ones(size(p2))		# guess a starting value
	distMatrix.^= rWasserstein; K= exp.(-λ * distMatrix)
	while count < 1000		# Sinkhorn iteration
		γc= γc./ (p2'*γc)		# rescale
		βr= p1./ (K* γc)		# vector operation
		γc= p2./ (K'* βr)		# vector operation
		count += 1				# iteration count
	end
#	println("r=", βr, p1'*βr); println("c=", γc, p2'*γc)
	π= Diagonal(βr)*K*Diagonal(γc)
	return (distance= (sum(π.* distMatrix)) ^(1/rWasserstein), π= π)
end


function nestedWasserstein(trr1,trr2, rWasserstein::Float64=1.)
	#ToDo: make nested version for trees and lattices
	#ontoSimplex!(p1); ontoSimplex!(p2)
    	#n1= length(p1);   n2= length(p2)

    	#A= kron(ones(n2)', Matrix{Float64}(I, n1, n1))
    	#B= kron(Matrix{Float64}(I, n2, n2), ones(n1)')

	#model = Model(Clp.Optimizer)
	#@variable(model, x[i=1:n1*n2] >= 0)
	#@objective(model, Min, vec(distMatrix.^rWasserstein)' * x)
	#@constraint(model, [A;B] * x .== [p1;p2])
	#optimize!(model)
    #return (distance= (objective_value(model))^(1/ rWasserstein), π= reshape(value.(x), (n1, n2)))
end


# #	Sinkhorn-Knopp algorithm
# function Sinkhorn(p1::Vector{Float64}, p2::Vector{Float64}, distMatrix::Array{Float64,2}, rWasserstein::Float64= 1., λ::Float64= 1.)
# 	ontoSimplex!(p1); ontoSimplex!(p2)
# 	π= exp.(-λ * (distMatrix.^ rWasserstein))
# 	for i= 1:100
# 		π.*= (p2'./ sum(π, dims=1)) # scale to sum of column= 1
# 		π.*= (p1 ./ sum(π, dims=2)) # scale to sum of lines= 1
# 	end
# 	return (distance= sum(π.* distMatrix)^(1/ rWasserstein), π= π)
# end
