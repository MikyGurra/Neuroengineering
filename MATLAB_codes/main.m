%% Main code
% This code performs the analysis of a series of provided NIRS signals
% accordingly to the report.
% Run one section at a time.
% Group 17 (Vito Ruggero Davino, Camilla Dona, Michele Gurra, Rebecca
% Ingargiola) - Neuroengineering Course A.A. 2025/2026

clearvars
close all 
clc 

%% Define the parameters related to the pre-processing step (Lambert-Beer law and filtering) 

global lambda
global alphaO2Hb
global alphaHHb
global B 
global d
global fs
global fL
global fH
lambda = [760 850];             % High and low wavelengths [nm]
alphaO2Hb = [0.586, 1.058];     % Absorption coefficients for HbO2 at 760nm and 850nm [1/((mmol/L)*cm)]
alphaHHb = [1.54852, 0.69132];  % Absorption coefficients for HHb at 760nm and 850nm [1/((mmol/L)*cm)]
B = [7.15, 5.98];               % Scattering coefficients at high and low wavelength [adim]
d = 3;                          % Interelectrode distance [cm]
fs = 10;                        % Sampling frequency [Hz]
fL = 0.01;                      % High cutoff frequency [Hz]
fH = 0.09;                      % Low cutoff frequency [Hz]

%% Load the data from the supplied files 

% Run once to save the files
[NIRS_Signals,clab] = Dataloader();
save('NIRS_Signals.mat','NIRS_Signals')
save('Channel_label.mat','clab')

% Run if the files are already saved
% load('NIRS_Signals.mat')
% load('Channel_label.mat')

%% Apply Lambert-Beer law to the raw light intensity data and compute concentration values for HHb and O2Hb

[HHb_raw, O2Hb_raw] = LambertBeerLaw(NIRS_Signals);

%% Filter the O2Hb and HHb signals with a bandpass filter

HHb_filt = BandpassFilter(HHb_raw,fL,fH,fs);
O2Hb_filt = BandpassFilter(O2Hb_raw,fL,fH,fs);

%% Apply the CAR Filter

[O2Hb,HHb] = CARFilter(O2Hb_filt,HHb_filt);

%% Time segment the signals into 30s epochs (pre-rest: 3s, cue+task: 2s+10s, rest: 15s)

% Extract the onset events from NIRS_Signals
time = cell(28,1);
for i = 1: numel(fieldnames(NIRS_Signals))+1 
    if i == 13                      % if subject 13 does not exist
        continue                    % skip to the next iteration
    end
    field = sprintf('S%d',i);
    data_subj = NIRS_Signals.(field);
    for n = 1:3
        signal = sprintf('t%d',n);
        time_subj(n,:) = data_subj.(signal);
    end
    time{i} = time_subj; 
end
time(13,:) = [];

% Compute the time segmentation of the O2Hb and HHb signals
HHb = TimeSegmentation(HHb,time);
O2Hb = TimeSegmentation(O2Hb,time);

%% Split the signals into left- and right- task 

% Extract the labels of the task classes (left and right) from NIRS_Signals
label = cell(28,1);
for i = 1: numel(fieldnames(NIRS_Signals))+1 
    if i == 13                      % if subject 13 does not exist
        continue                    % skip to the next iteration
    end
    field = sprintf('S%d',i);
    data_subj = NIRS_Signals.(field);
    mat = [];                       % Initialize mat to store class labels
    for n = 1:3
        lab = sprintf('class%d',n);
        mat = [mat, data_subj.(lab)];
    end 
    label{i} = mat; 
end
label(13,:) = [];

% Compute the splitting of the tasks between the RMI and LMI
[HHb_LMI, HHb_RMI] = RightLeftSplit(HHb,label);
[O2Hb_LMI, O2Hb_RMI] = RightLeftSplit(O2Hb,label); 

%% Compute the average on the trials for each subject

for i=1:28
    O2Hb_RMI{i,2} = mean(O2Hb_RMI{i,1},3);
    O2Hb_LMI{i,2} = mean(O2Hb_LMI{i,1},3);
    HHb_RMI{i,2} = mean(HHb_RMI{i,1},3);
    HHb_LMI{i,2} = mean(HHb_LMI{i,1},3);
end

%% Compute the Grand Average (average on the subjects) of the O2Hb and HHb signals

[O2Hb_RMI_GA,O2Hb_LMI_GA,HHb_RMI_GA,HHb_LMI_GA] = GrandAverage(O2Hb_RMI,O2Hb_LMI,HHb_RMI,HHb_LMI);

%% Compute the average on the trials for each subject

O2Hb_RMI_trial_avg = cat(3, O2Hb_RMI{:, 2});
O2Hb_LMI_trial_avg = cat(3, O2Hb_LMI{:, 2});
HHb_RMI_trial_avg = cat(3, HHb_RMI{:, 2});
HHb_LMI_trial_avg = cat(3, HHb_LMI{:, 2});
SEM_O2Hb_RMI_GA = std(O2Hb_RMI_trial_avg,0,3)/sqrt(28);
SEM_O2Hb_LMI_GA = std(O2Hb_LMI_trial_avg,0,3)/sqrt(28);
SEM_HHb_RMI_GA = std(HHb_RMI_trial_avg,0,3)/sqrt(28);
SEM_HHb_LMI_GA = std(HHb_LMI_trial_avg,0,3)/sqrt(28);

%% Plot the grand averages on the channels of the two hemispheres for the two tasks

t = -5:1/fs:25-1/fs;
PlotGrandAverage(clab,t,O2Hb_RMI_GA,HHb_RMI_GA,O2Hb_LMI_GA,HHb_LMI_GA,SEM_O2Hb_RMI_GA,SEM_HHb_RMI_GA,SEM_O2Hb_LMI_GA,SEM_HHb_LMI_GA)

%% Space-averaged triplets extraction on the O2Hb signals for every subject on every trial for every task

% Select the channels on the right and left hemispheres
LH = [20,21,24]; 
RH = [26,32,33];
% Extract the signals from the hemispheres
[O2Hb_RH_RMI,O2Hb_LH_RMI,O2Hb_RH_LMI,O2Hb_LH_LMI] = ROIExtraction(O2Hb_RMI,O2Hb_LMI,RH,LH);

%% Features extraction for each ROI of each subject of each trial

[features_RH_RMI,features_RH_LMI,features_LH_RMI,features_LH_LMI] = FeatureExtraction(t,O2Hb_RH_RMI,O2Hb_LH_RMI,O2Hb_RH_LMI,O2Hb_LH_LMI);

%% Hypothesis tests

% Conduct a SW test to evaluate the normality of the distribution to be
% tested and then proceed either with Wilcoxon or Student test

media_RH_RMI = features_RH_RMI(:,1);
media_LH_RMI = features_LH_RMI(:,1);
[Hm_rR, pValuem_rR, Wm_rR] = SWTEST(media_RH_RMI, 0.05);
[Hm_lR, pValuem_lR, Wm_lR] = SWTEST(media_LH_RMI, 0.05);
[p1, h1, stats1] = signrank(media_RH_RMI, media_LH_RMI,'method','approximate');

slope_RH_RMI = features_RH_RMI(:,2);
slope_LH_RMI = features_LH_RMI(:,2);
[Hs_rR, pValues_rR, Ws_rR] = SWTEST(slope_RH_RMI, 0.05);
[Hs_lR, pValues_lR, Ws_lR] = SWTEST(slope_LH_RMI, 0.05);
[p2, h2, stats2] = signrank(slope_RH_RMI, slope_LH_RMI,'method','approximate');

peak_RH_RMI = features_RH_RMI(:,3);
peak_LH_RMI = features_LH_RMI(:,3);
[Hp_rR, pValuep_rR, Wp_rR] = SWTEST(peak_RH_RMI, 0.05);
[Hp_lR, pValuep_lR, Wp_lR] = SWTEST(peak_LH_RMI, 0.05);
[p3, h3, stats3] = signrank(peak_RH_RMI, peak_LH_RMI, 'method', 'approximate');

media_RH_LMI = features_RH_LMI(:,1);
media_LH_LMI = features_LH_LMI(:,1);
[Hm_rL, pValuem_rL, Wm_rL] = SWTEST(media_RH_LMI, 0.05);
[Hm_lL, pValuem_lL, Wm_lL] = SWTEST(media_LH_LMI, 0.05);
[h4, p4, ci4, stats4] = ttest(media_RH_LMI, media_LH_LMI);

slope_RH_LMI = features_RH_LMI(:,2);
slope_LH_LMI = features_LH_LMI(:,2);
[Hs_rL, pValues_rL, Ws_rL] = SWTEST(slope_RH_LMI, 0.05);
[Hs_lL, pValues_lL, Ws_lL] = SWTEST(slope_LH_LMI, 0.05);
[p5, h5, stats5] = signrank(slope_RH_LMI, slope_LH_LMI, 'method', 'approximate');

peak_RH_LMI = features_RH_LMI(:,3);
peak_LH_LMI = features_LH_LMI(:,3);
[Hp_rL, pValuep_rL, Wp_rL] = SWTEST(peak_RH_LMI, 0.05);
[Hp_lL, pValuep_lL, Wp_lL] = SWTEST(peak_LH_LMI, 0.05);
[p6, h6, stats6] = signrank(peak_RH_LMI, peak_LH_LMI,'method','approximate');

%% Boxplots

alpha = 0.05;

% Fix the y-limit for both the MI tasks
y_limits = [-0.005, 0.020]; 

% RMI
BoxplotFeatures(media_RH_RMI, media_LH_RMI, p1, slope_RH_RMI, slope_LH_RMI, p2, peak_RH_RMI, peak_LH_RMI, p3, 'RMI', alpha, y_limits);

% LMI
BoxplotFeatures(media_RH_LMI, media_LH_LMI, p4, slope_RH_LMI, slope_LH_LMI, p5, peak_RH_LMI, peak_LH_LMI, p6, 'LMI', alpha, y_limits);