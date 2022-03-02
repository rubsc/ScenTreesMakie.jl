"""
Provides some useful functions for dealing with tree models and tree approximation using nested distance
Needs more ideas!

"""

function summary(tree0::Tree{A,B,C,D,E}) where {A,B,C,D,E}
    println()
    println("Tree with $(maximum(stage(tree0))+1) stages and branching structure $(tree0.name[6:end]) .")
    println("The tree has $(length(tree0.state)) nodes")
    println("If applicable, the tree has a nested distance to the fitted paths of $(round(tree0.dist,digits=5)).")
end

function splitStructure(tree0::Tree{A,B,C,D,E}) where {A,B,C,D,E}
    return(tree0.name[5:end])
end

