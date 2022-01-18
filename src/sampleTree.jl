

function sampleTree(tree0::Tree)
    y0 = tree0.state[1];
    
    s_path = zeros(length(unique(stage(tree0))));
    s_value = zeros(length(unique(stage(tree0))));
    s_path[1] = 1;
    s_value[1] = tree0.state[1];
    #for every parent node sample from children nodes
    probs = tree0.probability[tree0.children[2]]
    tmp = sample(tree0.children[2],Weights(tree0.probability[tree0.children[2]]))
    
    s_path[2] = tmp;
    s_value[2] = tree0.state[Int(tmp)];
    for i=2:(length(s_path)-1)

        C_node = Int(s_path[i])+1
        probs = tree0.probability[tree0.children[C_node]]

        tmp = sample(tree0.children[C_node],Weights(tree0.probability[tree0.children[C_node]]))
    
        s_path[i+1] = tmp;
        s_value[i+1] = tree0.state[Int(tmp)];
    end

    treeTmp = Tree(round.(Int,ones(length(s_value))))
    treeTmp.state = reshape(s_value,4,1)
    return(s_path, s_value,treeTmp)
end

########################
#ToDo: 
#       Write a plotting function, with chosen starting node...
#       Write an online update tree function based on tree_approximation



function samplePlot(trr::Tree, add = true)
    if add != true
        figure()
        trs = subplot2grid((1,4), (0,0), colspan=4)
    else
        figure(1)
        trs = gca()
    end
    #suptitle(trr.name, fontsize = 14)
    
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
    
end


#ALTERNATIVE VERSION, check what is needed and works best
#####################
# simulation of paths based on tree model

function tree_path(tree0::Tree, nPath, flag_show)
# generates nPath simulations of tree0 model and optionally plots them
stages = height(tree0);
path_sim = zeros(stages+1)

path_sim[1] = tree0.state[1];

for i=1:stages+1
    #pick child of stages[i] , i=1 gives root node
    if i == 1
        selection = tree0.children[i][1]
        path_sim[i] = tree0.state[selection]
    else
        parents = selection
        child   = tree0.children[findfirst(x -> x==parents,unique(tree0.parent))]
    
        prob = tree0.probability[child]

        #random selection according to weights --> selection
        selection = sample(child, Weights(prob))
        path_sim[i] = tree0.state[selection]
    

    end
end

###############
# Plot stuff
if flag_show==true
    #suptitle(trr.name, fontsize = 14)
    trs = subplot()
    title("paths")
    stg = stage(tree0)
    xticks(1 : height(tree0) + 1)         # Set the ticks on the x-axis
    xlabel("stage,time",fontsize=12)
    trs.spines["top"].set_visible(false)         # remove the line of the box at the top
    trs.spines["right"].set_visible(false)		 # remove the line of the box at the right
    for i = 1 : height(tree0)
        trs.plot([i,i+1],[path_sim[i],path_sim[i+1]],linewidth=1.5)
    end

end



end



