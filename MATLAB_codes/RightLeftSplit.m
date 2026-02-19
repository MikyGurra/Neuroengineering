function [data_left, data_right] = RightLeftSplit(data, label)

% Function splitting signal epochs into "left-hand" and "right-hand" classes
%
% DESCRIPTION:
%   This function takes as input a cell array containing signal epochs and 
%   a cell array containing a label marker matrix indicating whether each 
%   epoch corresponds to a LMI or RMI task, and separate the epochs into two 
%   groups based on these task labels.
%
% INPUT:
% - data : cell array (n_subj x 1) of signal epochs.
%          Each cell is a numeric array of epochs with size 
%          [n_channels x n_samples x n_trials].

%
% - label : cell array (n_subj x 1). Each cell contains a marker matrix of 
%           size [2 x n_trials], where:
%           label{s}(1,i) = 1 if trial i is LMI (left-hand MI), 0 otherwise
%           label{s}(2,i) = 1 if trial i is RMI (right-hand MI), 0 otherwise
%
% OUTPUT:
% - data_left  : cell array (n_subj x 1). Each cell contains the epochs assigned
%               to the LMI class, a 3-D array [n_channels x n_samples x n_trialsLMI].
% - data_right  : cell array (n_subj x 1). Each cell contains the epochs assigned
%               to the RMI class, a 3-D array [n_channels x n_samples x n_trialsRMI].

% NOTES:
% - In this implementation, n_channels, n_samples and the maximum number 
%   of trials per class are fixed by preallocation (36 x 300 x 30), using 
%   information about this specific dataset. If a subject has fewer than 30 
%   trials in a class, the remaining epochs are left as zeros.


n_trials = size(data{1,1},3);
n_subj = size(data,1);
for s = 1:n_subj
    task_left = zeros(36,300,30);
    task_right = zeros(36,300,30);
    row_left = 1;
    row_right = 1; 
    label_subj = label{s};
    data_subj = data{s};
    for i = 1:n_trials
    % Extract task markers
        label_left  = label_subj(1, :);   % Row 1 → LEFT-hand task markers
        if label_left(i)==1 
            task_left(:,:,row_left) = data_subj(:,:,i);
            row_left = row_left +1; 
        else 
            task_right(:,:,row_right) = data_subj(:,:,i);
            row_right = row_right +1;
        end 
        
    data_left{s,1} = task_left;
    data_right{s,1} = task_right; 
        
    end 
end 

end 
