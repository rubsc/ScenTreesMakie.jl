"""
    tree_path(trr::Tree,nPath=1, flag_show=true)

Plots `nPath` sample paths of the tree `trr` weighted by the probability of the path occuring. 
"""
function tree_path(trr::Tree, nPath=1, flag_show=true)
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
        
            for i = 1 : height(tree0)
                x = [i,i+1]; y = [path_sim[i],path_sim[i+1]]
                tmpX = append!(tmpX,x,NaN)
                tmpY = append!(tmpY,y,NaN)
            end
            
        end

    end
    if flag_show==true
        f = plot(tmpX,tmpY,legend=:topleft);
    end

    return(f)
end



