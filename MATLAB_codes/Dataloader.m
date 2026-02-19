function [NIRS_Signals,clab] = Dataloader()

% Function performing the loading of NIRS data
%
% DESCRIPTION:
%   This function loads the raw fNIRS motor-imagery dataset from the local
%   "./Data" folder. For each subject folder (S1, S2, ...), it reads the
%   concentration signals stored in MI_cnt.mat and the corresponding markers
%   (time vectors and class labels) stored in MI_mrk.mat. All information is
%   collected into a struct (NIRS_Signals) with one field per subject.
%
% INPUT:
%   None. Data are read from disk assuming the directory structure:
%     ./Data/S*/MI_cnt.mat   
%     ./Data/S*/MI_mrk.mat   
%     ./Data/S1/MI_mnt.mat   
%
% OUTPUT:
% - NIRS_Signals : struct with one field per subject. Each subject S#, 
%                  contain the following fields:
%                   - x1, x2, x3: numeric arrays containing the fNIRS signals
%                                     from MI_cnt{1,k}.x (k = 1:3).
%                                     Dimensions depend on the dataset file
%                                     n_channels x n_samples x _trials.
%                   - t1, t2, t3     : time vectors from MI_mrk{1,k}.time (k = 1:3).
%                   - class1, class2, class3 : label/marker matrixes from MI_mrk{1,k}.y
%                                              (2 x nTrials indicating LMI/RMI).
% 
% - clab : vector (n_channels x 1) containing the labels of the fNIRS channels.

addpath('.')
pathname='./Data';
s = dir(fullfile(pathname, 'S*'));

for i_s = 1:numel(s)-1
    subjName = s(i_s).name;                             % ex. 'S1', 'S2', ...    
                                                        % don't consider the 13th subject (left-handed)
    idx = strcmp({s.name}, 'S13');                      % find the index of the row named 'S13'
    s(idx) = []; 
    subjPath = fullfile(pathname, subjName);  
                                                        % consider a file MI_cnt.mat in a directory "MI_cnt"
    miPath  = fullfile(subjPath, 'MI_cnt.mat');
    S = load(miPath, 'MI_cnt');                         % variable MI_cnt in S.MI_cnt
                                                        % NIRS_Signals is a structure that holds the useful NIRS signals and data 
    NIRS_Signals.(subjName).x1 = S.MI_cnt{1,1}.x;       % MI_cnt is a 1x3 cell
    NIRS_Signals.(subjName).x2 = S.MI_cnt{1,2}.x;
    NIRS_Signals.(subjName).x3 = S.MI_cnt{1,3}.x;
    miPath_time  = fullfile(subjPath, 'MI_mrk.mat');
    T = load(miPath_time, 'MI_mrk');
    NIRS_Signals.(subjName).t1 = T.MI_mrk{1,1}.time;    % MI_cnt is a 1x3 cell
    NIRS_Signals.(subjName).t2 = T.MI_mrk{1,2}.time;
    NIRS_Signals.(subjName).t3 = T.MI_mrk{1,3}.time;
    NIRS_Signals.(subjName).class1 = T.MI_mrk{1,1}.y;
    NIRS_Signals.(subjName).class2 = T.MI_mrk{1,2}.y;
    NIRS_Signals.(subjName).class3 = T.MI_mrk{1,3}.y;
end

clab = load('.\Data\S1\MI_mnt.mat').MNT.clab;

end

