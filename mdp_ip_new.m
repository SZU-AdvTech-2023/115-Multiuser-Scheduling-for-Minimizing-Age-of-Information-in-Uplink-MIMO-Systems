function [P_yx,Ind]=mdp_ip_new(state,ma,p,M)
n_s=size(state,1);% number of state
P_yx=zeros(n_s,2^M,M); % n_state*n_next state*n_a (1: tx 1 node; 2: tx 2 nodes, 3: tx 3 nodes)
Ind=ones(n_s,2^M,M);
for i=1:n_s
    temp=state(i,:);
    t1=[1,1,1];% all successful
    t0=temp+1; % all fail
    t0(t0>=ma)=ma;% state truncation
    [b,mm]=sort(temp);% 
    % a=1; tx 1 node with largest AoI
    t2=temp+1; % fail
    t2(mm(end))=1; % success
    t2(t2>=ma)=ma;% state truncation
    % a=2; % tx 2 nodes with largest AoI
    t3=temp+1;% all fail
     t3(mm(end-1:end))=1; % all successful
     t3(t3>=ma)=ma;
     t4=temp+1;
     t4(mm(end))=1; % max AoI node successful
     t4(t4>=ma)=ma;
     t5=temp; % second max AoI node successful
     t5=temp+1;
     t5(mm(end-1))=1;
     t5(t5>=ma)=ma;
     % a=3
     % small AoI success, max AoI node successful
     t6=t4; t6(mm(1))=1;
     t6(t6>=ma)=ma;
     % small AoI success, second max AoI node successful
     t7=t5;
     t7(mm(1))=1;
     t7(t7>=ma)=ma;
     % small AoI success, the rest fail
     t8=t0;t8(mm(1))=1;  
     t8(t8>=ma)=ma;
    
    %a=1
    P_yx(i,1,1)=1-p(1);
    P_yx(i,2,1)=p(1);
    Ind(i,1,1)=(t2(1)-1)*ma^2+(t2(2)-1)*ma+t2(3);
    Ind(i,2,1)=(t0(1)-1)*ma^2+(t0(2)-1)*ma+t0(3);% all fail
    % a=2
    P_yx(i,1,2)=(1-p(2))*(1-p(2));% all success
    P_yx(i,2,2)=p(2)*(1-p(2));  % 1 success, 1 fail
    P_yx(i,3,2)=p(2)*(1-p(2)); % 1 success, 1 fail
    P_yx(i,4,2)=p(2)*p(2);% all fail
    Ind(i,1,2)=(t3(1)-1)*ma^2+(t3(2)-1)*ma+t3(3);
    Ind(i,2,2)=(t4(1)-1)*ma^2+(t4(2)-1)*ma+t4(3);
    Ind(i,3,2)=(t5(1)-1)*ma^2+(t5(2)-1)*ma+t5(3);
    Ind(i,4,2)=(t0(1)-1)*ma^2+(t0(2)-1)*ma+t0(3);  
    % a=3
    P_yx(i,1,3)=(1-p(3))*(1-p(3))*(1-p(3));% all success
    P_yx(i,2:4,3)=p(3)*(1-p(3))*(1-p(3));  % 1 fail 2 success
    %P_yx(i,3,3)=p(2)*(1-p(2));
    %P_yx(i,4,3)=p(2)*p(2);
    P_yx(i,5:7,3)=p(3)*p(3)*(1-p(3));% 2 fail 1 success
%     P_yx(i,6,3)=p(2)*(1-p(2));  
%     P_yx(i,7,3)=p(2)*(1-p(2));
    P_yx(i,8,3)=p(3)*p(3)*p(3);% all fail
   % P_yx(i,9,3)=p(3)*p(3)*p(3);
    Ind(i,1,3)=(t1(1)-1)*ma^2+(t1(2)-1)*ma+t1(3);
    Ind(i,2,3)=(t3(1)-1)*ma^2+(t3(2)-1)*ma+t3(3);
    Ind(i,3,3)=(t6(1)-1)*ma^2+(t6(2)-1)*ma+t6(3);
    Ind(i,4,3)=(t7(1)-1)*ma^2+(t7(2)-1)*ma+t7(3);  
    Ind(i,5,3)=(t4(1)-1)*ma^2+(t4(2)-1)*ma+t4(3);
    Ind(i,6,3)=(t8(1)-1)*ma^2+(t8(2)-1)*ma+t8(3);
    Ind(i,7,3)=(t5(1)-1)*ma^2+(t5(2)-1)*ma+t5(3);
    Ind(i,8,3)=(t0(1)-1)*ma^2+(t0(2)-1)*ma+t0(3); 
    %Ind(i,8,3)=(t0(2)-1)*ma^2+(t0(1)-1)*ma+t0(3);
end

end