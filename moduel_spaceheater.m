function [Troom, SPHstatus, SPHSWstatus] = moduel_spaceheater(t0, t1, Tset, Tout, Troom, SPHstatus, SPHSWstatus)

%Set the household parameters
load RCQSPH
R=RSPH ; C=CSPH; Q=QSPH;

THlim = Tset;         % This is the setpoint low limit 
TLlim = Tset-2;         % This is the setpoint high limit

if SPHSWstatus == 1
    if SPHstatus == 0
        Y = Tout - (Tout -Troom)*exp(-(t1-t0)/(R*C));
    elseif SPHstatus == 1
        Y = Tout+ Q*R - (Tout + Q*R - Troom)*exp(-(t1-t0)/(R*C));
    else
    	error('SPHstatus has to be either 1 or 0')
    end
    Troom = Y;
    if Troom < TLlim & SPHstatus ~= 1
        SPHstatus = 1; 
    elseif Troom > THlim & SPHstatus ~= 0
        SPHstatus = 0; 
    end    
elseif SPHSWstatus == 0
    SPHstatus = 0;
    Y = Tout - (Tout -Troom)*exp(-(t1-t0)/(R*C));
    Troom = Y;
else
    error('SPHSWstatus has to be either 1 or 0');
end
clear R C Q
    
    
    
    
    
