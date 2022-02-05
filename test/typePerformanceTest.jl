mutable struct MyType{T<:AbstractFloat}
    a::T
end
m = MyType(3.2)

func(m::MyType) = m.a+1

code_llvm(func, Tuple{MyType{Float64}})
code_llvm(func, Tuple{MyType{AbstractFloat}})


mutable struct TreeTest
    name::String                        # name of the tree
    parent::Vector{Int64}               # parents of nodes in the tree
    dist::Float64			# distance calculated in tree_approx
end
t = TreeTest("Test",[1, 2, 3, 4], 0.0)
typeof(t)

mutable struct TreeTest2{T <:Int, S <:AbstractFloat}
    parent::Vector{T}               # parents of nodes in the tree
    dist::S			# distance calculated in tree_approx
end
t2 = TreeTest2([1, 2, 3, 4], 0.0)
typeof(t2)


mutable struct TreeTest3{String,Int64, Float64}
    name::String
    parent::Vector{Int64}               # parents of nodes in the tree
    dist::Float64			# distance calculated in tree_approx
end
t3 = TreeTest3("Test",[1, 2, 3, 4], 0.0)
typeof(t3)



mutable struct Tree2{A <: AbstractString, T <:Int}
    name::A                         # name of the tree
    parent::Vector{T}               # parents of nodes in the tree
    children::Vector{Vector{Int64}}     # successor nodes of each parent
    state::Matrix{Float64}                # states of nodes in the tree
    probability::Matrix{Float64}          # probability to go from one node to another
    dist::Float64             			# distance calculated in tree_approx

    """
    	child(parent::Vector{Int64})

    Returns a vector of successors of each of the parent nodes.
    """
    function child(parent::Vector{Int64})
        allchildren = Vector{Vector{Int64}}([])
        for node in unique(parent)
            push!(allchildren, [i for i = 1 : length(parent) if parent[i] == node])
        end
        return allchildren
    end


    Tree2(name::String,parent::Vector{Int64},
    children::Vector{Vector{Int64}},
    state::Matrix{Float64}, probability::Matrix{Float64}, dist::Float64)=new{A,T}(name, parent, child(parent), state, probability,dist)

end