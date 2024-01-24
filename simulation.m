T=10000;
%T=10;
R=1;% rate
g=2^R-1;% gamma
%SNR=10^(12/10);
r=2;
d=3;
N=3;% number of antennas
M=3;% number of all clients
MA=50;% max AoI
NA=3:1:10;
state= unique(nchoosek([1:MA,1:MA,1:MA],3),'row');% state (a,b£¬c); a: aoi of client 1; b: aoi of client 2; c: aoi of client 3;
snr=10:2:20;% calculate aoi under different policy with different snr
% average AoI of each user with different snr
mA1=zeros(3,size(snr,2));% mdp policy
mA2=mA1;% tx 2 nodes
mA3=mA1; %tx 3 nodes
mA4=mA1; % max weight
mA5=mA1;%tx 1 node
% parfor j=1:size(snr,2)
parfor j=1:size(snr,2)   
aoi=zeros(3,T);% record aoi evolution
aoi(:,1)=1;
aoi2=aoi;% tx 2 nodes
aoi3=aoi;% tx 3 node
aoi4=aoi; % max weight
aoi5=aoi;%tx 1 node
SNR=10^(snr(j)/10);%snr
%SNR=10^(20/10);
func=@(k)1-sum((d^r/SNR*g).^(0:N-k)./factorial(0:N-k))*exp(-d^r/SNR*g);% outage probability
p=[func(1),func(2),func(3)];% outage probablity of updates from 1 2 3 users
[P_yx,Ind]=mdp_ip_new(state,MA,p,M)% transition matrix with prob in P_yx, index in Ind
Rew=repmat(sum(state,2),1,3);% reward
[policy1, average_reward, Unext,varation]=myMDP(P_yx,Ind, Rew, 1e-12, 600000);% calculate optimal policy via rvi
tt=[3+p(1)*sum(state,2)+(1-p(1))*(sum(state,2)-max(state,[],2)),3+p(2)*sum(state,2)+(1-p(2))*min(state,[],2),3+p(3)*sum(state,2)];
[mm,policy2]=min(tt,[],2); % max weight policy

for i=1:T-1
    tp=[min(aoi(1,i),MA);min(aoi(2,i),MA);min(aoi(3,i),MA)];
    %(tp(1)-1)*MA^2+(tp(2)-1)*MA+tp(3);  
    act=policy1((tp(1)-1)*MA^2+(tp(2)-1)*MA+tp(3));
    aoi(:,i+1)=step(aoi(:,i),act,R,d,r,SNR,MA,N);
    %act2=2;
    aoi2(:,i+1)=step(aoi2(:,i),2,R,d,r,SNR,MA,N);
    aoi3(:,i+1)=step(aoi3(:,i),3,R,d,r,SNR,MA,N);
    tp4=[min(aoi4(1,i),MA);min(aoi4(2,i),MA);min(aoi4(3,i),MA)];
    act4=policy2((tp4(1)-1)*MA^2+(tp4(2)-1)*MA+tp4(3));
    aoi4(:,i+1)=step(aoi4(:,i),act4,R,d,r,SNR,MA,N);
    aoi5(:,i+1)=step(aoi5(:,i),1,R,d,r,SNR,MA,N);
end
    mA1(:,j)=mean(aoi,2);
    mA2(:,j)=mean(aoi2,2);
    mA3(:,j)=mean(aoi3,2);
    mA4(:,j)=mean(aoi4,2);
    mA5(:,j)=mean(aoi5,2);
end
plot(snr,sum(mA1)/3,'-b<','linewidth',1);hold on
plot(snr,sum(mA2)/3,'-r*','linewidth',1);hold on
plot(snr,sum(mA3)/3,'-gd','linewidth',1);hold on
plot(snr,sum(mA4)/3,'-y+','linewidth',1);hold on
plot(snr,sum(mA5)/3,'-ko','linewidth',1);hold on
xlabel('SNR  (dB)');%Number of antennas (N)SNR  (dB)
ylabel('System Expected AoI')
legend('MDP(optimal) ','k=2 ','k=3','Suboptimal','k=1');
%title('The performance comparison of different policies versus SNR,when the d=3 and d=5');