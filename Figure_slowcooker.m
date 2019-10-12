clear all
close all


simulation_time = 24*60*60;
t = [1:1:simulation_time]';

P_total = zeros(simulation_time,1);
P_slowcooker = zeros(simulation_time,1);

t_s = 7*60*60+30*60;
t_e = t_s + 10*60*60;

mode =2;

[P, Q] = slowcooker(t_s, t_e, mode);
P_slowcooker(t_s:t_e-1)= P;

figure(1)
set(gcf,'DefaultAxesFontSize',16)  %<--------set character size
set(gcf,'DefaultTextFontSize',16)
plot(t/60/60, P_slowcooker)


