function [O2Hb_right_avg_subj,O2Hb_left_avg_subj,HHb_right_avg_subj,HHb_left_avg_subj] = GrandAverage(O2Hb_right,O2Hb_left,HHb_right,HHb_left)

% Function computing the Grand Average (average across subjects) of fNIRS signals
%
% DESCRIPTION:
%   Computes the grand average of oxyhemoglobin (O2Hb) and deoxyhemoglobin (HHb) 
%   signals across all subjects. 
%   This provides an highlightment of the common patterns.
%
% INPUT:
% - O2Hb_right: cell array (28 x 2). Each cell O2Hb_right{i,2} contains 
%               a [36 x 300] matrix of oxyhemoglobin signals averaged across 
%               trials for subject i,right hemisphere.
% - O2Hb_left : cell array (28 x 2). Each cell O2Hb_left{i,2} contains 
%               a [36 x 300] matrix of oxyhemoglobin signals averaged 
%               across trials for subject i, left hemisphere.
% - HHb_right : cell array (28 x 2). Each cell HHb_right{i,2} contains 
%               a [36 x 300] matrix of deoxyhemoglobin signals averaged across
%               trials for subject i,right hemisphere.
% - HHb_left  : cell array (28 x 2). Each cell HHb_left{i,2} contains 
%               a [36 x 300] matrix of deoxyhemoglobin signals averaged across
%               trials for subject i, left hemisphere. 
%
% OUTPUT:
% - O2Hb_right_avg_subj: [36 x 300] matrix containing the grand average O2Hb 
%                        signals across subjects (right hemisphere).
% - O2Hb_left_avg_subj : [36 x 300] matrix containing the grand average O2Hb 
%                        signals across subjects (left hemisphere).
% - HHb_right_avg_subj : [36 x 300] matrix containing the grand average HHb 
%                        signals across subjects (right hemisphere).
% - HHb_left_avg_subj  : [36 x 300] matrix containing the grand average HHb 
%                        signals across subjects (left hemisphere).
%
O2Hb_right_avg_subj = zeros(36,300);
O2Hb_left_avg_subj = zeros(36,300);
HHb_right_avg_subj = zeros(36,300);
HHb_left_avg_subj = zeros(36,300);
for i=1:28
    O2Hb_right_avg_subj = O2Hb_right_avg_subj + O2Hb_right{i,2};
    O2Hb_left_avg_subj = O2Hb_left_avg_subj + O2Hb_left{i,2};
    HHb_right_avg_subj = HHb_right_avg_subj + HHb_right{i,2};
    HHb_left_avg_subj = HHb_left_avg_subj + HHb_left{i,2};
end
O2Hb_right_avg_subj = O2Hb_right_avg_subj/28;
O2Hb_left_avg_subj = O2Hb_left_avg_subj/28;
HHb_right_avg_subj = HHb_right_avg_subj/28;
HHb_left_avg_subj = HHb_left_avg_subj/28;

end