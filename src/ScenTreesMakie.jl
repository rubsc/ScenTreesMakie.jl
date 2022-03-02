module ScenTreesMakie

using Plots
using StatsBase
using Distributions, Random
rng = MersenneTwister(01012019);
using Statistics, LinearAlgebra
using ProgressMeter
gr()

include("TreeStructure.jl")
include("LatticeStructure.jl")
include("Approx.jl")
include("StochPaths.jl")

include("KernelDensityEstimation.jl")
include("plots.jl")


export tree_approximation!,lattice_approximation,
        Tree, Lattice,

        stage,height,leaves,nodes,root, children, part_tree,build_probabilities!, checkTree,
        structure,
        gaussian_path, running_maximum, path,kernel_scenarios, 
        tree_path, tree_plot, lat_plot, sample_path,  plot_path!,

        path_ident
        
end
