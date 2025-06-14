%% measurement of deltaX at constant force
function [dx_cf] =  dx_constantForce(fx_TEFVP)
% output dx_cf (time
%% separately extract the measured parameters; time, extension, force, and voltage
% input = fx_TEFVP;
tim = fx_TEFVP(:,1);
ext = fx_TEFVP(:,2);
f = fx_TEFVP(:,3);
vol = fx_TEFVP(:,4);

%segmentation of the data based on voltage cycle
int = findchangepts(vol,'Statistic','linear','MinThreshold',500);

% determine dx of shearing

esh = [];

for i = 1:length(int)
        ei = ext(int(i)-3500:int(i)-20);
    ti = tim(int(i)-3500:int(i)-20);
    fi = f(int(i)-3500:int(i)-20);
    vi = vol(int(i)-3500:int(i)-20);
    tefvi =  [ti ei fi vi];

figure; hold on
plot(ti,ei);
    
temp1 = vi == 6.4; % select voltage of the distance measuring force from voltage cycle from function OT_Qick_Process_FX_Plot_Cal
temp2 = vi == 6.35; % select voltage of the distance measuring force from voltage cycle from function OT_Qick_Process_FX_Plot_Cal
TEFVsh1 = tefvi(temp1,:);
TEFVsh2 = tefvi(temp2,:);
timsh1 = TEFVsh1(10:end-10,1);
extsh1 = TEFVsh1(10:end-10,2);
timsh2 = TEFVsh2(10:end-10,1);
extsh2 = TEFVsh2(10:end-10,2);

% plot the extension vs time graph
plot(timsh1,extsh1,'.r');
plot(timsh2,extsh2,'.r');
plot(mean(timsh1), mean(extsh1), '.b',"MarkerSize",10);
plot(mean(timsh2), mean(extsh2), '.b',"MarkerSize",10);
title(['x vs t ', num2str(i)]); % Set the title to include the figure number
esh = [esh; (mean(extsh2)-mean(extsh1))];
end
dx_cf = esh;
