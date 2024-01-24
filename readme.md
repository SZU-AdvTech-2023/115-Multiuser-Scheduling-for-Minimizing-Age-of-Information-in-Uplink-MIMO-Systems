main function: 
	simulation.m : calculate average AoI performance of 3 clients under different policy: a) mdp policy; b) 2 client tx; c) 3 client tx; d) max weight policy; 
		        e) 1 client tx;

funcational function: 
	mdp_ip_new.m: generate state transition probability matrix consisting of state index and probability
	myMDP.m: relative value iteration to calculate optimal policy on truncated state space
	step.m: step function to calculate the next state after taking action on current state
