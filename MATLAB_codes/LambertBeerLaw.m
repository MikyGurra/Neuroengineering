function [HHb_provv, O2Hb_provv] = LambertBeerLaw(data)

% Function applying the modified Lambert–Beer Law to raw fNIRS intensity data
%
% DESCRIPTION:
% This function converts raw fNIRS light intensity signals measured at two
% wavelengths into concentration changes of HHb and O2Hb. For each subject 
% and each recording block (x1, x2, x3), the signal
% is split into wavelength-specific channels (rows 1:36 = lambda1, rows
% 37:72 = lambda2), normalized by a baseline mean intensity (I0), converted
% to absorbance changes (DeltaA), and mapped to chromophore concentration
% changes using the modified Lambert–Beer law.
%
% INPUT:
% - data: struct containing the raw NIRS data with one field per subject (data.Sk).
%         Each subject contains x1, x2, x3 (raw intensity). After transposition, 
%         each block is treated as [72 x n_samples], with rows 1:36 = lambda1 
%         and 37:72 = lambda2.
%
% OUTPUT:
%- HHb_provv: cell array (n_subj x 3). Each cell HHb_provv{s,n}, a 
%             numeric matrix [36 x n_samples], contains the HHb 
%             concentration-change signal for subject s and session n (n=1:3).
% 
% - O2Hb_provv: cell array (n_subj x 3). Each cell O2Hb_provv{s,n},[36 x n_samples], 
%               contains the O2Hb concentration-change signal for subject s 
%               and session n (n=1:3).

global alphaHHb
global alphaO2Hb
global B 
global d

alpha_HHb_lambda1 = alphaHHb(1);
alpha_HHb_lambda2 = alphaHHb(2);
alpha_O2Hb_lambda1 = alphaO2Hb(1);
alpha_O2Hb_lambda2 = alphaO2Hb(2);
B1 = B(1);
B2 = B(2);
HHb_provv =cell(28,3);
O2Hb_provv = cell(28,3);

% Compute concentration values
for i = 1: numel(fieldnames(data))+1 
    if i == 13                      %when subject is equal to 13 skip to the next subject
        continue                   
    end
    campo = sprintf('S%d',i);
    data_subj = data.(campo);
    % Compute the mean on the first 60s of the first 20 trials
    signal = sprintf('x1');
    I = data_subj.(signal)';
    I_lambda1b = I(1:36,:);
    I_lambda2b = I(37:72,:);
    I0_lambda1 = mean(I_lambda1b(:,1:600),2);
    I0_lambda2 = mean(I_lambda2b(:,1:600),2);
    for n = 1:3
        frac_lambda1 = [];
        frac_lambda2 = [];
        signal = sprintf('x%d',n);
        I = data_subj.(signal)';
        I_lambda1 = I(1:36,:);
        I_lambda2 = I(37:72,:);
        for m = 1: size(I_lambda1,1)
            frac_lambda1(m,:) = I_lambda1(m,:)./I0_lambda1(m);
            frac_lambda2(m,:) = I_lambda2(m,:)./I0_lambda2(m);
        end 
        % OD Computation
        DeltaA_lambda1 = real(log10(1./frac_lambda1));
        DeltaA_lambda2 = real(log10(1./frac_lambda2));
        %common denominator
        den = alpha_O2Hb_lambda1 .* alpha_HHb_lambda2 - alpha_O2Hb_lambda2 .* alpha_HHb_lambda1;

        % DeltaC = Delta_c * d * 10  [mM*mm]
        O2Hb_signal = 10*(alpha_HHb_lambda2 .* (DeltaA_lambda1 ./ B1) - alpha_HHb_lambda1 .* (DeltaA_lambda2 ./ B2)) ./ den;
        HHb_signal = 10*(alpha_O2Hb_lambda1 .* (DeltaA_lambda2 ./ B2) - alpha_O2Hb_lambda2 .* (DeltaA_lambda1 ./ B1)) ./ den;
        HHb_provv{i,n} = HHb_signal; 
        O2Hb_provv{i,n} = O2Hb_signal;
    end
end
HHb_provv(13,:) = [];   % remove line 13
O2Hb_provv(13,:) = [];  % remove line 13
end


