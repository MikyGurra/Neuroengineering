function XX_filt = BandpassFilter(XX,fL,fH,fs)

% Function filtering fNIRS signals with a bandpass (high-pass + low-pass) filter
%
% DESCRIPTION:
%   Applies a zero-phase bandpass filter to fNIRS signals stored in a cell array.
%   The bandpass is implemented as a cascade of a Chebyshev Type II high-pass
%   filter (to remove baseline drifts) followed by a Chebyshev Type II low-pass
%   filter (to remove high-frequency noise). Filtering is performed with filtfilt
%   to avoid phase distortion.
%
% INPUT:
% - XX: cell array (n_subj x n_sessions). Each cell XX{r,c} is a numeric matrix
%       [n_channels x n_samples] containing one session signal for that
%       subject. 
% - fL: low cutoff frequency of the bandpass [Hz] (high-pass cutoff).
% - fH: high cutoff frequency of the bandpass [Hz] (low-pass cutoff).
% - fs: sampling frequency [Hz].
%
% OUTPUT:
% - XX_filt: cell array with the same size as XX. Each cell XX_filt{r,c} is
%            the filtered version of XX{r,c}, with size [n_channels x n_samples].

f2=fL;
f1=.75*fL;
Wp=2*f2/fs;
Ws=2*f1/fs;
Rp=1;
Rs=20;
[n,Ws] = cheb2ord(Wp,Ws,Rp,Rs);
[BH,AH] = cheby2(n,Rs,Ws,'high');
f2=fH;f1=1.1*fH;Wp=2*f2/fs;Ws=2*f1/fs;Rp=1;Rs=20;[n,Ws] = cheb2ord(Wp,Ws,Rp,Rs);
[BL,AL] = cheby2(n,Rs,Ws);

XX_filt = cell(size(XX));
% Application of the filter for each cell
for r = 1:size(XX,1)
    for c = 1:size(XX,2)     
        XX_filt{r,c} = filtfilt(BH, AH,XX{r,c}')';  % [signals x sample]
        XX_filt{r,c} = filtfilt(BL,AL,XX_filt{r,c}')';

    end
end

end