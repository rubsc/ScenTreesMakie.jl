using Documenter
using ScenTrees

makedocs(
    sitename = "ScenTrees",
    format = Documenter.HTML(),
    modules = [ScenTrees]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
