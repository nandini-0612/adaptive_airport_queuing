function [A,Q1,Q2,T1,T2,T] = withoutAQ(lambda,mu1,mu2,endtime)

%%              INITIALISATION                   %%

t=0; % current time
tstep = 1; % average time between consecutive measurement events

%%% Customers in the system at any given time t %%%
currcustomers1 = 0; % current number of customers in CheckIn 
currcustomers2 = 0; % current number of customers in Security
customersInSys = 0; % current number of customers in the System

%%% Queue %%%
queue1 = 0;
queue2 = 0;
Q1 = [];
Q2 = [];

%%%  Stamp Times %%%
A = []; % Arrival to PHASE 1.
A2 = []; % Arrival to PHASE 2 from PHASE 1.
D = []; % Departure from the PHASE 2 and the SYSTEM.

%%%  Measurements  %%%
nbrmeasurements=0; %number of measurement events so far
MU=[];

nbrarrived = 0; % number of customers that have arrived to PHASE 1.
nbrarrived2=0; % number of customers that have arrived to PHASE 2 from PHASE 1.
nbrdeparted=0; % number of departed customers from PHASE 2 and the SYSTEM.

timeInSystem = 0; % Time spent by each customer in the PHASE 1.
timeInSystem1 = 0; % Time spent by each customer in the PHASE 2.
timeInSystem2 = 0; % Time spent by each customer in the SYSTEM.

T1 = []; % Time spent by each customer in the PHASE 1.
T2 = []; % Time spent by each customer in the PHASE 2.
T = []; % Time spent by each customer in the SYSTEM.

%%% Events %%%
% constructs vector to keep time for next arrival (pos 1),
% next CHECK-IN service completion (pos 2) and
% next SECURITY service completion (pos 3) and
% next measurement event (pos 4)

event=zeros(1,4); 
event(1)=exprnd(1/lambda); % time for next arrival PHASE 1
event(2)=inf; % service time in PHASE 1
event(3)=inf; % service time in PHASE 2
event(4)=exprnd(tstep); % time for next measurement event
% figure(100),subplot(4,3,9),bar(event(1)),title('Arrival');
% figure(100),subplot(4,3,10),bar(event(2)),hold on,title('Check-In Service time');
% figure(100),subplot(4,3,11),bar(event(3)),hold on,title('Security Service time');
%%                       EXECUTION                         %%

    
while t<endtime    
    
    [t,nextevent]=min(event); % SELECTION OF TYPE OF EVENT
    
    
    %%%            PHASE 1           %%%
    
    % 1.) Arrival Updates to System and PHASE 1
    % 2.) Updating PHASE 1 Service time : CheckIn Service for 1st customer
    
    if nextevent==1
        
        %%% 1.) PHASE 1 Updates
        
        nbrarrived = nbrarrived + 1; % Customers arrival to system & PHASE 1
        A(nbrarrived) = t; % the new customer arrived at time t (STAMP TIME) 
        customersInSys = customersInSys + 1; % the customers in the Airport.
        N(nbrarrived) = customersInSys;
        
        currcustomers1 = currcustomers1 + 1; % the customers in PHASE 1.
        queue1 =  currcustomers1 - 1; % QUEUE of PHASE 1.
        Q1(nbrarrived)=queue1;
        
        
        % Updating Arrival for next customer in PHASE 1
        event(1) = exprnd(1/lambda) + t; 
        
%         figure(100),subplot(4,3,1),plot(A),hold on, title('Arrival to Airport');
%         figure(100),subplot(4,3,2),plot(Q1),hold on, title('Queue at Check-In');
%         figure(100),subplot(4,3,4),plot(N),hold on, title('CustomersInSystem');
%         figure(100),subplot(4,3,9),bar(event(1)),hold on,title('Arrival');
        
        %%% 2.) PHASE1 : CHECK-IN SERVICE Time Update for 1st Customer
        
        if currcustomers1 == 1
%            if queue2 < Threshold
%                mu = mu1;
%            else
%                 mu = mu1*(1/log(currcustomers2));                            
%            end
           event(2) = exprnd(1/mu1) + t; 
        end  
%         MU(nbrarrived) = mu;
          
%         figure(100),subplot(4,3,10),bar(event(2)),hold on,title('Check-In Service time');
         
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    %%%             PHASE 2          %%% 
    
    % 1.) Departure Updates for PHASE 1    
    % 2.) Updating PHASE 1 Service time : CheckIn Service 
    % 3.) Arrival Updates to PHASE 2
    % 4.) Updating PHASE 2 Service time : SECURITY Service for 1st customer
    
    elseif nextevent==2
        
        %%% 1.) Departure Updates for PHASE 1
        
        currcustomers1 = currcustomers1 - 1; % Current Customers in PHASE 1
        if currcustomers1 == 0
            queue1 = 0;
        else
            queue1 =  queue1 - 1;
        end
        Q1(nbrarrived-currcustomers1)=queue1;
        timeInSystem1 = t - A(nbrarrived-currcustomers1); % the time spent in Phase1 by customer A().
        T1(nbrarrived-currcustomers1) = timeInSystem1; % the time spent by each customer in Phase1 (STAMP TIME)
        
%         figure(100),subplot(4,3,2),plot(Q1),hold on, title('Queue at Check-In');
%         figure(100),subplot(4,3,5), plot(T1), hold on, title('Sojourn time PHASE 1');
        
        %%% 2.) Updating PHASE 1 Service time : CHECK-IN Service
        
        if currcustomers1>0
%             if queue2 < Threshold
%                mu = mu1;
%             else
%                 mu = mu1*(1/log(currcustomers2));
%             end
            event(2) = exprnd(1/mu1) + t;
        else
            event(2) = inf;
        end
%         MU(nbrarrived-currcustomers1)=mu;    
          
%         figure(100),subplot(4,3,10),bar(event(2)),hold on,title('Check-In Service time');
       
        %%% 3.) Arrival Updates to PHASE 2
        
        nbrarrived2 = nbrarrived2 + 1;% The arrival time of customer to PHASE 2 from PHASE 1 
        currcustomers2 = currcustomers2 + 1; % No. of customers in PHASE 2 at time t.
        queue2 = currcustomers2 - 1;
        Q2(nbrarrived2) = queue2;
        A2(nbrarrived2) = t; % The arrival time of customer to PHASE 2 from PHASE 1 (STAMP TIME)        
        
%         figure(100),subplot(4,3,3),plot(Q2),hold on, title('Queue at Security');
        
        %%% 4.) Updating PHASE 2 Service time : SECURITY Service for 1st customer
        
        if currcustomers2 == 1
            event(3) = t + exprnd(1/mu2);
        end
%         
%         figure(100),subplot(4,3,11),bar(event(3)),title('Security Service time');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%        SECURITY Service and Departure From PHASE 2       %%%
    
    % 1.) Departure Updates for PHASE 2
    % 2.) Updating PHASE 2 Service time : SECURITY Service 
    % 3.) Departure from System
    % 4.) Sojourn Time Of each Customer
    
    elseif nextevent==3
        
        %%% 1.) Departure Updates for PHASE 2       
        
        currcustomers2 = currcustomers2 - 1;
        if currcustomers2 == 0
            queue2 = 0;
        else
            queue2 =  queue2 - 1;
        end
        Q2(nbrarrived2-currcustomers2) = queue2;
        timeInSystem2 = t - A2(nbrarrived2-currcustomers2); % the time spent in Phase2
        T2(nbrarrived2-currcustomers2)=timeInSystem2; % the time spent by each customer in Phase2 (STAMP TIME)
        
        
%         figure(100),subplot(4,3,3),plot(Q2),hold on, title('Queue at Security');
%         figure(100),subplot(4,3,6),plot(T2),hold on ,title('Sojourn Time PHASE 2');
        
        %%% 2.) Updating PHASE 2 Service time : SECURITY Service 
        
        if currcustomers2 > 0
            event(3) = t + exprnd(1/mu2);
 
        else
            event(3) = inf;
        end
        
%         figure(100),subplot(4,3,11),bar(event(3)),title('Security Service time');
        
        %%% 3.) Departure from System        
        
        nbrdeparted = nbrdeparted + 1; % No. of customers that departed the System
        D(nbrdeparted) = t; % the departure STAMP TIME of customers
        customersInSys = customersInSys - 1; % Current Customers in the System
        N(nbrarrived-customersInSys) = customersInSys;
        
%         figure(100),subplot(4,3,4),plot(N),hold on, title('CustomersInSystem');
        
        %%% 4.) Sojourn Time Of each Customer
       
        timeInSystem = t - A(nbrarrived-customersInSys);
        T(nbrdeparted) = timeInSystem;
        
%         figure(100),subplot(4,3,7),plot(T),hold on,title('Sojourn Time at Airport');
        
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   %%%               Measurements PASTA            %%%
   
    else
        nbrmeasurements = nbrmeasurements + 1; %one more measurement event
        Nm(nbrmeasurements) = customersInSys;
        event(4) = event(4) + exprnd(tstep);
        
%         figure(100),subplot(4,3,12),plot(Nm),hold on, title('Measurements');
        
    end
end
%%            Emptying the Queue              %%%%%%%%%%%%%%%%%%%%%%%%%%

while currcustomers1>0
    
    %%%         Departure From PHASE 1       %%%
    
    % 1.) Departure Updates for PHASE 1
    % 2.) Updating PHASE 1 Service time : CheckIn Service  
    % 3.) Arrival Updates to PHASE 2      
        
        %%% 1.) Departure Updates for PHASE 1
        
        currcustomers1 = currcustomers1 - 1; % Current Customers in PHASE 1
        if currcustomers1 == 0
            queue1 = 0;
        else
            queue1 =  queue1 - 1;
        end
        Q1(nbrarrived-currcustomers1) = queue1;
        timeInSystem1 = t - A(nbrarrived-currcustomers1); % the time spent in Phase1 by customer A().
        T1(nbrarrived-currcustomers1) = timeInSystem1; % the time spent by each customer in Phase1 (STAMP TIME)
                
        %%% 2.) Updating PHASE 1 Service time : CHECK-IN Service
        if currcustomers1>0
%             if queue2 < Threshold
%                mu = mu1;
%             else
%                 mu = mu1*(1/log(currcustomers2));
%             end
            event(2) = exprnd(1/mu1) + t;
            
            %%% MANUAL TIME UPDATE AFTER SERVICE , SINCE NO MORE ARRIVALS
            t = event(2); %% time t gets updated after the customer gets CHECK-IN Service
        else
            event(2) = inf;
        end
        
%         MU(nbrarrived-currcustomers1)=mu;
        
        %%% 3.) Arrival Updates to PHASE 2
        
        nbrarrived2 = nbrarrived2 + 1;% The arrival time of customer to PHASE 2 from PHASE 1 
        currcustomers2 = currcustomers2 + 1; % No. of customers in PHASE 2 at time t.
        queue2 = queue2 + 1; 
        Q2(nbrarrived2-currcustomers2) = queue2;
        A2(nbrarrived2) = t; % The arrival time of customer to PHASE 2 from PHASE 1 (STAMP TIME)
        
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%        SECURITY Service and Departure From PHASE 2       %%%
    
    % 1.) Departure Updates for PHASE 2
    % 2.) Updating PHASE 2 Service time : SECURITY Service 
    % 3.) Departure from System
    % 4.) Sojourn Time Of each Customer
    
     
        %%% 1.) Departure Updates for PHASE 2       
        
        currcustomers2 = currcustomers2 - 1;
        if currcustomers2 == 0
            queue2 = 0;
        else
            queue2 =  queue2 - 1;
        end
        Q2(nbrarrived2-currcustomers2) = queue2;
        timeInSystem2 = t - A2(nbrarrived2-currcustomers2); % the time spent in Phase2
        T2(nbrarrived2-currcustomers2)=timeInSystem2; % the time spent by each customer in Phase2 (STAMP TIME) 
        
        %%% 2.) Updating PHASE 2 Service time : SECURITY Service 
        
        if currcustomers2 > 0
            event(3) = t + exprnd(1/mu2);
            
            %%% MANUAL TIME UPDATE AFTER SERVICE , SINCE NO MORE ARRIVALS
            t = event(3); %% time t gets updated after the customer gets SECURITY Service
        else
            event(3) = inf;
        end
                
        %%% 3.) Departure from System        
        
        nbrdeparted = nbrdeparted + 1; % No. of customers that departed the System
        D(nbrdeparted) = t; % the departure STAMP TIME of customers        
        customersInSys = customersInSys - 1; % Current Customers in the System
        N(nbrarrived-customersInSys) = customersInSys;
        
        %%% 4.) Sojourn Time Of each Customer
       
        timeInSystem = t - A(nbrarrived-customersInSys);
        T(nbrdeparted) = timeInSystem;
        
end
while currcustomers2>0
    currcustomers2 = currcustomers2 - 1;
    if currcustomers2 == 0
        queue2 = 0;
    else
        queue2 =  queue2 - 1;
    end
    Q2(nbrarrived2-currcustomers2) = queue2;
    timeInSystem2 = t - A2(nbrarrived2-currcustomers2); % the time spent in Phase2
    T2(nbrarrived2-currcustomers2)=timeInSystem2; % the time spent by each customer in Phase2 (STAMP TIME) 
        
        %%% 2.) Updating PHASE 2 Service time : SECURITY Service 
        
    if currcustomers2 > 0
        event(3) = t + exprnd(1/mu2);
            
            %%% MANUAL TIME UPDATE AFTER SERVICE , SINCE NO MORE ARRIVALS
        t = event(3); %% time t gets updated after the customer gets SECURITY Service
    else
        event(3) = inf;
    end
                
        %%% 3.) Departure from System        
        
    nbrdeparted = nbrdeparted + 1; % No. of customers that departed the System
    D(nbrdeparted) = t; % the departure STAMP TIME of customers        
    customersInSys = customersInSys - 1; % Current Customers in the System
    N(nbrarrived-customersInSys) = customersInSys;
      
        %%% 4.) Sojourn Time Of each Customer
       
    timeInSystem = t - A(nbrarrived-customersInSys);
    T(nbrdeparted) = timeInSystem;
end
end
