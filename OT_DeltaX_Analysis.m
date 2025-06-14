function RESULT = OT_DeltaX_Analysis(fx_TEFVP)
%% RESULT is a table of:
% Timepoint, mean of pre-tran, mean of post-tran, ...
%            numb of pre-tran, numb of post-tran, ...
%            std  of pre-tran, std  of post-tran, ...
%            Voltage when the transition happen, ...
%            mean-force of pre-tran,  mean-f of pre-tran, ...
%            delta x i.e. dx
%
%%%031518 Version: Modification%%%%%%%%%%%%%%%%%%%%%%%%%
% Removed the "1 sec" Threadhold and changed to 21 ms
% Use the new and improve Plot_ReScale Function: Linear or Sigma
% Fixed the offset of detection location
%%%031618 Version: Modification%%%%%%%%%%%%%%%%%%%%%%%%%
% Fixed the issue with the short last voltage
%%%031618 Version: Modification%%%%%%%%%%%%%%%%%%%%%%%%%

%% Data Segmentation base on Voltage
input = fx_TEFVP;
Volt_Inx = find(logical(diff(input(:, 4))) == 1);
Volt_Inx = [0; Volt_Inx; length(input(:, 4))];

%% Alg. for Selecting the zero force offset
temp = sortrows([ unique(input(:,4)), hist(input(:,4), unique(input(:,4)))'], 2,'descend');
temp = sortrows([ unique(input(:,4)), hist(input(:,4), unique(input(:,4)))'], -2);

zero_F_volt = max(temp(1:2, 1));

offset = mean(input( input(:,4) == zero_F_volt,3));

figure;
plot(input(:,3)); hold on;
plot(zeros(length(input(:,3)),1)+offset,'r'); 
plot(zeros(length(input(:,3)),1)+offset+std(input( input(:,4) == zero_F_volt,3)),'r-');
plot(zeros(length(input(:,3)),1)+offset-std(input( input(:,4) == zero_F_volt,3)),'r-'); hold off;


hold off;


%%
test = [];
for I = 1:length(Volt_Inx)-1
    % clc
    % I/(length(Volt_Inx)-1)*100
    st = Volt_Inx(I  ) + 30 + 1;
    ed = Volt_Inx(I+1) - 30;
    
    if st > length(input(:,1))
        st = Volt_Inx(I  ) + 1;
        ed =  length(input(:,1));
    end
    
    if input(st,4) < 7.7 %select voltage for measuring deltaX
        ch = findchangepts(input(st:ed,2),'MaxNumChanges',1);
        if ~isempty(ch) &&  ch > 1 %
            mi = ch + st;
            test = [ test; mi ...
                mean(input(st:mi,2)) mean(input(mi:ed,2)) ...
                length(st:mi)      length(mi:ed)...
                std(input(st:mi,2))  std(input(mi:ed,2)) ...
                input(mi,4),  ...
                (mean(input(st:mi,3))-offset),...
                (mean(input(mi:ed,3))-offset) ];
            
        end
    end
end
% *input(st,5)
% *input(st,5)
%% Mid-Checking
% clc; close all;
% figure;
% plot(input(:,2)); hold on;
% plot(test(:,1), input(test(:,1),2),'o');
% plot(input(:,4)/(mean(input(:,4)))*3730);
% plot(test(:,1),(test(:,3)-test(:,2))*15+3500,'r.')

%% Ploting of the re-scaled data for Checking
test(isnan(test(:,1)), :) = [];
test(isnan(test(:,2)), :) = [];
figure;
plot(input(:,2)); hold on;
plot(test(:,1), input(test(:,1),2),'o','MarkerSize', 7);
plot(Plot_ReScale(input(:,2),-1*input(:,4), 'empt'));
xlabel('Time Points')

%% Filtering out false transition
test_2 = test;
temp = (test(:,3)-test(:,2));
test_2(temp < 5, :) = []; % Need to add the aditional force criteria
plot(test_2(:,1),input(test_2(:,1),2), 'r.', 'MarkerSize', 14);
dx = test_2(:,3)-test_2(:,2);
RESULT = [test_2, dx];