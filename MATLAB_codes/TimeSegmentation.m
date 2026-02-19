function data = TimeSegmentation(data_provv,time)

% Function performing time segmentation and baseline correction of signals
%
% DESCRIPTION:
%   Segments continuous signals into fixed-length epochs aligned to 
%   experimental event onsets, and applies baseline correction. Each epoch 
%   consists of a pre-stimulus baseline period (3 s) followed by a
%   post-onset window (27 s), for a total of 30 s per trial.The baseline
%   correction is performed by subtracting the mean signal value computed 
%   over the baseline interval.
%
% INPUT:
% - data_provv: cell array (28 x 3). For each subject and session it contains 
%               a [36 x Nsamples] matrix with continuous signals. 
%          
% - time: cell array (28 x 1). For each subject r, time{r} is a [3 x Nevents] 
%         matrix containing the event onset times for the three sessions. 
%         Each row c corresponds to one session and the value
%         in that row are the onset times (in milliseconds).
%
% OUTPUT:
% - data: cell array (28 x 1). For each subject r, data{r,1} is a 3-D matrix 
%         of size [36 x 300 x Nevents].Trials from the three sessions 
%         are concatenated along the third dimension.

global fs % sampling frequency (10 Hz)

data = cell(28,1);
baseline_sec = 3;          
post_sec = 27; 
epochLen = (baseline_sec + post_sec)*fs; 
for r = 1:size(data_provv,1)
    sig_proc = zeros(36,300,60); % Assuming a preprocessing function exists
    mat = time{r};
    for c = 1:size(data_provv,2)
        sig = data_provv{r,c};
        time_sig = mat(c,:);
        for i = 1: length(time_sig)
            istante = time_sig(i);
            center = round(istante/1000 * fs);
            start = center - baseline_sec*fs;
            stop = center + post_sec*fs-1;
       
            sig_proc(:,:,i+((c-1)*20))= sig(:,start:stop);
        end
    end
    data{r,1}= sig_proc;

end

for j = 1:28
    for i=1:36
    % Subtract from each NIRS signal the corresponding mean value in
    % baseline
        mean_baseline = mean(data{j,1}(i,1:30,:));
        data{j,1}(i,:,:) = data{j,1}(i,:,:) - mean_baseline;
    end
end


end