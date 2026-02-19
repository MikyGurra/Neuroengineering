function [] = PlotGrandAverage(clab,t,O2Hb_RMI_GA,HHb_RMI_GA,O2Hb_LMI_GA,HHb_LMI_GA,SEM_O2Hb_RMI_GA,SEM_HHb_RMI_GA,SEM_O2Hb_LMI_GA,SEM_HHb_LMI_GA)

% Function plotting the Grand Average of fNIRS signals across subjects
%
% DESCRIPTION:
%   Produces figures showing the grand average (across subjects) of 
%   oxyhemoglobin (O2Hb) and deoxyhemoglobin (HHb) signals for both 
%   Right Motor Imagery (RMI) and Left Motor Imagery (LMI) tasks.
%   Each subplot corresponds to a specific channel, arranged according 
%   to the spatial layout of the optode montage. Error bands (± SEM) 
%   are superimposed to visualize variability across subjects.
%
% INPUT:
% - clab             : cell array of channel labels.
% - t                : time vector corresponding to the signals.
% - O2Hb_RMI_GA      : [channels x time] matrix of grand average O2Hb signals (RMI).
% - HHb_RMI_GA       : [channels x time] matrix of grand average HHb signals (RMI).
% - O2Hb_LMI_GA      : [channels x time] matrix of grand average O2Hb signals (LMI).
% - HHb_LMI_GA       : [channels x time] matrix of grand average HHb signals (LMI).
% - SEM_O2Hb_RMI_GA  : [channels x time] matrix of standard error of O2Hb signals (RMI).
% - SEM_HHb_RMI_GA   : [channels x time] matrix of standard error of HHb signals (RMI).
% - SEM_O2Hb_LMI_GA  : [channels x time] matrix of standard error of O2Hb signals (LMI).
% - SEM_HHb_LMI_GA   : [channels x time] matrix of standard error of HHb signals (LMI).
%
% OUTPUT:
% The function generates two figures:
%   1. Grand Average plots for RMI task;
%   2. Grand Average plots for LMI task.

posChanSP = [2 4 8 10 12 14 16 18 20 22 24 26 30 32 34 36 38 40 42 44 46 48 52 54]; % channel position for the subplot
ordChanSP = [16 18 28 30 14 17 23 25 29 36 15 22 27 35 13 20 24 26 33 34 19 21 32 31]; % channel number associated to the subplot position

figure('Name','Grand Average (across subjects) for RMI task')
sgtitle('Grand Average for RMI task','FontSize',25)
ax=[];
chan_count = 1;
for jj = posChanSP
    ax(end+1)=subplot(5,11,jj);
    Oxy = O2Hb_RMI_GA(ordChanSP(chan_count),:);
    Deoxy = HHb_RMI_GA(ordChanSP(chan_count),:);
    SEM_Oxy = SEM_O2Hb_RMI_GA(ordChanSP(chan_count),:);
    SEM_Deoxy = SEM_HHb_RMI_GA(ordChanSP(chan_count),:);
    PlotErrorBand(t,Oxy,Deoxy,SEM_Oxy,SEM_Deoxy)
    set(gca, 'FontSize', 7);

    % Retrieve the current position assigned by subplot
    p = get(gca, 'Position'); 
    
    % Define an expansion factor
    stretch_factor_w = 1.3; 
    stretch_factor_h = 0.8;
    
    % Calculate the current center of the plot
    cx = p(1) + p(3)/2;
    cy = p(2) + p(4)/2;
    
    % Calculate the new expanded dimensions
    p(3) = p(3) * stretch_factor_w; % New width
    p(4) = p(4) * stretch_factor_h; % New height
    
    % Recalculate the origin (x,y) to keep the plot centered
    p(1) = cx - p(3)/2;
    p(2) = cy - p(4)/2;
    
    % Apply the new position
    set(gca, 'Position', p);

    % Channel title and axis labels
    title(clab(ordChanSP(chan_count))+" ("+num2str(ordChanSP(chan_count))+")")
    xlabel("Time [s]",'FontSize',7), ylabel("\DeltaHb [mM mm]",'FontSize',7)
    
    % Highlight ROI channels with a yellow rectangle
    if ordChanSP(chan_count) == 20 || ordChanSP(chan_count) == 21 || ordChanSP(chan_count) == 24 
        hold on
        xl = xlim;
        yl = [-5e-3 5e-3];
        rectangle('Position',[xl(1),yl(1),diff(xl),diff(yl)],'EdgeColor','y','LineWidth',2)
    end
    % Update the channel counter
    chan_count = chan_count+1;
end
chan_count = chan_count-1;
linkaxes(ax,'y')
pause(0.1)

% Global legend in the center of the figure
subplot(5,11,28)
plot(0, 1, Color="#D95319", LineWidth=1.5), hold on
plot(10, 1, Color="#0072BD", LineWidth=1.5), hold on
fill([0, fliplr(0)], [2', fliplr(-2')], 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none'), hold on
fill([10, fliplr(10)], [2', fliplr(-2')], 'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none'), hold on
yline(0, '--k', LineWidth=0.8), hold off
axis("off"), legend("\DeltaO_2Hb", "\DeltaHHb", "\DeltaO_2Hb SE Band", "\DeltaHHb SE Band", "Cue, Task Onset and Offset",  Location="best", FontSize=7)


figure('Name','Grand Average (across subjects) for LMI task')
sgtitle('Grand Average for LMI task','FontSize',25)
ax=[];
chan_count = 1;
for jj = posChanSP
    ax(end+1)=subplot(5,11,jj);
    Oxy = O2Hb_LMI_GA(ordChanSP(chan_count),:);
    Deoxy = HHb_LMI_GA(ordChanSP(chan_count),:);
    SEM_Oxy = SEM_O2Hb_LMI_GA(ordChanSP(chan_count),:);
    SEM_Deoxy = SEM_HHb_LMI_GA(ordChanSP(chan_count),:);
    PlotErrorBand(t,Oxy,Deoxy,SEM_Oxy,SEM_Deoxy)

    set(gca, 'FontSize', 7);

    % Retrieve the current position assigned by subplot
    p = get(gca, 'Position'); 
    
    % Define an expansion factor 
    stretch_factor_w = 1.3; 
    stretch_factor_h = 0.8;
    
    % Calculate the current center of the plot
    cx = p(1) + p(3)/2;
    cy = p(2) + p(4)/2;
    
    % Calculate the new expanded dimensions
    p(3) = p(3) * stretch_factor_w; % New width
    p(4) = p(4) * stretch_factor_h; % New height
    
    % Recalculate the origin (x,y) to keep the plot centered
    p(1) = cx - p(3)/2;
    p(2) = cy - p(4)/2;
    
    % Apply the new position
    set(gca, 'Position', p);

    % Channel title and axis labels
    title(clab(ordChanSP(chan_count))+" ("+num2str(ordChanSP(chan_count))+")")
    xlabel("Time [s]"), ylabel("\DeltaHb [mM mm]")
    
    % Highlight ROI channels with a yellow rectangle
    if ordChanSP(chan_count) == 26 || ordChanSP(chan_count) == 32 || ordChanSP(chan_count) == 33 
        hold on
        xl = xlim;
        yl = [-5e-3 5e-3];
        rectangle('Position',[xl(1),yl(1),diff(xl),diff(yl)],'EdgeColor','y','LineWidth',2)
    end
    % Update the channel counter
    chan_count = chan_count+1;
end
chan_count = chan_count-1;
linkaxes(ax,'y')

% Global legend in the center of the figure
subplot(5,11,28)
plot(0, 1, Color="#D95319", LineWidth=1.5), hold on
plot(10, 1, Color="#0072BD", LineWidth=1.5), hold on
fill([0, fliplr(0)], [2', fliplr(-2')], 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none'), hold on
fill([10, fliplr(10)], [2', fliplr(-2')], 'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none'), hold on
yline(0, '--k', LineWidth=0.8), hold off
axis("off"), legend("\DeltaO_2Hb", "\DeltaHHb", "\DeltaO_2Hb SE Band", "\DeltaHHb SE Band", "Cue, Task Onset and Offset",  Location="best", FontSize=7)
end