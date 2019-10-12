% Code written by Dr. Ning Lu for DR book
% Code written 9/21/2017
% Copyright North Carolina State University

clear all
close all

% The power ratings of the washer and dryer
filenames = {'2016-05-26_2016-05-27_minutes.csv';'2016-05-27_2016-05-28_minutes.csv';'2016-05-28_2016-05-29_minutes.csv';'2016-05-29_2016-05-30_minutes.csv'}
j_index = 1;
feature = zeros(200,1);
switching = zeros(1000,1);
Time_onoff = zeros(1000,300);
fitprevious = 0;
n_day = 4;    
t = [0:5:5*12*24];

for ii = 1:n_day
    data = xlsread(filenames{ii});
    power_values = data(:,1);
    figure(ii)
    set(gcf,'DefaultAxesFontSize',14)  %<--------set character size
    set(gcf,'DefaultTextFontSize',14)    
    plot(t/60,power_values)
    hold on
    xlabel('Time of the day')
    ylabel('Power (Watt)')
    
end

xlim([0 24])   

clear all
load house1.mat

