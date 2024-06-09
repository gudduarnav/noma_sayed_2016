% Figure 6

% ---- reset ----
close all;
clear all;
clc;

% ---- Data Saving ----
list_SNR = [];
list_ber_noma = [];
list_ber_oma = [];

% ---- generate data for Acheivable rate vs SNR (dB) ------
counter = 0;
for SNR_db = 0: 1: 30
    counter = counter + 1;
    SNR = db2pow(SNR_db); 
    
    % --- initialize ---
    para = para_init();
    para.P = para.sigma_sq * SNR;
    para.N = 4; % 2 user scenario
    para.r = para.r(1:para.N); % keep only 2 users
    
    % --- generate channels ---
    hsq = generate_channels(para);

    % --- get scale factor ----
    scale = 1; % the receiver apply amplification

    % --- allocate power ----
    Pi_noma_csi = alloc_power_noma_csi(para, hsq)*scale; % NOMA CSI
    Pi_oma = alloc_power_oma(para, hsq)*scale; % OMA
    
    % --- Symbol generators ---
    numsymbols = 10000;
    data = generate_data(para, numsymbols);

    % --- OMA ---
    ue_ber_oma = ber_qpsk_oma(para, hsq, Pi_oma, data);

    % --- NOMA ---
    ue_ber_noma = ber_qpsk_noma(para, hsq, Pi_noma_csi, data);
 
    % --- save the data ---
    list_SNR(end+1) = SNR_db;
    list_ber_oma(:, end+1) = ue_ber_oma;
    list_ber_noma(:, end+1) = ue_ber_noma;
end

% ---- plot the figure ---
f = figure('Name', 'Figure 6', 'NumberTitle', 'off');

semilogy(list_SNR, list_ber_oma(1,:), 'b-', 'linewidth', 2)

hold on
semilogy(list_SNR, list_ber_oma(2,:), 'r-', 'linewidth', 2)
semilogy(list_SNR, list_ber_oma(3,:), 'g-', 'LineWidth', 2)
semilogy(list_SNR, list_ber_oma(4,:), 'k-', 'LineWidth', 2)

semilogy(list_SNR, list_ber_noma(1, :), 'b-.', 'LineWidth',2)
semilogy(list_SNR, list_ber_noma(2, :), 'r-.', 'LineWidth', 2)
semilogy(list_SNR, list_ber_noma(3, :), 'g-.', 'LineWidth', 2)
semilogy(list_SNR, list_ber_noma(4, :), 'k-.', 'LineWidth', 2)
hold off

legend('User 1 OMA', 'User 2 OMA', 'User 3 OMA', 'User 4 OMA', 'User 1 NOMA', 'User 2 NOMA', 'User 3 NOMA', 'User 4 NOMA', 'Location', 'SouthWest');
grid on
xlabel('SNR (dB)')
ylabel('BER')
xlim([0, 30])
ylim([1e-3, 1])

savefig(f, 'figures/figure6')
