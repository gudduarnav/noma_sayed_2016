% Initialize the system


function para=para_init()
    para.c = physconst('lightspeed'); % m/s 
    para.f = 2.4e9; % Hz. frequency
    para.wave_len = para.c/para.f; % m. wavelength
    para.N = 4; % number of users
    para.r = [20, 15, 10, 5]; %m. (far to near user) distance from BS
    para.C = [1.5, 1.5, 1.3, 1.3]; % Throughput over OMA
    para.P = 10; % dBm. Total power budget
    para.P = db2pow(para.P)*1e-3; % W. power budget
    para.Bandwidth = 1e9; % Hz. Spectral Bandwidth
    para.sigma_sq = -174 + pow2db(para.Bandwidth); % dBm. Noise power
    para.sigma_sq = db2pow(para.sigma_sq) * 1e-3; % W. Noise power
end
