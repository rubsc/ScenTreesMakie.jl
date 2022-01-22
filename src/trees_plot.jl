"""
	tree_plot(trr::Tree,fig=1)

Returns the plot of the input tree annotated with density of
probabilities of reaching the leaf nodes in the tree.
Args:
- trr - A scenario tree.
- fig - Specifies the size of the image you want to be returned, default = 1.

Using the Plots version no Python has to be installed, the gr() backend works best at the moment (Fast and easy to use).
"""
function tree_plot(trr::Tree,fig = nothing, title = nothing, simple= false)

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
    
    f = plot(tmpX,tmpY);
    return(f)
end


