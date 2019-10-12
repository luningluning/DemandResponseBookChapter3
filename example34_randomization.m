% Code written by Dr. Ning Lu for DR book
% Example 3.4
% Code written 9/21/2017
% Copyright North Carolina State University

clear all 
close all

for ii = 1:1000
     % Simulation setup
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
    
    Prated = Prated + Prated*0.05*(rand(1)-0.5); %W
    R1 = 1/(UA + UA*0.05*(rand(1)-0.5));
    R2 = 1/(UAmass + UAmass*0.05*(rand(1)-0.5));
    Ca = (Vair + Vair*0.05*(rand(1)-0.5))*DensityAir*Cv_air  ;
    Cm = (V_furniture + V_furniture*0.05*(rand(1)-0.5))*C_funiture;

    A = [-(1/(R2*Ca)+1/(R1*Ca))  1/(R2*Ca); 1/(R2*Cm)  -1/(R2*Cm)];
    B = [1/(R1*Ca) 1/Ca ;0 0];
    C = [1 0; 0 1];
    D = [0; 0];

    status = zeros(1, Time);
    Q =  zeros(1, Time);

    x0 = [19.5; 19.5];
    if x0(1) > (Tset + TDB/2)
        status(1) = 0;
    elseif x0(1)<(Tset - TDB/2)
        status(1) = 1;
    end
    if status(1) == 1
        Q0(1) = Prated*Timestep;
    else
        Q0(1) = 0;
    end
    u0 = [Tout; Q0];  

    for i = 2:1:N_timestep
        DT = A*x0  + B*u0;
        x1 = x0+DT;
        if (x1(1)>(Tset + TDB/2)) &&  (status(i-1) == 1)
            status(i) = 0;
        elseif (x1(1)< (Tset - TDB/2)) &&  status(i-1) == 0
            status(i) = 1;
        else
            status(i) = status(i-1);
        end
        if status(i) == 1
            Q(i) = Prated*Timestep;
            T_on(i,1) = T_on(i-1,1)+1;
            T_off(i,1) = 0;
        else
            Q(i) = 0;
            T_off(i,1) = T_off(i-1,1)+1;
            T_on(i,1) = 0;
        end
        x0 = x1;
        u0 = [Tout; Q(i)];
        Troom_record(i-1,1) = x1(1);
        Tmass_record(i-1,1) = x1(2);
    end
    Time = [0:Timestep:((N_timestep-2)*Timestep)]/60;
    
%     figure(1)
%     set(gcf,'DefaultAxesFontSize',14)  %<--------set character size
%     set(gcf,'DefaultTextFontSize',14)
%     plot(Time,Troom_record,color(ii))
%     % plot(Tmass_record,'b')
%     xlabel('Time (minute)')
%     ylabel('Temperature (^oC)')
%     hold on
%     title('Room Temperature Profiles')
   
    
    Toutcal(ii) = Tout;
    Toncal(ii) = max(T_on(1000:end));
    Toffcal(ii) = max(T_off);
    
%     filename = ['Troom_record' num2str(ii)];
%     save(filename, 'Troom_record','T_on', 'T_off','Toutcal')
    
    
end

% figure(1)
% legend('T=-10^oC','T=-5^oC', 'T=0^oC','T=5^oC','T=10^oC')
    
figure(2)
set(gcf,'DefaultAxesFontSize',14)  %<--------set character size
set(gcf,'DefaultTextFontSize',14)
subplot(1,2,1)
hist(Toncal)
xlabel('Time (second)')
ylabel('number of occurrence')
title('Histogram of \tau_{on}')

subplot(1,2,2)
hist(Toffcal)
xlabel('Time (second)')
ylabel('number of occurrence')
title('Histogram of \tau_{off}')


