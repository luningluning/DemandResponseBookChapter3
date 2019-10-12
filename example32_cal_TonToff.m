% Code written by Dr. Ning Lu for DR book
% Code written 9/21/2017
% Copyright North Carolina State University

clear all 
close all

for ii = 1:5
    % Simulation setup
    Tout = [-10 -5 0 5 10];
    color = ['rgbcm'];
    Time = 60 % in minutes
    Timestep = 1 % second
    N_timestep = Time*60/Timestep;
    Tset = 20 % degree C
    TDB = 1 %degree C
    Prated = 5020 %W
    Area = 228  % in m^2
    Vair =  228*5 % m^3
    DensityAir = 1.225  % kg/m^3
    Cp_air = 1005 % J/kg.k
    Cv_air = 780  % J/kg.k
    C_funiture = 1000 % J/kg.k
    V_furniture = 1000 %kg
    UA = 111  %W/degree C
    UAmass = 3924 %W/degree C
    T_on=0;
    T_off=0;
  
    R1 = 1/UA
    R2 = 1/UAmass
    Ca = Vair*DensityAir*Cv_air  
    Cm = V_furniture*C_funiture

    A = [-(1/(R2*Ca)+1/(R1*Ca))  1/(R2*Ca); 1/(R2*Cm)  -1/(R2*Cm)]
    B = [1/(R1*Ca) 1/Ca ;0 0]
    C = [1 0; 0 1]
    D = [0; 0]

    status = zeros(1, Time);
    Q =  zeros(1, Time);

    x0 = [19.5; 19.5]
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
    u0 = [Tout(ii); Q0]    

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
        u0 = [Tout(ii); Q(i)];
        Troom_record(i-1,1) = x1(1);
        Tmass_record(i-1,1) = x1(2);
    end
    Time = [0:Timestep:((N_timestep-2)*Timestep)]/60;
    
    figure(1)
    set(gcf,'DefaultAxesFontSize',14)  %<--------set character size
    set(gcf,'DefaultTextFontSize',14)
    plot(Time,Troom_record,color(ii))
    % plot(Tmass_record,'b')
    xlabel('Time (minute)')
    ylabel('Temperature (^oC)')
    hold on
    title('Room Temperature Profiles')
   
    
    Toutcal(ii) = Tout(ii);
    Toncal(ii) = max(T_on(1000:end));
    Toffcal(ii) = max(T_off);
    
    filename = ['Troom_record' num2str(ii)];
    save(filename, 'Troom_record','T_on', 'T_off','Toutcal')
    
    
end

figure(1)
legend('T=-10^oC','T=-5^oC', 'T=0^oC','T=5^oC','T=10^oC')
    
figure(2)
set(gcf,'DefaultAxesFontSize',14)  %<--------set character size
set(gcf,'DefaultTextFontSize',14)
plot(Toutcal, Toncal,'ro')
hold on
plot(Toutcal, Toffcal,'b^')
title('On/Off Time versus T_{outdoor}')
legend('\tau_{on}','\tau_{off}')
xlabel('T_{outdoor} (^oC)')
ylabel('Time (second)')

p1=polyfit(Toutcal,Toncal,3);
Toutfit = [-15:1:15];
Tonfit = polyval(p1,Toutfit)
plot(Toutfit,Tonfit,'m')

p2=polyfit(Toutcal,Toffcal,3);
Toutfit = [-15:1:15];
Tofffit = polyval(p2,Toutfit)
plot(Toutfit,Tofffit,'c')
