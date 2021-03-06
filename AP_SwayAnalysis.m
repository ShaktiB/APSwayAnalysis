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

%% EMG Analysis
% the "evnelope" of the EMG signals.
% Analyze both Sol. and TA muscles.

gain = 1000; % for "sway_data"; change G to match the gain from your experiment

% Convert units - express EMG in miliVolts (mV) 
solFast = (sol_fast*1000)/gain;
solSlow = (sol_slow*1000)/gain;

taFast = (ta_fast*1000)/gain;
taSLow = (ta_slow*1000)/gain;

% Define time
dlenFast = length(solFast);
tFast = [1:dlenFast]/fs;

dlenSlow = length(solSlow);
tSlow = [1:dlenSlow]/fs;

%% EMG Rectification 

rect_solFast = abs(solFast);
rect_solSlow = abs(solSlow);

rect_taFast = abs(taFast);
rect_taSlow = abs(taSlow);

%% Envelopping 
%Define Envelope filter - Low-pass filter, Butterworth, 4th order, fc=2.5Hz

fc2 = 2.5;
Wn2 = fc2/(fs/2);
 
[B2,A2] = butter(N,Wn2); % B2 = numerator and A2 = denominator 

% Filtering soleus muscle data 
filtSolFast = filtfilt(B2,A2,rect_solFast); % sol Fast 
filtSolSlow = filtfilt(B2,A2,rect_solSlow); % sol Slow
% Filtering tibiablis anterior muscle data
filtTaFast = filtfilt(B2,A2,rect_taFast); % sol Fast 
filtTaSlow = filtfilt(B2,A2,rect_taSlow); % sol Slow

%% Plotting 

% COPnet Slow/Fast & Filtered EMG slow/fast -- TA/Sol Together 
figure;
subplot(2,1,1);
plot(tFast,filtSolFast);
hold on 
plot(tFast,filtTaFast);
hold off
legend('Sol Fast','TA Fast');
xlabel('Time (s)');
ylabel('EMG: Sol & TA');
title('Analysis of AP Sway with Muscle Activation','FontSize', 18)
subplot(2,1,2);
plot(tFast,yCOPfiltfast);
xlabel('Time (s)');
ylabel('COPnet: AP Direction');


figure;
subplot(2,1,1);
plot(tSlow,filtSolSlow);
hold on 
plot(tSlow,filtTaSlow);
hold off
legend('Sol Slow','TA Slow');
xlabel('Time (s)');
ylabel('EMG: Sol & TA');
title('Analysis of AP Sway with Muscle Activation','FontSize', 18)
subplot(2,1,2);
plot(tSlow,yCOPfiltslow);
xlabel('Time (s)');
ylabel('COPnet: AP Direction');

% Soleus EMG fast– Raw, Rectified and Filtered
% Soleus EMG slow– Raw, Rectified and Filtered

figure; % Sol Fast
subplot(3,1,1);
plot(tFast, solFast);
title('Raw EMG: Soleus Muscle (Fast)');
xlabel('TIme (s)');
ylabel('mV');

subplot(3,1,2);
plot(tFast, rect_solFast);
title('Rectified EMG: Soleus Muscle (Fast)');
xlabel('TIme (s)');
ylabel('mV');

subplot(3,1,3);
plot(tFast, filtSolFast);
title('Filtered EMG: Soleus Muscle (Fast)');
xlabel('TIme (s)');
ylabel('mV');

figure; % Sol Slow
subplot(3,1,1);
plot(tSlow, solSlow);
title('Raw EMG: Soleus Muscle (Slow)');
xlabel('TIme (s)');
ylabel('mV');

subplot(3,1,2);
plot(tSlow, rect_solSlow);
title('Rectified EMG: Soleus Muscle (Slow)');
xlabel('TIme (s)');
ylabel('mV');

subplot(3,1,3);
plot(tSlow, filtSolSlow);
title('Filtered EMG: Soleus Muscle (Slow)');
xlabel('TIme (s)');
ylabel('mV');

% TA EMG fast– Raw, Rectified and Filtered
% TA EMG slow– Raw, Rectified and Filtered

figure; % TA Fast 
subplot(3,1,1);
plot(tFast, taFast);
title('Raw EMG: TA Muscle (Fast)');
xlabel('TIme (s)');
ylabel('mV');

subplot(3,1,2);
plot(tFast, rect_taFast);
title('Rectified EMG: TA Muscle (Fast)');
xlabel('TIme (s)');
ylabel('mV');

subplot(3,1,3);
plot(tFast, filtTaFast);
title('Filtered EMG: TA Muscle (Fast)');
xlabel('TIme (s)');
ylabel('mV');

figure; % TA Slow
subplot(3,1,1);
plot(tSlow, taSlow);
title('Raw EMG: TA Muscle (Slow)');
xlabel('TIme (s)');
ylabel('mV');

subplot(3,1,2);
plot(tSlow, rect_taSlow);
title('Rectified EMG: TA Muscle (Slow)');
xlabel('TIme (s)');
ylabel('mV');

subplot(3,1,3);
plot(tSlow, filtTaSlow);
title('Filtered EMG: TA Muscle (Slow)');
xlabel('TIme (s)');
ylabel('mV');




