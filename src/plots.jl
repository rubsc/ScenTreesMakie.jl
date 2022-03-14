"""
	plot(trr::Tree,title=nothing, simple = false, label=nothing)

Returns the plot of the input tree `trr`.

# Arguments
- trr - A scenario tree.
- title - A title for the plot.
- simple - if simple is true, then unreachable paths are dropped, see details below.
- label - optional labels with LaTeX support. 

# Value
    - returns the plot as a gr() figure.

# Details: 
    if simple is equal to true then states valued at 0.0 and have 0.0 probability to be reached are not plotted. 
    To make use of this feature the `check_tree()` routine should be used before (SLOW!)
"""
function plot(trr::Tree{A,B,C,D}, title = nothing, simple= false, label=nothing) where {A,B,C,D}

    stg = stage(trr)
    tmpX = []; tmpY = [];
    if (simple == true)
        for i = 1 : length(trr.parent)
            if stg[i] > 0
                if (trr.state[trr.parent[i]] != 0 && trr.probability[trr.parent[i]] > 0)
                    if trr.state[i] != 0 && trr.probability[i] >0
			            x=[stg[i];stg[i]+1]; y= [trr.state[trr.parent[i]];trr.state[i]];
                    	tmpX = append!(tmpX,x,NaN)
                    	tmpY = append!(tmpY,y,NaN)
                    end
                end
            end
        end

    else # simple= false, DEFAULT
        for i = 1 : length(trr.parent)
            if stg[i] > 0
                x=[stg[i];stg[i]+1]; y= [trr.state[trr.parent[i]];trr.state[i]];
                tmpX = append!(tmpX,x,NaN)
                tmpY = append!(tmpY,y,NaN)
            end
        end

    end
    
    if label=== nothing
        f = Plots.plot(tmpX,tmpY,legend=:topleft);
        return(f)
    else
        f = Plots.plot(tmpX,tmpY,legend=:topleft, label=label);
        return(f)
    end
end





"""
	plot!(trr::Tree,title=nothing, simple = false, label=nothing)

Adds an additional tree plot to an existing plot using `plot!()`. See `tree_plot()` for details.
"""
function plot!(trr::Tree{A,B,C,D},offset=0, title = nothing, simple= false, label=nothing) where {A,B,C,D}

    stg = stage(trr)
    tmpX = []; tmpY = [];
    if (simple == true)
        for i = 1 : length(trr.parent)
            if stg[i] > 0
                if (trr.state[trr.parent[i]] != 0 && trr.probability[trr.parent[i]] > 0)
                    if trr.state[i] != 0 && trr.probability[i] >0
			            x=[stg[i]+offset;stg[i]+1+offset]; y= [trr.state[trr.parent[i]];trr.state[i]];
                    	tmpX = append!(tmpX,x,NaN)
                    	tmpY = append!(tmpY,y,NaN)
                    end
                end
            end
        end

    else # simple= false, DEFAULT
        for i = 1 : length(trr.parent)
            if stg[i] > 0
                x=[stg[i]+offset;stg[i]+1+offset]; y= [trr.state[trr.parent[i]];trr.state[i]];
                tmpX = append!(tmpX,x,NaN)
                tmpY = append!(tmpY,y,NaN)
            end
        end

    end
    
    if label=== nothing
        Plots.plot!(tmpX,tmpY,legend=:topleft);
    else
        Plots.plot!(tmpX,tmpY,legend=:topleft, label=label);
    end
end














"""
    sample_path(trr::Tree,nPath=1, flag_show=true)

Plots `nPath` sample paths of the tree `trr` weighted by the probability of the path occuring. 
TODO: plot whole tree, make opaque and only sample paths are dark
"""
function sample_path(trr::Tree{A,B,C,D}, nPath=1, flag_show=true, label=nothing) where {A,B,C,D}
# generates nPath simulations of tree0 model and optionally plots them
    stages = height(trr);
    tmpX = []; tmpY = [];
    for j=1:nPath
        path_sim = zeros(stages+1)
        path_sim[1] = trr.state[1];

        selection = trr.children[1][1]
        path_sim[1] = trr.state[selection]
        for i=2:stages+1
        #pick child of stages[i] , i=1 gives root node
            parents = selection
            child   = trr.children[findfirst(x -> x==parents,unique(trr.parent))]
            prob = trr.probability[child]

        #random selection according to weights --> selection
            selection = StatsBase.sample(child, StatsBase.Weights(prob))
            path_sim[i] = trr.state[selection]
        end

        ###############
        # Plot stuff
        for i = 1 : height(trr)
            x = [i,i+1]; y = [path_sim[i],path_sim[i+1]]
            tmpX = append!(tmpX,x,NaN)
            tmpY = append!(tmpY,y,NaN)
        end
        
    end

    if label===nothing
        f = Plots.plot(tmpX,tmpY,legend=:topleft);
    else
        f = Plots.plot(tmpX,tmpY,legend=:topleft,label=label);
    end
    return(f)
end




########################################################################################################


"""
	plot(lt::Lattice,title = nothing, label=nothing)

Returns a plot of a scenario lattice.

# Arguments
- lt - A scenario lattice.
- title - A title for the plot.
- simple - if simple is true, then unreachable paths are dropped, see details below.
- label - optional labels with LaTeX support. 

# Value
    - returns the plot as a gr() figure.

# Details: 
    if simple is equal to true then states valued at 0.0 and have 0.0 probability to be reached are not plotted. 
    To make use of this feature the `check_tree()` routine should be used before (SLOW!)

There might connections with zero probability -->
these shouldn't be plotted! TODO
"""
function plot(lt::Lattice, title = nothing,simple=false, label=nothing)
    
    tmpX = []; tmpY = [];

    for t = 2:length(lt.state)
        for i=1:length(lt.state[t-1])
            for j=1:length(lt.state[t])
                x=[t-1;t]; y= [lt.state[t-1][i];lt.state[t][j]];
                append!(tmpX,x,NaN); append!(tmpY,y,NaN);                
            end
        end
    end
    
    if label===nothing
        f = Plots.plot(tmpX,tmpY, legend=:topleft);
        return(f)
    else
        f = Plots.plot(tmpX,tmpY, legend=:topleft,label=label);
        return(f)
    end

end



"""
    plot_path!(path)

Plots a given vector `path` on top of the tree/lattice


"""
function plot_path!(path)
    tmpX = []; tmpY = [];
    for t=2:length(path)
        x = [t-1:t]; y = [path[t-1];path[t]];
        append!(tmpX,x,NaN); append!(tmpY,y,NaN);
    end

    f = Plots.plot!(tmpX,tmpY, legend = :topleft);
    return(f)

end
