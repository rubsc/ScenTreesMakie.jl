# Checks if probabilities are strictly positive and if not adjusts slightly. 
# What adjustments can be justified have to be determined in each instance.

function checkTree(tree0::Tree, eps)

# For every parent node going backwards
tmp = reverse(unique(tree0.parent)); pop!(tmp)
for i in tmp
    #Note that the probs are the conditional ones
    prob = tree0.probability[tree0.children[i+1]]
    if any(x->x>0,prob)
      #do nothing
    else
      prob = prob .+ eps
      prob = prob./ sum(prob)
      println()
      println("updated tree")
    end
  end

end
