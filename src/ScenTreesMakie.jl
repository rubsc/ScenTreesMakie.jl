module ScenTreesMakie

using Plots
gr()

include("TreeStructure.jl")
include("TreeApprox.jl")
include("StochPaths.jl")
include("LatticeApprox.jl")
include("KernelDensityEstimation.jl")
include("checkTree.jl")
include("trees_plot.jl")

export tree_approximation!,lattice_approximation,
        Tree, Lattice,
        stage,height,leaves,nodes,root,
        part_tree,build_probabilities!,
        gaussian_path1D,gaussian_path2D,
        running_maximum1D,running_maximum2D,path,kernel_scenarios, checkTree, 
        tree_path,
        tree_plot, plot_lattice, tree_path
end
