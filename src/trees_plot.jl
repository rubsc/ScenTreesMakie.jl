"""
	tree_plot(trr::Tree,fig=1)

Returns the plot of the input tree annotated with density of
probabilities of reaching the leaf nodes in the tree.
Args:
- trr - A scenario tree.
- fig - Specifies the size of the image you want to be returned, default = 1.

Using the matplotlib version, fig usually takes a tuple. For example, fig = (8,6) produces an image with length = 8 and width = 6.
The user is not obliged to give this specifications as already there is a default value.
"""
function tree_plot(trr::Tree, fig= 1)
    if !isempty(fig)
        figure(fig)
    end
    #suptitle(trr.name, fontsize = 14)
    trs = subplot2grid((1,4), (0,0), colspan=3)
    title("states")
    stg = stage(trr)
    xticks(1 : height(trr) + 1)         # Set the ticks on the x-axis
    xlabel("stage,time",fontsize=12)
    trs.spines["top"].set_visible(false)         # remove the line of the box at the top
    trs.spines["right"].set_visible(false)		 # remove the line of the box at the right
    for i = 1 : length(trr.parent)
        if stg[i] > 0
            trs.plot([stg[i],stg[i]+1],[trr.state[trr.parent[i]],trr.state[i]],linewidth=1.5)
        end
    end
    prs = subplot2grid((1,4), (0,3))
    title("probabilities")
    prs.spines["top"].set_visible(false)
    prs.spines["left"].set_visible(false)
    prs.spines["right"].set_visible(false)

    (Yi,_,probYi) = leaves(trr)
    Yi = [trr.state[i] for i in Yi]
    nY = length(Yi)
    h = 1.05 * std(Yi) / (nY^0.2) + 1e-3         #Silverman rule of thumb
    #trs.set_ylim(minimum(Yi)-h, maximum(Yi)+h)
    #prs.set_ylim(minimum(Yi)-h, maximum(Yi)+h)
    yticks(())                                                                                                             #remove the ticks on probability plot
    t = LinRange(minimum(Yi)-h, maximum(Yi)+h, 100)  #100 points on probability plot
    density = zero(t)
    for (i, ti) in enumerate(t)
        for (j, xj) in enumerate(Yi)
            tmp = (xj - ti) / h
            density[i] += probYi[j]* 35/32 * max(1.0 -tmp^2, 0.0)^3 /h #triweight kernel
        end
    end
    plot(density, t)
    prs.fill_betweenx(t, 0 , density)
end

"""
	plot_hd(newtree::Tree)

Returns a plots of trees in higher dimensions.
"""
function plot_hd(newtree::Tree)
    fig = figure(figsize = (10,6))
    stg = stage(newtree)
    for rw = 1:size(newtree.state,2)
      ax = subplot(1,size(newtree.state,2),rw)
      ax.spines["top"].set_visible(false)                                                  #remove the box top
      ax.spines["right"].set_visible(false)                                               #remove the box right
      for i in range(1,stop = length(newtree.parent))
          if stg[i] > 0
              ax.plot([stg[i], stg[i]+1],[newtree.state[:,rw][newtree.parent[i]], newtree.state[:,rw][i]])
          end
          xlabel("stage, time")
          ylabel("states")
      end
      xticks(unique(stg))
    end
end

	
	


function tree_plot2(trr::Tree, fig= 1; tit = nothing)
    if !isempty(fig)
        figure(fig)
    end
    if  tit === nothing
        tit = trr.name
    end
    suptitle(tit, fontsize = 14)
    trs = subplot2grid((1,4), (0,0), colspan=3)
    #title("states")
    stg = stage(trr)
    xticks(1 : height(trr) + 1)         # Set the ticks on the x-axis
    xlabel("stage",fontsize=12)
    ylabel("states")
    trs.spines["top"].set_visible(false)         # remove the line of the box at the top
    trs.spines["right"].set_visible(false)		 # remove the line of the box at the right
    for i = 1 : length(trr.parent)
        if stg[i] > 0
            trs.plot([stg[i],stg[i]+1],[trr.state[trr.parent[i]],trr.state[i]],linewidth=1.5)
        end
    end
    prs = subplot2grid((1,4), (0,3))
    #title("probabilities")
    prs.spines["top"].set_visible(false)
    prs.spines["left"].set_visible(false)
    prs.spines["right"].set_visible(false)


    (Yi,_,probYi) = leaves(trr)
    Yi = [trr.state[i] for i in Yi]
    nY = length(Yi)
    h = 1.05 * std(Yi) / (nY^0.2) + 1e-3         #Silverman rule of thumb
    #trs.set_ylim(minimum(Yi)-h, maximum(Yi)+h)
    #prs.set_ylim(minimum(Yi)-h, maximum(Yi)+h)
    yticks(())                                                                                                             #remove the ticks on probability plot
    t = LinRange(minimum(Yi)-h, maximum(Yi)+h, 100)  #100 points on probability plot
    density = zero(t)
    for (i, ti) in enumerate(t)
        for (j, xj) in enumerate(Yi)
            tmp = (xj - ti) / h
            density[i] += probYi[j]* 35/32 * max(1.0 -tmp^2, 0.0)^3 /h #triweight kernel
        end
    end
    plot(density, t)
    prs.fill_betweenx(t, 0 , density)
end




function tree_plot3(trr::Tree, fig= 1; tit = nothing)
    if !isempty(fig)
        figure(fig)
    end
    if  tit === nothing
        tit = trr.name
    end
    suptitle(tit, fontsize = 14)
    trs = subplot2grid((1,4), (0,0), colspan=3)
    #title("states")
    stg = stage(trr)
    xticks(1 : height(trr) + 1)         # Set the ticks on the x-axis
    xlabel("stage",fontsize=12)
    ylabel("states")
    trs.spines["top"].set_visible(false)         # remove the line of the box at the top
    trs.spines["right"].set_visible(false)		 # remove the line of the box at the right
    for i = 1 : length(trr.parent)
        if stg[i] > 0
            if (trr.state[trr.parent[i]] != 0 && trr.probability[trr.parent[i]] > 0)
                if trr.state[i] != 0 && trr.probability[i] >0
                    trs.plot([stg[i],stg[i]+1],[trr.state[trr.parent[i]],trr.state[i]],linewidth=1.5)
                end
            end
        end
    end
    prs = subplot2grid((1,4), (0,3))
    #title("probabilities")
    prs.spines["top"].set_visible(false)
    prs.spines["left"].set_visible(false)
    prs.spines["right"].set_visible(false)


    (Yi,_,probYi) = leaves(trr)
    Yi = [trr.state[i] for i in Yi]
    nY = length(Yi)
    h = 1.05 * std(Yi) / (nY^0.2) + 1e-3         #Silverman rule of thumb
    #trs.set_ylim(minimum(Yi)-h, maximum(Yi)+h)
    #prs.set_ylim(minimum(Yi)-h, maximum(Yi)+h)
    yticks(())                                                                                                             #remove the ticks on probability plot
    t = LinRange(minimum(Yi)-h, maximum(Yi)+h, 100)  #100 points on probability plot
    density = zero(t)
    for (i, ti) in enumerate(t)
        for (j, xj) in enumerate(Yi)
            tmp = (xj - ti) / h
            density[i] += probYi[j]* 35/32 * max(1.0 -tmp^2, 0.0)^3 /h #triweight kernel
        end
    end
    plot(density, t)
    prs.fill_betweenx(t, 0 , density)
end
