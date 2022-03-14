module ScenTreesMakie

using Plots
using StatsBase
using Distributions, Random
rng = MersenneTwister(01012019);
using Statistics, LinearAlgebra
using ProgressMeter
using JuMP, Clp
gr()

include("TreeStructure.jl")
include("LatticeStructure.jl")
include("Approx.jl")
include("StochPaths.jl")

include("KernelDensityEstimation.jl")
include("plots.jl")
include("helper.jl")
include("Wasserstein.jl")


export Tree, Lattice,
        tree_approximation!,lattice_approximation,

        stage,height,leaves,nodes,root, children, part_tree,build_probabilities!, checkTree,
        structure, part_lattice,
        gaussian_path, running_maximum, kernel_scenarios, 
        tree_plot,tree_plot!, lat_plot, sample_path,  plot_path!,
        plot,

        path_ident,  

        ontoSimplex!, summary,

        distFunction, Wasserstein, Sinkhorn, nestedWasserstein
        
end
