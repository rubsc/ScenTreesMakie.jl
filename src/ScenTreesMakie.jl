module ScenTreesMakie

using Plots
using StatsBase
using Distributions, Random
rng = MersenneTwister(01012019);
using Statistics, LinearAlgebra
gr()

include("TreeStructure.jl")
include("LatticeStructure.jl")
include("Approx.jl")
include("StochPaths.jl")

include("KernelDensityEstimation.jl")
include("plots.jl")


export tree_approximation!,lattice_approximation,
        Tree, Lattice,
        stage,height,leaves,nodes,root,
        part_tree,build_probabilities!,
        gaussian_path1D,gaussian_path2D,
        running_maximum1D,running_maximum2D,path,kernel_scenarios, checkTree, 
        tree_path,
        tree_plot, lat_plot, sample_path,
        path_ident, plot_path!
end
