% Sample code written by Dr. Ning LU
% Code written by Dr. Ning Lu for DR book
% Code written 9/21/2017
% Copyright North Carolina State University


clear all
close all


load house1.mat
[x,y] = size(House_power);
start_time = 309;  %this is oct 1, 2015
end_time = 309+24*2*365;  %this is oct 1, 2015

start_time = 309;  %this is oct 1, 2015
end_time = 309+24*2;  %this is oct 1, 2015

for i = 1:7
    start_time = 309+24*2*(164+i);  %this is oct 1, 2015
    end_time = 309+24*2*(165+i);  %this is oct 1, 2015

    figure(1)
    set(gcf,'DefaultAxesFontSize',14)  %<--------set character size
    set(gcf,'DefaultTextFontSize',14)    
    plot([0:1:end_time-start_time]/2,House_power(start_time:1:end_time))
    xlabel('Time of the day')
    ylabel('Power (kW)')
    hold on
    xlim([0 24])
end

legend('M','T','W','TH','F','Sat','Sun')
text(1, 3,'A week in April')
