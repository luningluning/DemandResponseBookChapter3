
% Code written by Dr. Ning Lu for DR book
% Example 3.5
% Code written 9/21/2017
% Copyright North Carolina State University

clear all 
close all

Tout = [0];
color = ['rgbcm'];
Time = 60; % in minutes
Timestep = 1; % second
N_timestep = Time*60/Timestep;
Tset = 20; % degree C
TDB = 1; %degree C
Prated = 5020; %W
Area = 228;  % in m^2
Vair =  228*5; % m^3
DensityAir = 1.225;  % kg/m^3
Cp_air = 1005; % J/kg.k
Cv_air = 780;  % J/kg.k
C_funiture = 1000; % J/kg.k
V_furniture = 1000; %kg
UA = 111;  %W/degree C
UAmass = 3924; %W/degree C

T_on=0;
T_off=0;

Tmax = Tset + 0.5*TDB
Tmin = Tset - 0.5*TDB


for i  = 1:5000
    trise(i) = 500+100*rand(1);
    tfall(i) = 640+80*rand(1);
    Q = Prated + Prated*0.05*(rand(1)-0.5); %W
    heater_mode = 1;
    [R, C] = cal_RCpara(Tmax, Tmin, Tout, trise(i), tfall(i), Q, heater_mode)
    R_record(i) = R;
    C_record(i) = C;
    Q_record(i) = Q;
end

figure(2)
set(gcf,'DefaultAxesFontSize',14)  %<--------set character size
set(gcf,'DefaultTextFontSize',14)
subplot(1,2,1)
hist(R_record)
xlabel('Thermal Resistance (^oC/W)')
ylabel('number of occurrence')
title('Histogram of R')

subplot(1,2,2)

hist(C_record)
xlabel('Thermal Capacitance (J/^oC)')
ylabel('number of occurrence')
title('Histogram of C')



figure(10)
set(gcf,'DefaultAxesFontSize',14)  %<--------set character size
set(gcf,'DefaultTextFontSize',14)
subplot(1,3,1)
hist(trise)
xlabel('Time (second)')
ylabel('number of occurrence')
title('Histogram of \tau_{on}')
subplot(1,3,2)
hist(tfall)
xlabel('Time (second)')
ylabel('number of occurrence')
title('Histogram of \tau_{off}')
subplot(1,3,3)
hist(Q_record)
xlabel('Heat Flow (W)')
ylabel('number of occurrence')
title('Histogram of Q')

