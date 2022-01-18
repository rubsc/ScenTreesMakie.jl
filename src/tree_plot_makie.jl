"""
	tree_plot(trr::Tree,fig=1)

Returns the plot of the input tree annotated with density of
probabilities of reaching the leaf nodes in the tree.
Args:
- trr - A scenario tree.
- fig - Specifies the size of the image you want to be returned, default = 1.

Using the Makie version no Python has to be installed.
"""
function tree_plot(trr::Tree,fig = nothing, tit = nothing), simple= false

    stg = stage(trr)
    
    if fig === nothing
        f = Figure(backgroundcolor = :gray80, resolution = (1000, 700))
    else
        f = fig;
    end

    ga = f[1, 1] = GridLayout(); gb = f[1, 2] = GridLayout();

    axmain = Axis(ga[1, 1], xlabel = "Stages / Time", ylabel = "Values");
    axright = Axis(ga[1, 2]);
    #linkyaxes!(axmain, axright);

    if (simple == true)
        for i = 1 : length(trr.parent)
            if stg[i] > 0
                if (trr.state[trr.parent[i]] != 0 && trr.probability[trr.parent[i]] > 0)
                    if trr.state[i] != 0 && trr.probability[i] >0
                        tmp = DataFrame(x=[stg[i],stg[i]+1], y= [trr.state[trr.parent[i]],trr.state[i]])
                        lines!(axmain,tmp.x,tmp.y)
                    end
                end
            end
        end

    else # simple= false, DEFAULT
        for i = 1 : length(trr.parent)
            if stg[i] > 0
                tmp = DataFrame(x=[stg[i],stg[i]+1], y= [trr.state[trr.parent[i]],trr.state[i]])
                lines!(axmain,tmp.x,tmp.y)
            end
        end

    end
    
    (Yi,_,probYi) = leaves(trr)
    Yi = [trr.state[i] for i in Yi]
    
    density!(axright, Yi, direction = :y)

    xlims!(axright, low = 0)
    #hidedecorations!(axright, grid = false)
    colgap!(ga, 10)
    rowgap!(ga, 10)
    Label(ga[1, 1:2, Top()], "Tree Model", valign = :bottom, padding = (0, 0, 5, 0))

    return(f)
end
