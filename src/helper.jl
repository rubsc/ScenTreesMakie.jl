"""
Provides some useful functions for dealing with tree models and tree approximation using nested distance
Needs more ideas!

"""

function summary(tree0::Tree)
    println()
    println("Tree with $(maximum(stage(tree0))+1) stages and branching structure $(tree0.name[6:end]) .")
    println("The tree has $(length(tree0.state)) nodes")
    println("If applicable, the tree has a nested distance to the fitted paths of $(round(tree0.dist,digits=5)).")
end

function splitStructure(tree0::Tree)
    return(tree0.name[5:end])
end



################################
# Provide Julia wrapper functions to stochastic mortality models (hrStoMoMore)
# Provide plots of sample paths?
# Provide counter of number of nodes
# Provide estimated run time of tree_approximation! ?

# Provide shading of likely tree scenarios
# Provide scaled plots to eliminated trend? --> nicer plot, better shading available

# make use of the idea in bushiness to find better tree structure ???
# helper function to save and read trees for documentation
# create size and length methods for tree structures
