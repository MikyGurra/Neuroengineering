function [O2Hb_RH_RMI,O2Hb_LH_RMI,O2Hb_RH_LMI,O2Hb_LH_LMI] = ROIExtraction(O2Hb_RMI,O2Hb_LMI,RH,LH)
% Function extracting region-of-interest (ROI) signals from O2Hb data 
% 
% DESCRIPTION: 
% For each subject (N=28), separately for two tasks (LMI and RMI), the function: 
% 1. Collects O2Hb signals from channels specified in RH and LH indices. 
% 2. Stores the raw ROI signals in the first column of each output cell array.
% 3. Computes the mean ROI signal (1 × n_samples) by averaging across channels 
%    and trials, and stores it in the second column of each output cell
%    array.
%
% INPUT:
% - O2Hb_RMI : cell array (28 × 1). Each cell contains O2Hb signals 
%              [n_channels × n_samples × n_trials] for RMI task. 
% - O2Hb_LMI : cell array (28 × 1). Each cell contains O2Hb signals 
%              [n_channels × n_samples × n_trials] for LMI task. 
% - RH : vector of channel indices belonging to the right hemisphere ROI. 
% - LH : vector of channel indices belonging to the left hemisphere ROI.
%
% OUTPUT: 
% - O2Hb_RH_RMI : cell array (28 × 2). Column 1: raw RH ROI signals during RMI.
%                 Column 2: mean RH ROI signal [1 × n_samples].
% - O2Hb_LH_RMI : cell array (28 × 2). Column 1: raw LH ROI signals during RMI. 
%                 Column 2: mean LH ROI signal [1 × n_samples]. 
% - O2Hb_RH_LMI : cell array (28 × 2). Column 1: raw RH ROI signals during LMI. 
%                 Column 2: mean RH ROI signal [1 × n_samples]. 
% - O2Hb_LH_LMI : cell array (28 × 2). Column 1: raw LH ROI signals during LMI. 
%                 Column 2: mean LH ROI signal [1 × n_samples].
%NOTE: On the second column we calculate the features.
O2Hb_RH_RMI = cell(28,1);
O2Hb_LH_RMI = cell(28,1);
O2Hb_RH_LMI = cell(28,1);
O2Hb_LH_LMI = cell(28,1);

for i=1:28

    % RMI Task
    O2Hb_RH_RMI{i,1} = O2Hb_RMI{i,1}(RH, :, :);
    O2Hb_LH_RMI{i,1} = O2Hb_RMI{i,1}(LH, :, :);
    
    % LMI Task
    O2Hb_RH_LMI{i,1} = O2Hb_LMI{i,1}(RH, :, :);
    O2Hb_LH_LMI{i,1} = O2Hb_LMI{i,1}(LH, :, :);
    
    O2Hb_RH_RMI{i,2} = mean(squeeze(mean(O2Hb_RH_RMI{i,1}, 1)), 2)';
    O2Hb_LH_RMI{i,2} = mean(squeeze(mean(O2Hb_LH_RMI{i,1}, 1)), 2)';
    
    O2Hb_RH_LMI{i,2} = mean(squeeze(mean(O2Hb_RH_LMI{i,1}, 1)), 2)';
    O2Hb_LH_LMI{i,2} = mean(squeeze(mean(O2Hb_LH_LMI{i,1}, 1)), 2)';

end