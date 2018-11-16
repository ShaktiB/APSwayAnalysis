clear all
close all

%% Loading data

load('sway_data1');

fs=2000;

% analyze slow and fast data seperately

%% Force plate Analysis

% you should obtain the COPnet from Winter et al. 2003 paper

% analyzeFP function: "Given" (do not edit): converst raw forceplate data
% INPUT = 16 channels of raw forceplate data;
% OUTPUT: xCOPL, yCOPL, xCOPR, yCOPR, Rv_R, Rv_L
% Note: Rv_R and Rv_L are vertical forces of right and left forceplate 
% Repeat for esEO_fp

[xCOPL, yCOPL, xCOPR, yCOPR, Rv_R, Rv_L] = analyzeFP2(fp_fast);
[xCOPL2, yCOPL2, xCOPR2, yCOPR2, Rv_R2, Rv_L2] = analyzeFP2(fp_slow);

% Calcualte the COPnet
% 1st: Define the global center of pressure coodinate & use these to compute COPnet
% Shift X-coordinates to the middle of the split force plate by +/- 12.5825cm

xCOPLnew = xCOPL - 12.5825;
xCOPRnew = xCOPR + 12.5825;

xCOPLnew2 = xCOPL2 - 12.5825;
xCOPRnew2 = xCOPR2 + 12.5825;

% Calculate COP for overall system using Winter et al., 2003 [1]: 

%xCOPfast = xCOPLnew.*(Rv_L./(Rv_L +Rv_R)) + xCOPRnew.*(Rv_R./(rV_L +Rv_R)); %ML direction 
yCOPfast = yCOPL.*(Rv_L./(Rv_L +Rv_R)) + yCOPR.*(Rv_R./(Rv_L +Rv_R)); % AP direction 

%xCOPslow = xCOPLnew2.*(Rv_L2./(Rv_L2 +Rv_R2)) + xCOPRnew2.*(Rv_R2./(rV_L2 +Rv_R2)); % ML direction 
yCOPslow = yCOPL2.*(Rv_L2./(Rv_L2 +Rv_R2)) + yCOPR2.*(Rv_R2./(Rv_L2 +Rv_R2)); % AP direction 


%% Filter all data

% Low-pass filter: Butterworth, fc=10Hz
fc = 10;
Wn = fc/(fs/2);
N = 4; % Order of the filter 

% [rows, cols] = size(xCOP);
 
[B,A] = butter(N,Wn); % B = numerator and A = denominator

% Vertical forces of left and right force-place filtered
Rv_Rfilt = filtfilt(B,A,Rv_R); 
Fz_Lfilt = filtfilt(B,A,Rv_L);

Rv_Rfilt2 = filtfilt(B,A,Rv_R2); 
Fz_Lfilt2 = filtfilt(B,A,Rv_L2);

% COPnet filtered
%xCOPfiltfast = filtfilt(B,A,xCOPfast); % xCOP filtered signal 
yCOPfiltfast = filtfilt(B,A,yCOPfast); % yCOP filtered signal

%xCOPfiltslow = filtfilt(B,A,xCOPslow); % xCOP filtered signal 
yCOPfiltslow = filtfilt(B,A,yCOPslow); % yCOP fixCOPnet vs yCOPnetltered signal

%% Plotting 

t_fast = transpose([1:length(yCOPfiltfast)]/fs);
t_slow = transpose([1:length(yCOPfiltslow)]/fs);

figure;
plot(t_fast,yCOPfiltfast);
title('COPnet: AP Direction (fast)');
xlabel('time (s)');
ylabel('A/P');
% saveas(gcf,'COPnetAPfast.jpg')

figure;
plot(t_slow,yCOPfiltslow);
title('COPnet: AP Direction (slow)');
xlabel('time (s)');
ylabel('A/P');
% saveas(gcf,'COPnetAPslow.jpg')
