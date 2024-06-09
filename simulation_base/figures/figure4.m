% Figure 4

% ---- reset ----
close all;
clear all;
clc;

% ---- Data Saving ----
list_SNR = [];
list_user_rate_oma = [];
list_user_rate_noma_csi = [];
list_user_sum_rate_oma = [];
list_user_sum_rate_noma_csi =[];

% ---- generate data for Acheivable rate vs SNR (dB) ------
counter = 0;
for SNR_db = 0: 1: 30
    counter = counter + 1;
    SNR = db2pow(SNR_db); 
    
    % --- initialize ---
    para = para_init();
    para.P = para.sigma_sq * SNR;
    para.N = 2; % 2 user scenario
    para.r = para.r(1:para.N); % keep only 2 users
    
    % --- generate channels ---
    hsq = generate_channels(para);

    % --- get scale factor ----
    scale = 500; % the receiver apply amplification

    % --- allocate power ----
    Pi_noma_csi = alloc_power_noma_csi(para, hsq)*scale; % NOMA CSI
    Pi_oma = alloc_power_oma(para, hsq)*scale; % OMA

    % --- calculate rate ----
    Ri_noma_csi = calc_rate_noma(para, hsq, Pi_noma_csi); % NOMA CSI
    Ri_oma = calc_rate_oma(para, hsq, Pi_oma); % OMA rate

    % --- save the data ---
    list_SNR(end+1) = SNR_db;
    list_user_rate_oma(:, end+1) = transpose(Ri_oma);
    list_user_rate_noma_csi(:, end+1)= transpose(Ri_noma_csi);
    list_user_sum_rate_oma(end+1)= sum(Ri_oma);
    list_user_sum_rate_noma_csi(end+1) = sum(Ri_noma_csi);
end


% --- Calculate the rate ratios ----
list_rate_ratio = list_user_rate_noma_csi./list_user_sum_rate_oma;
list_sum_rate_ratio = list_user_sum_rate_noma_csi ./ list_user_sum_rate_oma;

% ---- Plot the figure ----
f = figure('Name', 'Figure 4', 'NumberTitle', 'off');

plot(list_SNR, list_sum_rate_ratio, 'k-', 'linewidth', 2)
hold on
u1_ratio = list_rate_ratio(1, :);
u2_ratio = list_rate_ratio(2, :);
plot(list_SNR, u1_ratio, 'b-', 'LineWidth', 2);
plot(list_SNR, u2_ratio, 'r-', 'LineWidth', 2);


hold off
legend('Total Rate', 'User 1', 'User 2', 'Location', 'NorthWest');
grid on
xlabel('SNR (dB)')
ylabel('NOMA Rate/OMA Rate')

xlim([0, 30])
ylim([0, 3])


savefig(f, 'figures/figure4')
