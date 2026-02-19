function [] = PlotErrorBand(t,O2Hb_t,HHb_t,std_O2Hb,std_HHb)

% Function plotting fNIRS signals with error bands
%
% DESCRIPTION:
%   Plots the averaged oxyhemoglobin (O2Hb) and deoxyhemoglobin (HHb) signals 
%   together with their respective error bands, defined by ± standard
%   error.
%
% INPUT:
% - t        : time vector corresponding to the signals.
% - O2Hb_t   : vector containing the averaged O2Hb signal.
% - HHb_t    : vector containing the averaged HHb signal.
% - std_O2Hb : vector representing the standard deviation of O2Hb.
% - std_HHb  : vector representing the standard deviation of HHb.
%
% OUTPUT:
% The function produces a plot:
%   - O2Hb signal (red line) with shaded error band; 
%   - HHb signal (blue line) with shaded error band.
%
% NOTES:
% - Vertical dashed lines are added to mark key experimental events:
%   - –2 s: instruction presentation
%   - 0 s : task onset
%   - 10 s: end of task execution

global lambda
global alphaO2Hb
global alphaHHb
global B 
global d
global fs
global fL
global fH

y1 = O2Hb_t+std_O2Hb;
y2 = O2Hb_t-std_O2Hb;

X = [t, t(end:-1:1)];          % 2N x 1
Y_oxy = [y1, y2(end:-1:1)];    % 2N x 1

plot(t,O2Hb_t,'r')
hold on
fill(X,Y_oxy,'r','FaceAlpha','0.25','EdgeColor','none')

y1 = HHb_t+std_HHb;
y2 = HHb_t-std_HHb;

Y_deoxy = [y1, y2(end:-1:1)];

plot(t, HHb_t,'b')
hold on
fill(X,Y_deoxy,'b','FaceAlpha','0.25','EdgeColor','none')
hold off
xticks([-5, 0, 5, 10, 15, 20, 25]);
xlim([-5 25]);
xline(-2,'--k','LineWidth',1);
xline(0,'--k','LineWidth',1);
xline(10,'--k','LineWidth',1);

end