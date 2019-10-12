% Code written by Dr. Ning Lu for DR book
% Code written 9/21/2017
% Copyright North Carolina State University

clear all
close all

% The power ratings of the washer and dryer

P_washer = zeros(1000,24*60*8);
P_dryer = zeros(1000,24*60*8);

%probability density functions
Prob_dayofweek = [0.1	0.1	0.1	0.05	0.05	0.3	0.3	];
Prob_timeoftheday_wkday = [0	0	0	0	0	0	0	0.01	0.01	0.1	0.1	0.06	0.06	0.06	0.06	0.06	0.06	0	0.06	0.1	0.1	0.1	0.06	0];
Prob_timeoftheday_wkend = [0	0	0	0	0	0	0	0.1	0.1	0.1	0.1	0.07	0.05	0.04	0.03	0.02	0.03	0.04	0.06	0.15	0.08	0.02	0.01	0];
Prob_loading =[0.1	0.2	0.35	0.3	0.04	0.01];
Prob_dryonafterwashingdone = [0.5	0.25	0.15	0.07	0.02	0.01];

% Constants
Washeronduration = [30:1:60];  % Washer on duration is between 30-40 minutes
dryerontime = [45:1:75];  % dryer on duration is between 45-75 minutes
Tnextloading = [-5:1:5];  % The next loading will begin within five minutes before or after the dryer is on
dryonafterwashingdone = [5 10 15 20 25 30];  % dryer will always be on after a loading is finished and its on

% Calculate the cumulated probability functions
for i = 1:1:length(Prob_dayofweek)
    PCF_dayofweek(i) =  sum(Prob_dayofweek(1:i));
end   
for i = 1:1:length(Prob_timeoftheday_wkend)
    PCF_timeoftheday_wkend(i) =  sum(Prob_timeoftheday_wkend(1:i));
end
for i = 1:1:length(Prob_timeoftheday_wkday)
    PCF_timeoftheday_wkday(i) =  sum(Prob_timeoftheday_wkday(1:i));
end
for i = 1:1:length(Prob_loading)
    PCF_loading(i) =  sum(Prob_loading(1:i));
end
for i = 1:1:length(Prob_dryonafterwashingdone)
    PCF_dryonafterwashingdone(i) =  sum(Prob_dryonafterwashingdone(1:i));
end

%simulate 1000 washer and dryer pairs
for i = 1:1000
    All_rand = rand(20,1);
    Pwasherrated = (300 + floor(200*All_rand(20)))/1000;
    Pdryerrated = (3000 + floor(4000*All_rand(20)))/1000;
    
    dayofweek = min(find(PCF_dayofweek>=All_rand(1)));
    if dayofweek <=5
        timeofdayvalues = find(PCF_timeoftheday_wkday>=All_rand(2));
        for j =1:1: length(timeofdayvalues)
            if Prob_timeoftheday_wkday(timeofdayvalues(j)) ~=0
                timeofday = timeofdayvalues(j);
                break
            end
        end
    else
        timeofdayvalues = find(PCF_timeoftheday_wkend>=All_rand(2));
        for j =1:1: length(timeofdayvalues)
            if Prob_timeoftheday_wkend(timeofdayvalues(j)) ~=0
                timeofday = timeofdayvalues(j);
                break
            end
        end
    end
    minuteofhour = ceil(All_rand(3)*60);
    T_washeron = (dayofweek-1)*24*60 + timeofday*60 + minuteofhour;
    T_washeroff = T_washeron + floor(All_rand(4)*30) + 30;
    P_washer(i,T_washeron:T_washeroff) = Pwasherrated;
    
    T_dryeron_value  = dryonafterwashingdone(min(find(PCF_dryonafterwashingdone>=All_rand(5))));
      
    T_dryeron = T_washeroff + T_dryeron_value - floor(All_rand(6)*5);
    T_dryeroff = T_dryeron + floor(All_rand(7)*30) + 45;
    P_dryer(i,T_dryeron:T_dryeroff) = Pdryerrated;
%     figure(1)
%     plot([1:1:24*60*7]/60,P_washer(i,:))
%     hold on
%     plot([1:1:24*60*7]/60,P_dryer(i,:))
%     xlim([1 24*7])

    No_loading  = min(find(Prob_loading >= All_rand(8)));
    
    for jj = 2:No_loading
        T_washeron = T_dryeroff - 5 + floor(10*All_rand(9));
        T_washeroff = T_washeron + floor(All_rand(4)*30) + 30;
        P_washer(i,T_washeron:T_washeroff) = Pwasherrated;
        
        T_dryeron_value  = dryonafterwashingdone(min(find(PCF_dryonafterwashingdone>=All_rand(10))));
        T_dryeron = T_washeroff + T_dryeron_value - floor(All_rand(12)*5);
        T_dryeroff = T_dryeron + floor(All_rand(13)*30) + 45;
        P_dryer(i,T_dryeron:T_dryeroff) = Pdryerrated;  
    end
end
    
Totalwasher = sum(P_washer);
Totaldryer = sum(P_dryer);
figure(2)
set(gcf,'DefaultAxesFontSize',16)  %<--------set character size
set(gcf,'DefaultTextFontSize',16)
subplot(1,2,1)
plot([1:1:24*60*8]/60,Totalwasher,'b')
hold on
plot([1:1:24*60*8]/60,Totaldryer,'r')

xlabel('Time (minute)')
ylabel('Power (kW)')
xlim([72 96])
ylim([0 50])
legend('washer','dryer')
title('(a) Wednesday')
    
subplot(1,2,2)
set(gcf,'DefaultAxesFontSize',16)  %<--------set character size
set(gcf,'DefaultTextFontSize',16)
plot([1:1:24*60*8]/60,Totalwasher,'b')
hold on
plot([1:1:24*60*8]/60,Totaldryer,'r')

xlabel('Time (minute)')
ylabel('Power (kW)')
xlim([120 144])
% ylim([0 100])
legend('washer','dryer')
title('(b) Saturday')

figure(3)
set(gcf,'DefaultAxesFontSize',16)  %<--------set character size
set(gcf,'DefaultTextFontSize',16)
plot([1:1:24*60*8]/60,Totalwasher,'b')
hold on
plot([1:1:24*60*8]/60,Totaldryer,'r')
xlim([0 24*8])
xlabel('Time (minute)')
ylabel('Power (kW)')

legend('washer','dryer')
title('(c) Monday to Sunday')

    
    
    
    