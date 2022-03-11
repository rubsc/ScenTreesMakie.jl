



# can we write a function adjusting the states so that process becomes monotone?
# resulting tree should be very close (in nested distance) to original process

#Example 1
trr1 = Tree([1,2,2,2]); trr2 = Tree([1,2,2,2]);
trr1.state = [0,0,0,0,0,0,0,1,3,20,40,2,4,21,41];
trr2.state = [0,0,0,0,0,0,0,1,21,3,41,2,20,4,40];

trr1.probability = [1.0,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5];
trr2.probability = trr1.probability;

nestedWasserstein(trr1,trr2,1.0)      # supposed to be 8.75



#Example 2
trr1 = Tree([1,2,4,1]); trr2 = Tree([1,2,4,1]);
trr1.state = [0,0,0,0,0,0,0,0,0,0,0,1,3,20,40,2,4,21,41];
trr2.state = [0,0,0,0,0,0,0,0,0,0,0,1,21,3,41,2,20,4,40];

trr1.probability = [1.0,0.5,0.5,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0];
trr2.probability = trr1.probability;

nestedWasserstein(trr1,trr2,1.0)




# Example 3

trr1 = Tree([1,1,2]); trr2 = Tree([1,2,1]);
trr1.state = [2,2,3,1];
trr2.state = [2,2,2,3,1];

trr1.probability = [1.0,1.0,0.3,0.7];
trr2.probability = [1.0,0.3,0.7,1.0,1.0];

nestedWasserstein(trr1,trr2,1.0)



