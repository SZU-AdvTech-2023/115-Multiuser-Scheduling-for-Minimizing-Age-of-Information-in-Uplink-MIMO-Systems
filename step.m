function stat=step(state,act,R,d,r,SNR,ma,N)
% step function, calculte the next possible stat of current state taking
% action act.
% ma: max aoi
%N : number of antenna
 [bi,id]=sort(state);
 stat=state;
 g=2^R-1;
 func=@(k)1-sum((d^r/SNR*g).^(0:N-k)./factorial(0:N-k))*exp(-d^r/SNR*g);
 p=[func(1),func(2),func(3)];% outage probability
 stat(id(1))=(act==3)*((rand(1)>(1-p(3)))*state(id(1)))+(act~=3)*state(id(1))+1;
 stat(id(2))=(act==3)*(rand(1)>(1-p(3)))*state(id(2))+(act==2)*(rand(1)>(1-p(2)))*state(id(2))+(act==1)*state(id(2))+1;
 stat(id(3))=(act==3)*(rand(1)>(1-p(3)))*state(id(3))+(act==2)*(rand(1)>(1-p(2)))*state(id(3))+(act==1)*(rand(1)>(1-p(1)))*state(id(3))+1;
end