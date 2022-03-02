"""
Provides some useful functions for dealing with tree models and tree approximation using nested distance
Needs more ideas!

"""

function summary(tree0::Tree{A,B,C,D}) where {A,B,C,D}
    println()
    println("Tree with $(maximum(stage(tree0))+1) stages and branching structure $(tree0.name[6:end]) .")
    println("The tree has $(length(tree0.state)) nodes")
end


"""
	@author: Alois Pichler
	Created September 2018
		provides ontoSimplex: function to project onto the simplex
"""

function ontoSimplex!(probabilities::Vector{Float64})   # projects the probabilities onto the simplex
    for i= 1:length(probabilities)
        if probabilities[i] < 0.0   # make them nonnegative
            probabilities[i]= 0.0
        end
    end
	summ= sum(probabilities)
	if summ <= 0.0
		probabilities= fill!(probabilities, 1.0/ length(probabilities))
		summ= sum(probabilities)
		@info "ontoSimplex: created probabilities." maxlog=1
	end
	if summ != 1
		probabilities./= summ
		tmpi= rand(1:length(probabilities)) 	# modify a random index
		summ= -sum(probabilities[1:tmpi-1])+ 1.0- sum(probabilities[tmpi+1:end])
		probabilities[tmpi]= max(0, summ)
		@info "ontoSimplex: modified probabilities." maxlog=1
	end
    nothing     # modifies probabilities
end