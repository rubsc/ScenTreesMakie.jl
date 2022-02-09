using ScenTreesMakie
using Test

@testset "ScenTreesMakie.jl" begin
    @testset "Predefined tree - Tree 402" begin
        a = Tree(402)
        @test length(a.parent) == 15
        @test length(a.state) == length(a.probability) == length(a.parent) == 15
        @test sum(a.probability) == 8.0
        @test length(a.children) == 8
        @test length(root(a)) == 1
    end
    @testset "Initial Trees" begin
        init = Tree([1,2,2,2])
        @test length(init.parent) == 15
        @test length(init.state) == length(init.probability) == length(init.parent) == 15
        @test length(init.children) == 8
        @test length(stage(init)) == 15
        @test height(init) == 3
        @test length(leaves(init)) == 3
        @test nodes(init) == 1:15
        @test length(nodes(init)) == 15
        @test length(root(init)) == 1
    end
    @testset "A sample of a Scenario Tree 1D" begin
        x = Tree([1,3,3,3,3])
        @test length(x.parent) == 121
        @test length(x.state) == length(x.probability) == length(x.parent) == 121
        @test length(x.children) == 41
        @test length(root(x)) == 1
        @test length(leaves(x)) == 3
    end
    @testset "Sample stochastic functions" begin
        a = gaussian_path1D()
        b = running_maximum1D()
        c = path()
        d = gaussian_path2D()
        e = running_maximum2D()
        @test length(a) == 4
        @test length(b) == 4
        @test length(c) == 4
        @test size(d) == (4,2)
        @test size(e) == (4,2)
    end
    @testset "ScenTrees.jl - Tree Approximation 1D" begin
        paths = [gaussian_path1D,running_maximum1D]
        trees = [Tree([1,2,2,2]),Tree([1,3,3,3])]
        samplesize = 100000
        p = 2
        r = 2
        tree_plot(trees[1])
        for path in paths
            for newtree in trees
                tree_approximation!(newtree,path,samplesize,p,r)
                @test length(newtree.parent) == length(newtree.state)
                @test length(newtree.parent) == length(newtree.probability)
                @test length(stage(newtree)) == length(newtree.parent)
                @test height(newtree) == maximum(stage(newtree))
                @test round(sum(leaves(newtree)[3]),digits=1) == 1.0   #sum of unconditional probabilities of the leaves
                @test length(root(newtree)) == 1
            end
        end
    end


    @testset "ScenTrees.jl - Lattice Approximation" begin
        tstLat = lattice_approximation([1,2,3,4],gaussian_path1D,500000,2,1)
        @test length(tstLat.state) == length(tstLat.probability)
        @test round.(sum.(tstLat.probability), digits = 1)  == [1.0, 1.0, 2.0, 3.0] #sum of probs at every stage
    end


   
end
