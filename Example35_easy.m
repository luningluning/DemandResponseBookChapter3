% Code written by Dr. Ning Lu for DR book
% Code written 9/21/2017
% Copyright North Carolina State University

clear all
close all

Pwasherrated = 0.4;
Pdryerrated = 6;

%probability density function
Prob_dayofweek = [0.1	0.1	0.1	0.05	0.05	0.3	0.3	];
Prob_timeoftheday_wkday = [0	0	0	0	0	0	0	0.01	0.01	0.1	0.1	0.06	0.06	0.06	0.06	0.06	0.06	0	0.06	0.1	0.1	0.1	0.06	0];
Prob_timeoftheday_wkend = [0	0	0	0	0	0	0	0.1	0.1	0.1	0.1	0.07	0.05	0.04	0.03	0.02	0.03	0.04	0.06	0.15	0.08	0.02	0.01	0];
Prob_loading =[0.1	0.2	0.35	0.3	0.04	0.01];
Prob_dryonafterwashingdone = [0.5	0.25	0.15	0.07	0.02	0.01];


Washeronduration = [30:1:60];
dryerontime = [45:1:75];
Tnextloading = [-5:1:5];
dryonafterwashingdone = [5 10 15 20 25 30];

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

P_washer = zeros(1000,24*60*7);
P_dryer = zeros(1000,24*60*7);

for i = 1:1000
    All_rand = rand(10,1);
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
    T_washeron(i) = (dayofweek-1)*24*50 + timeofday*60 + minuteofhour;
    T_washeroff(i) = T_washeron(i) + floor(All_rand(4)*30) + 30;
    P_washer(i,T_washeron(i):T_washeroff(i)) = Pwasherrated;
    
    T_dryeron_value  = dryonafterwashingdone(min(find(PCF_dryonafterwashingdone>=All_rand(5))));
      
    T_dryeron(i) = T_washeroff(i) + T_dryeron_value - floor(All_rand(6)*5);
    T_dryeroff(i) = T_dryeron(i) + floor(All_rand(7)*30) + 45;
    P_dryer(i,T_dryeron(i):T_dryeroff(i)) = Pdryerrated;
%     figure(1)
%     plot([1:1:24*60*7]/60,P_washer(i,:))
%     hold on
%     plot([1:1:24*60*7]/60,P_dryer(i,:))
%     xlim([1 24*7])
    
end
    
Totalwasher = sum(P_washer);
Totaldryer = sum(P_dryer);
figure(2)
set(gcf,'DefaultAxesFontSize',16)  %<--------set character size
set(gcf,'DefaultTextFontSize',16)
plot([1:1:24*60*7]/60,Totalwasher,'b')
hold on
plot([1:1:24*60*7]/60,Totaldryer,'r')
xlim([1 24*7])
xlabel('Time (minute)')
ylabel('Power (kW)')
legend('washer','dryer')


    
    
    
    
    
    
    
    