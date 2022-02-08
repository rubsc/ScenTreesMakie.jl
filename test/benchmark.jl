using ScenTreesMakie
using ScenTrees

# Benchmarks different versions of the tree structure Tree() with type annotations or without
# and some constructor optimization

# Test branching structure
bs = [1,2,2,2,2,2,2,2,2,2,2,2,2,2,2];  n = length(bs)
bs2 = Int32.(bs); 

# Current ScenTreesMakie version, with parameterized types
    @time trr = ScenTreesMakie.Tree(bs);

    # benchmarking approxiation for ScenTreesMakie version with type annotation
    path3() = ScenTreesMakie.gaussian_path1D(n)
    @time ScenTreesMakie.tree_approximation2!(trr,path3,1,2,2);


# Alois version of ScenTrees without type annotation and without constructor optimization
    @time trr2 = ScenTrees.Tree(bs);
    @time ScenTrees.tree_approximation!(trr2,path3,100,2,2);

