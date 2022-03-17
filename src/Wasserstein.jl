

"""
    distFunction(states1::Vector{Float64}, states2::Vector{Float64})::Array{Float64,2}

Calculates the distance abs(x-y) between all points of `states1` and `states2`. 
"""
function distFunction(states1::Vector{Float64}, states2::Vector{Float64})::Array{Float64,2}
    n1= length(states1); n2= length(states2)
    dMatrix= Array{Float64}(undef, (n1,n2))
    for i= 1:n1, j= 1:n2
		dMatrix[i,j]= abs(states2[j]- states1[i])
    end
    return dMatrix
end



"""
    Wasserstein(p1::Vector{Float64}, p2::Vector{Float64}, distMatrix::Array{Float64,2}, r::Float64=1.)

Calculates the Wasserstein with marginal distributions `p1` and `p2` for the distance matrix `distMatrix. 

Optionally the Hölder norm can be specified. The distance together with the optimal transport density is outputted. 
"""
function Wasserstein(p1::Vector{Float64}, p2::Vector{Float64}, distMatrix::Array{Float64,2}, r::Float64=1.)
	ontoSimplex!(p1); ontoSimplex!(p2)
    n1= length(p1);   n2= length(p2)

    A= kron(ones(n2)', Matrix{Float64}(I, n1, n1))
    B= kron(Matrix{Float64}(I, n2, n2), ones(n1)')

	model = Model(Clp.Optimizer)
	set_silent(model)
	@variable(model, x[i=1:n1*n2] >= 0)
	@objective(model, Min, vec(distMatrix.^r)' * x)
	@constraint(model, [A;B] * x .== [p1;p2])
	JuMP.optimize!(model)
    return (distance= (objective_value(model))^(1/ r), π= reshape(value.(x), (n1, n2)))
end


#	Sinkhorn-Knopp iteration algorithm
function Sinkhorn(p1::Vector{Float64}, p2::Vector{Float64}, distMatrix::Array{Float64,2}, r::Float64= 1., λ::Float64= 1.)
	ontoSimplex!(p1); ontoSimplex!(p2); count= 0
	βr= Array{Float64}(undef, length(p1));
	γc= ones(size(p2))		# guess a starting value
	distMatrix.^= r; K= exp.(-λ * distMatrix)
	while count < 1000		# Sinkhorn iteration
		γc= γc./ (p2'*γc)		# rescale
		βr= p1./ (K* γc)		# vector operation
		γc= p2./ (K'* βr)		# vector operation
		count += 1				# iteration count
	end
#	println("r=", βr, p1'*βr); println("c=", γc, p2'*γc)
	π= Diagonal(βr)*K*Diagonal(γc)
	return (distance= (sum(π.* distMatrix)) ^(1/r), π= π)
end



"""
    nestedWasserstein(trr1,trr2,r=2)

Calculates the nested distance based on the Wasserstein distance for two trees `trr1` and `trr2` Optionally the Hölder norm `r` can be specified.  
"""
function nestedWasserstein(trr1,trr2,r=1.0)
    T = height(trr1)
    #cumulProb!(trr1); cumulProb!(trr2);

    #d_new = Array{Float64}(undef,length(nodes(trr1,T)),length(nodes(trr2,T))).*0.0

    # initialize with all combinations of leave nodes of trr1 and trr2
    l1 = leaves(trr1)[1]; l2 = leaves(trr2)[1];
    println("distFunctionStart")
    d_new = distFunction(trr1.state[l1],trr2.state[l2]) 
    println("distFunctionEnd")

    for t= T-1:-1:0
       
        for (index1,i) in enumerate(nodes(trr1,t))
            #probability of transitioning from i to somewhere
            p1 = trr1.probability[trr1.children[i+1]]
            for (index2,j) in enumerate(nodes(trr2,t))
                p2 = trr2.probability[trr2.children[j+1]]
                #subset d_old for relevant index1/i and index2/j values
                ind1 = [findall(x->x==trr1.children[i+1][k], l1)[1] for k=1:length(trr1.children[i+1]) ]
                ind2 = [findall(x->x==trr2.children[j+1][k], l2)[1] for k=1:length(trr2.children[j+1]) ]
                d_old = d_new[ind1,ind2]
                # p1 is conditional (marginal) probability of transition for trr1
                d_new[index1,index2] = Wasserstein(p1,p2,d_old,r)[1]
            end

        end
        l1 = nodes(trr1,t); l2 = nodes(trr2,t)
        println(t)
    end
    return(d_new[1,1])
end


