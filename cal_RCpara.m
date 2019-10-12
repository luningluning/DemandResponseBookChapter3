function [R, C] = cal_RCpara(Tmax, Tmin, Tout, trise, tfall, Q, heater_mode)

disp('******If calculate heater parameters, heater_mode is 1. Otherwise it is 0.')
disp('******Q is positive if heating; Q is negative if cooling!!!!')
% if the heater mode
if heater_mode == 1
    RC = 1/(log((Tmax-Tout)/(Tmin-Tout))/tfall);
    R = (Tmax-Tout + (Tout-Tmin)*exp(-trise/RC))/(Q*(1-exp(-trise/RC)));
    C = RC/R;
elseif heater_mode == 0
    RC = 1/(log((Tmin-Tout)/(Tmax-Tout))/trise);
    R = (Tmin-Tout + (Tout-Tmax)*exp(-tfall/RC))/(Q*(1-exp(-tfall/RC)));
    C = RC/R;
else
    error('Please select 1 or 0 for heater_mode');
    display('If calculate heater parameters, heater_mode is 1. Otherwise it is 0.');
end