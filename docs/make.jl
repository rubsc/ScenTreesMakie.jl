using Documenter, ScenTreesMakie

push!(LOAD_PATH,"../src/")
makedocs(
	sitename =  "ScenTreesMakie.jl",
	authors = "Ruben Schlotter, Alois Pichler, Kirui Kipngeno",
	format = Documenter.HTML(prettyurls = false),
	pages = ["Home" => "index.md",
		"Tutorials" => Any["tutorial/tutorial1.md",
				    "tutorial/tutorial2.md",
				    "tutorial/tutorial3.md",
				    "tutorial/tutorial31.md",
				    "tutorial/tutorial4.md",
				    "tutorial/tutorial41.md",
				    "tutorial/tutorial5.md"
				]
		]
)

deploydocs(
	repo = "github.com/rubsc/ScenTreesMakie.jl.git",
	devbranch = "main"
	#target = "build",
	#versions = ["stable" => "v^", "v#.#", "dev" => "master"]
)
