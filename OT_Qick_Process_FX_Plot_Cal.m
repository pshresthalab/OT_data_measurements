function [fx_TEFVP] = OT_Qick_Process_FX_Plot_Cal(filedata, fileVoltage, calfile1, ~)
%% Process the raw OT data.
% Output fx_TEFVP (Time, Extension, Force, Voltage, Power) 
% Example: 
% OT_Qick_Process_FX_Plot_Cal('bead3forcejump2.dat','bead3forcejump2_Voltage.dat', 'bead3cal.dat');

%% Load data

[k1, ~] = PSD_Calibration_OT(calfile1); 
x = dlmread(filedata);
x = sortrows(x,1); % issue with save table isn't increasing in time
d = dlmread(fileVoltage);
PoW = d(1:2:end);
VoT = d(2:2:end); 

%% Plot Raw Data
figure;
subplot(3,1,1); plot(x(:,1), x(:,2:5)); ylabel('Tracks (nm)') 
subplot(3,1,2); plot(x(:,1), VoT     ); ylabel('Piezo Voltage (V)')
subplot(3,1,3); plot(x(:,1), PoW     ); ylabel('Laser Power (mW)'); 
                                        xlabel('Time (s)')

%% Compute Extension & Force the Filtering out lost track
% range = 1.1760e3:1.3440e3;
% q = (x(range,2)+x(range,4))/2;
TiM =  x(:,1);
ExT = (  x(:,3) + x(:,5) - x(:,2) - x(:,4)  )/2;
ExT = ExT - 2850;
FoR = (  x(:,2) + x(:,4)) / 2;
FoR = FoR*k1*mean(PoW);
% VoT = VoT';
% force_offset = mean((q).*PoW (range,1) .* avg_k);


%%%

figure;
subplot(3,1,1); plot(TiM, ExT); ylabel('Extension (nm)');
subplot(3,1,2); plot(TiM, FoR); ylabel('Force (~)');
subplot(3,1,3); plot(TiM, VoT); ylabel('Votage (~)');
                                xlabel('Time (s)');  
% Plot FX cuves  

figure;
colormap(jet(256))
color_line(ExT, FoR, TiM);
xlabel('Extension (nm)')
ylabel('Force (~)')

%%%
%%%!!!
Temp = 10;
% % % %%%!!!
% % % 
LoS = find(ExT> mean(ExT) + Temp*std(ExT) | mean(ExT) - Temp*std(ExT) > ExT);
TiM(LoS) = []; ExT(LoS) = []; FoR(LoS) = []; VoT(LoS) = []; PoW(LoS) = [];
LoS = find(VoT > 10);
TiM(LoS) = []; ExT(LoS) = []; FoR(LoS) = []; VoT(LoS) = []; PoW(LoS) = [];
% Temp = ExT>0;
% ExT = ExT(Temp);

%% Force offset correction
EFV = [ExT FoR VoT];
force_offset = EFV(EFV(:,3)==max(EFV(:,3)),:);
force_0=force_offset(:,2);
FoR = FoR- mean(force_0);

%% Checking the time trace
figure;
subplot(3,1,1); plot(TiM, ExT); ylabel('Extension (nm)');
subplot(3,1,2); plot(TiM, FoR); ylabel('Force (~)');
subplot(3,1,3); plot(TiM, VoT); ylabel('Votage (~)');
                                xlabel('Time (s)'); 
                                
%% Smoothing extension trace
ExT_smooth = smooth(ExT,30);
FoR_smooth = smooth(FoR,30);
figure;
plot(TiM, ExT_smooth); ylabel('Extension (nm)');xlabel('Time (s)');
figure;
plot(TiM, FoR_smooth); ylabel('Force (~)');xlabel('Time (s)'); 

% FoR = FoR*956.6*avg_k;
figure;
colormap(jet(256))
color_line(ExT_smooth, FoR_smooth,TiM);
xlabel('Extension (nm)')
ylabel('Force (pN)')



%% Process Data (TEFVP) Time, Extension, Force, Voltage, Power
% For some reason.... VoT and Pow can be 1 x m instead of m x 1
% This conver 1 x m to m x 1:
size_VoT = size(VoT); 
if size_VoT(1) < size_VoT(2)
    VoT = VoT';
end

size_PoW = size(PoW); 
if size_PoW(1) < size_PoW(2)
    PoW = PoW';
end
%

fx_TEFVP = [TiM, ExT, FoR, VoT, PoW]; 