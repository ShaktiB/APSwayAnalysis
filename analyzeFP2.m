% October 27, 2010

function [xCOPL,yCOPL, xCOPR, yCOPR, Fz_R, Fz_L] = analyzeFP(signals)
% This code converts voltage signals to COP, forces and moments from the AMTI Dual-split force plate(SN:0869) purchased in August 2010.
% The calculation formulas for forces and moments and calibration data can be found in the AMTI CD 

%The input for this code should be a matrix with 16 columns of voltage
%signals from the force plate, and each row should specify the next time point

%signals from the left force plate
dCz_L = signals(:,1);
dDz_L = signals(:,2);
dAz_L = signals(:,3);
dBz_L = signals(:,4);
dYAC_L = signals(:,5);
dXDC_L = signals(:,6);
dXAB_L = signals(:,7);
dYBD_L = signals(:,8);

%signals from the right force plate
dCz_R = signals(:,9);
dDz_R = signals(:,10);
dAz_R = signals(:,11);
dBz_R = signals(:,12);
dYAC_R = signals(:,13);
dXDC_R = signals(:,14);
dXAB_R = signals(:,15);
dYBD_R = signals(:,16);

%Equipment: SN:0869R (Oct 2010), SN:0869L (Oct 2010)
%physical properties
FPLength_R = 19.6;    %inches
FPWidth_R = 9.75;     %inches
FPLength_L = 19.6;    %inches
FPWidth_L = 9.75;     %inches
R_XOFFSET = 0.000000;   %inches
R_YOFFSET = 0.000000;   %inches
R_ZOFFSET = 0.0262939276;%in m  1.035194 in inches
L_XOFFSET = 0.000000;   %inches
L_YOFFSET = 0.000000;   %inches
L_ZOFFSET = 0.0267789406;%in m  1.054289 in inches

%calibration tables, units of pounds/volt for rows 1 to 3,
%inch-pounds/volt for rows 4 to 6
calibration_R = [-0.0910901	-0.0052768	-0.0112929	0.0327467	0.1106058	-3.4801176	3.4528551	0.1045774;
0.0264398	-0.0006254	-0.0792058	0.0171275	3.4984102	0.1162445	-0.1153339	3.3077332;
-20.3249567	-17.1265556	-17.6942522	-17.8489199	0.109119	-0.228462	0.1558659	0.0435381;
148.5147133	125.541895	-130.7402874	-131.1414232	0	0	0	0;
86.0059516	-74.7219569	75.8170853	-77.9555245	0	0	0	0;
-0.0721924	-0.0608319	-0.0628483	-0.0633977	29.1940433	-28.4319074	-28.2091779	-27.6028536;
];

calibration_L = [0.0707318	-0.0067798	-0.0115091	0.1176573	0.1326098	-3.3728843	3.3751271	0.1340176;
-0.0841558	0.0445572	-0.1283123	0.0844047	3.4401737	-0.0658231	0.0658668	3.4766961;
-17.5001877	-17.5401307	-17.5384281	-18.0200715	0.0561171	0.0696521	-0.0777595	0.0811379;
128.5049598	129.3560424	-129.0968087	-132.829279	0	0	0	0;
75.9760895	-74.9782113	76.1367828	-77.7362616	0	0	0	0;
-0.4840221	-0.4851268	-0.4850797	-0.4984011	27.229372	-27.6319668	-27.6503405	-27.5184507;
];

%convert from imperial to metric units
lbs_N = 4.45374;         %1 lbs = 0.454 kg;
inchlbs_Nm = 0.1129848; %1 Nm = 8.850748 inch-lbs;

%calculating Fx, Fy, Fz, Mx, My, Mz according to manual, unit for forces:N
%unit for moments: Nm
Fx_R = (dCz_R * calibration_R(1,1) + dDz_R * calibration_R(1,2) + dAz_R * calibration_R(1,3) + dBz_R * calibration_R(1,4) + dYAC_R * calibration_R(1,5) + dXDC_R * calibration_R(1,6) + dXAB_R * calibration_R(1,7) + dYBD_R * calibration_R(1,8)) * lbs_N; %in N
Fy_R = (dCz_R * calibration_R(2,1) + dDz_R * calibration_R(2,2) + dAz_R * calibration_R(2,3) + dBz_R * calibration_R(2,4) + dYAC_R * calibration_R(2,5) + dXDC_R * calibration_R(2,6) + dXAB_R * calibration_R(2,7) + dYBD_R * calibration_R(2,8)) * lbs_N; %in N
Fz_R = (dCz_R * calibration_R(3,1) + dDz_R * calibration_R(3,2) + dAz_R * calibration_R(3,3) + dBz_R * calibration_R(3,4) + dYAC_R * calibration_R(3,5) + dXDC_R * calibration_R(3,6) + dXAB_R * calibration_R(3,7) + dYBD_R * calibration_R(3,8)) * lbs_N; %in N
Mx_R = (dCz_R * calibration_R(4,1) + dDz_R * calibration_R(4,2) + dAz_R * calibration_R(4,3) + dBz_R * calibration_R(4,4) + dYAC_R * calibration_R(4,5) + dXDC_R * calibration_R(4,6) + dXAB_R * calibration_R(4,7) + dYBD_R * calibration_R(4,8)) * inchlbs_Nm; %in Nm
My_R = (dCz_R * calibration_R(5,1) + dDz_R * calibration_R(5,2) + dAz_R * calibration_R(5,3) + dBz_R * calibration_R(5,4) + dYAC_R * calibration_R(5,5) + dXDC_R * calibration_R(5,6) + dXAB_R * calibration_R(5,7) + dYBD_R * calibration_R(5,8)) * inchlbs_Nm; %in Nm
Mz_R = (dCz_R * calibration_R(6,1) + dDz_R * calibration_R(6,2) + dAz_R * calibration_R(6,3) + dBz_R * calibration_R(6,4) + dYAC_R * calibration_R(6,5) + dXDC_R * calibration_R(6,6) + dXAB_R * calibration_R(6,7) + dYBD_R * calibration_R(6,8)) * inchlbs_Nm; %in Nm

Fx_L = (dCz_L * calibration_L(1,1) + dDz_L * calibration_L(1,2) + dAz_L * calibration_L(1,3) + dBz_L * calibration_L(1,4) + dYAC_L * calibration_L(1,5) + dXDC_L * calibration_L(1,6) + dXAB_L * calibration_L(1,7) + dYBD_L * calibration_L(1,8)) * lbs_N; %in N
Fy_L = (dCz_L * calibration_L(2,1) + dDz_L * calibration_L(2,2) + dAz_L * calibration_L(2,3) + dBz_L * calibration_L(2,4) + dYAC_L * calibration_L(2,5) + dXDC_L * calibration_L(2,6) + dXAB_L * calibration_L(2,7) + dYBD_L * calibration_L(2,8)) * lbs_N; %in N
Fz_L = (dCz_L * calibration_L(3,1) + dDz_L * calibration_L(3,2) + dAz_L * calibration_L(3,3) + dBz_L * calibration_L(3,4) + dYAC_L * calibration_L(3,5) + dXDC_L * calibration_L(3,6) + dXAB_L * calibration_L(3,7) + dYBD_L * calibration_L(3,8)) * lbs_N; %in N
Mx_L = (dCz_L * calibration_L(4,1) + dDz_L * calibration_L(4,2) + dAz_L * calibration_L(4,3) + dBz_L * calibration_L(4,4) + dYAC_L * calibration_L(4,5) + dXDC_L * calibration_L(4,6) + dXAB_L * calibration_L(4,7) + dYBD_L * calibration_L(4,8)) * inchlbs_Nm; %in Nm
My_L = (dCz_L * calibration_L(5,1) + dDz_L * calibration_L(5,2) + dAz_L * calibration_L(5,3) + dBz_L * calibration_L(5,4) + dYAC_L * calibration_L(5,5) + dXDC_L * calibration_L(5,6) + dXAB_L * calibration_L(5,7) + dYBD_L * calibration_L(5,8)) * inchlbs_Nm; %in Nm
Mz_L = (dCz_L * calibration_L(6,1) + dDz_L * calibration_L(6,2) + dAz_L * calibration_L(6,3) + dBz_L * calibration_L(6,4) + dYAC_L * calibration_L(6,5) + dXDC_L * calibration_L(6,6) + dXAB_L * calibration_L(6,7) + dYBD_L * calibration_L(6,8)) * inchlbs_Nm; %in Nm

%calculating COP for individual platforms, unit: cm
xCOPL = (My_L + (L_ZOFFSET * Fx_L))./Fz_L * 100;     %this is different from the manual (i.e. did not multiply by -1)
yCOPL = (Mx_L - (L_ZOFFSET * Fy_L))./Fz_L * 100;
xCOPR = (My_R + (R_ZOFFSET * Fx_R))./Fz_R * 100;    %this is different from the manual (i.e. did not multiply by -1)
yCOPR = (Mx_R - (R_ZOFFSET * Fy_R))./Fz_R * 100;

