% Figure 7

% ---- reset ----
close all;
clear all;
clc;

% ---- Data Saving ----
list_SNR = [];
list_user_rate_oma = [];
list_user_rate_noma_qos = [];
list_user_sum_rate_oma = [];
list_user_sum_rate_noma_qos =[];

% ---- generate data for Acheivable rate vs SNR (dB) ------
counter = 0;
for SNR_db = 0: 1: 30
    counter = counter + 1;
    SNR = db2pow(SNR_db); 
    
    % --- initialize ---
    para = para_init();
    para.P = para.sigma_sq * SNR;
    para.N = 4; % 4 user scenario
    para.r = para.r(1:para.N); % keep only 2 users
    
    % --- generate channels ---
    hsq = generate_channels(para);

    % --- get scale factor ----
    scale = 1500; % the receiver apply amplification

    % --- allocate power ----
    [Pi_noma_qos, user_pair_id]= alloc_power_noma_qos(para, hsq); % NOMA QoS
    Pi_noma_qos = Pi_noma_qos * scale;

    Pi_oma = alloc_power_oma(para, hsq)*scale; % OMA

    % --- calculate rate ----
    Ri_noma_qos = calc_rate_noma_qos(para, hsq, Pi_noma_qos, user_pair_id); % NOMA QoS
    Ri_oma = calc_rate_oma(para, hsq, Pi_oma); % OMA rate

    % --- save the data ---
    list_SNR(end+1) = SNR_db;
    list_user_rate_oma(:, end+1) = transpose(Ri_oma);
    list_user_rate_noma_qos(:, end+1)= transpose(Ri_noma_qos);
    list_user_sum_rate_oma(end+1)= sum(Ri_oma);
    list_user_sum_rate_noma_qos(end+1) = sum(Ri_noma_qos);
end


% ---- Plot the figure ----
f = figure('Name', 'Figure 7', 'NumberTitle', 'off');

plot(list_SNR, list_user_sum_rate_noma_qos, 'b-', 'linewidth', 2)
hold on
plot(list_SNR, list_user_sum_rate_oma, 'r-', 'linewidth', 2)
1
u1_noma = list_user_rate_noma_qos(1, :);
u2_noma = list_user_rate_noma_qos(2, :);
u3_noma = list_user_rate_noma_qos(3, :);
u4_noma = list_user_rate_noma_qos(4, :);

plot(list_SNR, u1_noma, 'b--', 'LineWidth', 2);
plot(list_SNR, u2_noma, 'r--', 'LineWidth', 2);
plot(list_SNR, u3_noma, 'g--', 'LineWidth', 2);
plot(list_SNR, u4_noma, 'k--', 'LineWidth', 2);

u1_oma = list_user_rate_oma(1, :);
u2_oma = list_user_rate_oma(2, :);
u3_oma = list_user_rate_oma(3, :);
u4_oma = list_user_rate_oma(4, :);

plot(list_SNR, u1_oma, 'b-.', 'LineWidth', 2);
plot(list_SNR, u2_oma, 'r-.', 'LineWidth', 2);
plot(list_SNR, u3_oma, 'g-.', 'LineWidth', 2);
plot(list_SNR, u4_oma, 'k-.', 'LineWidth', 2);

hold off
legend('NOMA Sum Rate', 'OMA Sum Rate', 'User 1 NOMA', 'User 2 NOMA', 'User 3 NOMA', 'User 4 NOMA', 'User 1 OMA', 'User 2 OMA', 'User 3 OMA', 'User 4 OMA', 'Location', 'NorthWest');
grid on
xlabel('SNR (dB)')
ylabel('Achievable Throughput (bps/Hz)')
xlim([0, 30])
ylim([0, 10])


savefig(f, 'figures/figure7');
