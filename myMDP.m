function  [policy, average_reward, Unext,variation]=myMDP(P,Ind, R, epsilon, max_iter)
% P transition matrix s*m*a (sparse P matrix)
% R reward R s*a
% relative value iteration
S = size(P,1);
U=zeros(S,1);
gain = U(S);
iter = 0;
is_done = false;
while ~is_done
    
    iter = iter + 1;
    
    A = size(P,3);
    t3=sum(U(Ind(:,:,:)).*P,2);
    tt=t3(:)+R(:);
    %[Unext, policy] = min([tt(1:S) tt(S+1:end)],[],2);
     [Unext, policy] = min([tt(1:S) tt(S+1:2*S) tt(2*S+1:end)],[],2);
%     for a=1:A
%         Q(:,a) = R(:,a) + sum(P(:,:,a).*U(Ind(:,:,a)),2);
%     end
%     [Unext, policy] = min(Q,[],2);
    Unext = Unext - gain;
    
    variation = max(Unext-U) - min(Unext-U);
    

    if variation < epsilon
        is_done = true;
        average_reward = gain + min(Unext-U);

    elseif iter == max_iter
        is_done = true;
        average_reward = gain + min(Unext-U);

    end
    
    U = Unext;
    gain = U(unidrnd(S));
end
end
%sum(U(Ind(:,:,:)).*P,2)