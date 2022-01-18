using Test
include("Wasserstein.jl")


#	test Wasserstein
println("\n____________ Test Wasserstein.jl")
p1= [.3, 0.7]
s1= [-.7, 1.1]
p2= [0.2, 0.3, 0.2, 0.1, 0.2]
s2= [-.3, .9, 1.7, 3.2, 1.9]
d= distFunction(s1, s2)

@show A= Wasserstein(p1, p2, distFunction(s1, s2), 2.)

@test A.distance ≈ 0.9679876032264049
@test A.π ≈ [0.2 0.1 0.0 0.0 0.0; 0.0 0.2 0.2 0.1 0.2]

println()
@show A= Sinkhorn(p1, p2, distFunction(s1, s2), 2., 4.3)
@test A.distance ≈ 0.967988 atol= 1e-4
@test A.π ≈ [0.2 0.1 0.0 0.0 0.0; 0.0 0.2 0.2 0.1 0.2] atol = 1e-6

println()
@show A= Sinkhorn(p1, p2, distFunction(s1, s2), 2., 1.)
@test A.distance ≈ 0.9923876770989377 atol = .01
@test A.π ≈ [0.2 0.1 0.0 0.0 0.0; 0.0 0.2 0.2 0.1 0.2] atol = 0.02
