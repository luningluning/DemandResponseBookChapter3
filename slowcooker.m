% Code written by Dr. Ning Lu
% Home Energy Management ToolBox version 2.0
% Appliance model database - second by second data
% copyright by North Carolina State University
% Date: May 17 2016
% This model is developed based on measurement data
% Slow cooker load is resistive.
% User can select the turn on time and turn off time


function [P, Q] = slowcooker(t_s, t_e, mode)
%time step is second by second
P0 = 0;
if t_e > t_s
    % initialization
    t_on = t_e-t_s;
    P = zeros(t_on,1);
    Q = zeros(t_on,1);
    
    if mode == 1 % 4~6 hour cooking
        P = 296*ones(t_on,1);
    elseif mode == 2 % 8~10 hour cooking
        n = ceil(t_on/15);
        P_cycle = [253	253	138	253	253	138	253	253	137	253	253	156	234	253	207	184]';
        for i = 1:n
            P0 = [P0;P_cycle];
        end
        P = P0(2:t_on+1);
    end

else
    error('appliance turn on time should be greater than zero')
end
