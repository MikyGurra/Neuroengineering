function [features_RH_RMI,features_RH_LMI,features_LH_RMI,features_LH_LMI] = FeatureExtraction(t,O2Hb_RH_RMI,O2Hb_LH_RMI,O2Hb_RH_LMI,O2Hb_LH_LMI)

% DESCRIPTION:
%   Computes and organizes a set of features derived from oxyhemoglobin (O2Hb) 
%   signals recorded in different experimental conditions:
%   - Right Hemisphere during Right Motor Imagery (RH-RMI)
%   - Left Hemisphere during Right Motor Imagery (LH-RMI)
%   - Right Hemisphere during Left Motor Imagery (RH-LMI)
%   - Left Hemisphere during Left Motor Imagery (LH-LMI)
%
%   For each subject (N=28), and for each condition, the function extracts 
%   three features within a predefined activation window:
%   1. Mean value of the signal (column 1).
%   2. Slope of the signal (column 2). 
%   3. Maximum peak amplitude (column 3).
%
%   The extraction of features is performed by the auxiliary function 
%   ComputeFeatures, which returns the values for each trial.
%
%   After feature computation, the function performs a quality check:
%   - Trials in which the second feature (variance) is undefined (NaN) 
%     are identified.
%   - These trials are removed from all corresponding datasets, ensuring 
%     that the final matrices contain only valid data.
%
% INPUT:   DA CONTROLLARE
% - t             : time vector corresponding to the signals.
% - O2Hb_RH_RMI   : cell array (28 x 2), each cell contains O2Hb signals 
%                   for the right hemisphere during RMI.
% - O2Hb_LH_RMI   : cell array (28 x 2), each cell contains O2Hb signals 
%                   for the left hemisphere during RMI.
% - O2Hb_RH_LMI   : cell array (28 x 2), each cell contains O2Hb signals 
%                   for the right hemisphere during LMI.
% - O2Hb_LH_LMI   : cell array (28 x 2), each cell contains O2Hb signals 
%                   for the left hemisphere during LMI.
%
% OUTPUT
% - features_RH_RMI : matrix [28 x 3] containing features for RH during RMI.
% - features_LH_RMI : matrix [28 x 3] containing features for LH during RMI.
% - features_RH_LMI : matrix [28 x 3] containing features for RH during LMI.
% - features_LH_LMI : matrix [28 x 3] containing features for LH during LMI.

features_RH_RMI = nan(28,3);
features_RH_LMI = nan(28,3);
features_LH_RMI = nan(28,3);
features_LH_LMI = nan(28,3);

idx_act_window = 101:260;
for i=1:28
    [media, slope, peak_val] = ComputeFeatures(O2Hb_RH_RMI{i,2},t,idx_act_window);
    features_RH_RMI(i,:) = [media, slope, peak_val];
    [media, slope, peak_val] = ComputeFeatures(O2Hb_LH_RMI{i,2},t,idx_act_window);
    features_LH_RMI (i,:) = [media, slope, peak_val];
    [media, slope, peak_val] = ComputeFeatures(O2Hb_RH_LMI{i,2},t,idx_act_window);
    features_RH_LMI (i,:) = [media, slope, peak_val];
    [media, slope, peak_val] = ComputeFeatures(O2Hb_LH_LMI{i,2},t,idx_act_window);
    features_LH_LMI (i,:) = [media, slope, peak_val];
end

idx_RH_RMI_NaN = [];
idx_LH_RMI_NaN = [];
idx_RH_LMI_NaN = [];
idx_LH_LMI_NaN = [];
for i=1:28
    v_rh_RMI_NaN = isnan(features_RH_RMI(i,2));
    if v_rh_RMI_NaN==1
        idx_RH_RMI_NaN = [idx_RH_RMI_NaN; i]; 
    end
    v_lh_RMI_NaN = isnan(features_LH_RMI(i,2));
    if v_lh_RMI_NaN==1
        idx_LH_RMI_NaN = [idx_LH_RMI_NaN; i]; 
    end
    v_rh_LMI_NaN = isnan(features_RH_LMI(i,2));
    if v_rh_LMI_NaN==1
        idx_RH_LMI_NaN = [idx_RH_LMI_NaN; i]; 
    end
    v_lh_LMI_NaN = isnan(features_LH_LMI(i,2));
    if v_lh_LMI_NaN==1
        idx_LH_LMI_NaN = [idx_LH_LMI_NaN; i]; 
    end
end

idx_RMI_NaN = sort(unique([idx_RH_RMI_NaN(:); idx_LH_RMI_NaN(:)], 'stable'));
idx_LMI_NaN = sort(unique([idx_RH_LMI_NaN(:); idx_LH_LMI_NaN(:)], 'stable'));

features_RH_RMI(idx_RMI_NaN, :) = [];
features_LH_RMI(idx_RMI_NaN, :) = [];
features_RH_LMI(idx_LMI_NaN, :) = [];
features_LH_LMI(idx_LMI_NaN, :) = [];

end