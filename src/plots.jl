"""
	tree_plot(trr::Tree,fig=1)

Returns the plot of the input tree annotated with density of
probabilities of reaching the leaf nodes in the tree.
Args:
- trr - A scenario tree.
- fig - Specifies the size of the image you want to be returned, default = 1.

Using the Plots version no Python has to be installed, the gr() backend works best at the moment (Fast and easy to use).
"""
function tree_plot(trr::Tree{A,B,C,D,E},fig = nothing, title = nothing, simple= false, label=nothing) where {A,B,C,D,E}

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
        f = plot(tmpX,tmpY,legend=:topleft);
        return(f)
    else
        f = plot(tmpX,tmpY,legend=:topleft, label=label);
        return(f)
    end
end



"""
    sample_path(trr::Tree,nPath=1, flag_show=true)

Plots `nPath` sample paths of the tree `trr` weighted by the probability of the path occuring. 
TODO: plot whole tree, make opaque and only sample paths are dark
"""
function sample_path(trr::Tree{A,B,C,D,E}, nPath=1, flag_show=true, label=nothing) where {A,B,C,D,E}
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
        if flag_show==true
        
            for i = 1 : height(trr)
                x = [i,i+1]; y = [path_sim[i],path_sim[i+1]]
                tmpX = append!(tmpX,x,NaN)
                tmpY = append!(tmpY,y,NaN)
            end
            
        end

    end
    if flag_show==true
       if label===nothing
        f = plot(tmpX,tmpY,legend=:topleft);
       else
          f = plot(tmpX,tmpY,legend=:topleft,label=label);
       end
      return(f)
    end

    return(0)
end




########################################################################################################



"""
	PlotLattice(lt::Lattice,fig=1)

Returns a plot of a lattice.
There might connections with zero probability -->
these shouldn't be plotted! TODO
"""
function lat_plot(lt::Lattice,fig = nothing, title = nothing, label=nothing)
    
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
        f = plot(tmpX,tmpY, legend=:topleft);
        return(f)
    else
        f = plot(tmpX,tmpY, legend=:topleft,label=label);
        return(f)
    end

end



"""
Plots a given vector ontop of the tree/lattice


"""
function plot_path!(path,fig=nothing)
    tmpX = []; tmpY = [];
    for t=2:length(path)
        x = [t-1:t]; y = [path[t-1];path[t]];
        append!(tmpX,x,NaN); append!(tmpY,y,NaN);
    end

    f = plot!(tmpX,tmpY, legend = :topleft);
    return(f)

end