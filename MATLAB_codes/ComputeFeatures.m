function [media, slope, peak_val] = ComputeFeatures(signal,t,idx_act_win)

% Function extracting descriptive features from fNIRS signals %
% DESCRIPTION: 
% Computes three features from a given fNIRS signal within a specified 
% activation window: 
% 1. Mean value of the signal; 
% 2. Slope defined as the difference between the signal value at the peak 
%    and at the preceding minimum. If no any valid peak is found, 
%    the slope is set to NaN;  
% 3. Maximum peak amplitude. If no any valid peak is found, the value is set to NaN;
%
% INPUT:
% - signal : vector containing the fNIRS signal from which features are extracted. 
% - t : time vector corresponding to the signal (same length as signal). 
% - idx_act_win : indices defining the activation window over which features are computed. 
% 
% OUTPUT: 
% - media : mean value of the signal within the activation window;
% - slope : slope of the rising phase preceding the main peak;
% - peak_val : amplitude of the maximum peak detected within the activation
%              window;
% - idx_peak_global: index of the peak in the original signal vector (global reference). 

sig_act = signal(idx_act_win);
t_act = t(idx_act_win);
media = mean(sig_act);
[pks, locs] = findpeaks(sig_act);

if isempty(pks)
    slope    = NaN;
    peak_val = NaN;
    idx_peak_global = NaN; 
    return;
end
[pks_sorted, idx_sort] = sort(pks, 'descend');
locs_sorted = locs(idx_sort);

slope = NaN;
idx_peak_global = NaN; 
peak_val = NaN;

for k = 1:length(pks_sorted)
    idx_peak_loc = locs_sorted(k);
    peak_val = pks_sorted(k);
    if idx_peak_loc <= 2
        slope    = NaN;
        peak_val = NaN;
        idx_peak_global = NaN; 
        continue;
    end
    sig_cut = sig_act(1:idx_peak_loc-1);
    if numel(sig_cut) < 3
        slope    = NaN;
        idx_peak_global = NaN; 
        peak_val = NaN;
        continue;
    end

    [mins, locs_min] = min(sig_cut);
    if isempty(mins)
        slope    = NaN;
        peak_val = NaN;
        idx_peak_global = NaN; 
        continue;   % go to the next peak
    end
    idx_min_loc = locs_min(end);
    idx_min_global  = idx_act_win(idx_min_loc);
    idx_peak_global = idx_act_win(idx_peak_loc);
    p = polyfit(t(idx_min_global:idx_peak_global),signal(idx_min_global:idx_peak_global), 1);
    slope = p(1);
    return

end 
end