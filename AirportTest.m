clc
clear all
close all

%%                       INITIALISATION          %%%%%%

lambda=7; % arrival rate

% modified service rate for PHASE 1

mu1=10; % service rate of PHASE 1, service time 0.1sec
mu2=8; % service rate of PHASE 2, service time 0.125 sec
Threshold=7; % Threshold of QUEUE 2
endtime=100; %simulation length (seconds) 100 sec
[aA,aQ1,aQ2,aT1,aT2,aT] = withoutAQ(lambda,mu1,mu2,endtime);
[A,Q1,Q2,MU,T1,T2,T] = withAQ(lambda,mu1,mu2,Threshold,endtime);
%%%%% doing for more batches
% for i=1:1:100
%     
%     [aA,aQ1,aQ2,aT1,aT2,aT] = withoutAQ(lambda,mu1,mu2,endtime);
%    
%     meanaQ1(i)=mean(aQ1);
%     meanaQ2(i)=mean(aQ2);
%     meanaT1(i)=mean(aT1);
%     meanaT2(i)=mean(aT2);
%     meanaT(i)=mean(aT);
% end
% for j=1:1:100
%     
%     [A,Q1,Q2,MU,T1,T2,T] = withAQ(lambda,mu1,mu2,Threshold,endtime);
%     
%     meanQ1(j)=mean(Q1);
%     meanQ2(j)=mean(Q2);
%     meanT1(j)=mean(T1);
%     meanT2(j)=mean(T2);
%     meanT(j)=mean(T);
%     
% end
%%      PLOTTING FOR COMPARISON ON EFFECT OF AQ    %%%%%%

figure; plot(aA), hold on, plot(A), title('Effect of AQ on Arrival A'),legend('without AQ','withAQ');
figure; plot(aQ1), hold on, plot(Q1), title('Effect of AQ on Queue Length Q1'),legend('without AQ','withAQ');
figure; plot(aQ2), hold on, plot(Q2), title('Effect of AQ on Queue Length Q2'),legend('without AQ','withAQ');
figure; plot(aT1), hold on, plot(T1), title('Effect of AQ on SojournTime T1'),legend('without AQ','withAQ');
figure; plot(aT2), hold on, plot(T2), title('Effect of AQ on SojournTime T2'),legend('without AQ','withAQ');
figure; plot(aT), hold on, plot(T), title('Effect of AQ on SojournTime T'),legend('without AQ','withAQ');

%%% Mean Plots  %%%

% figure; plot(aA), hold on, plot(A), title('Effect of AQ on Arrival A'),legend('without AQ','withAQ');
% figure; plot(meanaQ1), hold on, plot(meanQ1), title('Effect of AQ on Queue Length Q1'),legend('without AQ','withAQ');
% figure; plot(meanaQ2), hold on, plot(meanQ2), title('Effect of AQ on Queue Length Q2'),legend('without AQ','withAQ');
% figure; plot(meanaT1), hold on, plot(meanT1), title('Effect of AQ on SojournTime T1'),legend('without AQ','withAQ');
% figure; plot(meanaT2), hold on, plot(meanT2), title('Effect of AQ on SojournTime T2'),legend('without AQ','withAQ');
% figure; plot(meanaT), hold on, plot(meanT), title('Effect of AQ on SojournTime T'),legend('without AQ','withAQ');

%   Trial


% figure;plot(A), title('arrival to Airport');
% %figure; plot(A2), title('arrival from phase-1 to phase-2');
% %figure; plot(D), title('departure from phase-2(Final Departure)');
% 
% figure; plot(Q1), hold on, plot(Q2), title('Comparing queue lengths in both phases'),legend('queue1','queue2');
% figure; plot(MU), title('modified service rate for phase-1'), axis([0 350 0 40]);
% figure; plot(T1), title('time spent by each customer in the phase-1');
% figure; plot(T2), title('time spent by each customer in the phase-2');
% figure; plot(T), title('time spent by each customer in the system');
