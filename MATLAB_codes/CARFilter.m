function [O2Hb,HHb] = CARFilter(O2Hb,HHb)

% Function applying the Common Average Reference (CAR) filter to fNIRS signals
%
% DESCRIPTION:
%   Applies a Common Average Reference (CAR) filter to fNIRS signals of 
%   oxyhemoglobin (O2Hb) and deoxyhemoglobin (HHb). The CAR filter reduces 
%   global noise and artifacts shared across channels by subtracting the 
%   average signal (computed across all channels) from each individual channel. 
%   This enhances the relative differences between channels and improves 
%   sensitivity to localized hemodynamic changes.
%
% INPUT:
% - O2Hb: cell array (n_subj x n_sessions). Each cell O2Hb{s,r} is a numeric 
%         matrix [n_channels x n_samples] containing the oxyhemoglobin signal 
%         for one subject and one session.
% - HHb : cell array (n_subj x n_sessions). Each cell HHb{s,r} is a numeric 
%         matrix [n_channels x n_samples] containing the deoxyhemoglobin signal 
%         for one subject and one session.
%
% OUTPUT:
% - O2Hb: cell array with the same size as input, containing the CAR-filtered 
%         oxyhemoglobin signals [n_channels x n_samples].
% - HHb : cell array with the same size as input, containing the CAR-filtered 
%         deoxyhemoglobin signals [n_channels x n_samples].

for s = 1:28
    for r = 1:3
        % average across channels
        O2Hb_mean = mean(O2Hb{s,r});
        HHb_mean = mean(HHb{s,r});
        for c = 1:36
            O2Hb{s,r}(c,:) = O2Hb{s,r}(c,:) - O2Hb_mean;
            HHb{s,r}(c,:) = HHb{s,r}(c,:) - HHb_mean;
        end
    end
end

end