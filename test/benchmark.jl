#using ScenTreesMakie
#using LinearAlgebra

# Benchmarks different versions of the tree structure Tree() with type annotations or without
# and some constructor optimization

# Test branching structure
#bs = [1,2,2,2,2,2,2,2,2,2,2,2,2,2,2];  n = length(bs) 

# Current ScenTreesMakie version, with parameterized types
#    trr = ScenTreesMakie.Tree(bs);
#    trr2 = trr;
#    path3() = ScenTreesMakie.gaussian_path(n)

    # benchmarking approxiation for ScenTreesMakie version with type annotation    

 #   @time ScenTreesMakie.tree_approximation!(trr,path3,10,2,2);

    # Alois Version of tree_approximation
#    @time tree_approximation2!(trr2,path3,10,2,2);

