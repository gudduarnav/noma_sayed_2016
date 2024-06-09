

function [ber_h, ber_l] = ber_qpsk_noma_qos_pair(para, hsq, pk, data, id_h, id_l, P_total)
    ber_h = 0;
    ber_l = 0;
    
    % --- SNR ---
    % W
    snr_h = pk(id_h) / para.sigma_sq;
    if ~isempty(id_l)
        snr_l = pk(id_l) / para.sigma_sq;
    end 

    % db
    snr_h = pow2db(snr_h);
    if ~isempty(id_l)
        snr_l = pow2db(snr_l);
    end

    % --- Data symbols ---
    d_h = data.symbols(:, id_h);
    if ~isempty(id_l)
        d_l = data.symbols(:, id_l);
    end

    % --- Transmit symbols ---
    % offset pi/4 QPSK Gray coding
    txsymbols_h = pskmod(d_h, data.M, pi/4); 
    if ~isempty(id_l)
        txsymbols_l = pskmod(d_l, data.M, pi/4);
    end

    % Generate NOMA symbols
    if ~isempty(id_l)
        % weak signal is interferer for high priority user
        txsymbols_h = txsymbols_h + pk(id_l)/pk(id_h) * txsymbols_l; 
    end

    % Generate Rayleigh faded channel for both users
    rayleighChannel_h = (1/sqrt(2)) * (randn(data.numsymbols, 1) + 1j*randn(data.numsymbols, 1));
    if ~isempty(id_l)
        rayleighChannel_l = (1/sqrt(2)) * (randn(data.numsymbols, 1) + 1j*randn(data.numsymbols, 1));
    end

    % Multiply by the channel
    rayleighChannel_h = rayleighChannel_h * hsq(id_h);
    if ~isempty(id_l)
        rayleighChannel_l = rayleighChannel_l * hsq(id_l);
    end

    % superimpose channel on symbol
    rxSymbols_rayleigh_h = rayleighChannel_h .* txsymbols_h;
    if ~isempty(id_l)
        rxSymbols_rayleigh_l = rayleighChannel_l .* txsymbols_l;
    end

    % Add AWGN noise
    rxSymbols_awgn_h = awgn(rxSymbols_rayleigh_h, snr_h, 'measured');
    if ~isempty(id_l)
        rxSymbols_awgn_l = awgn(rxSymbols_rayleigh_l, snr_l, 'measured');
    end

    % Perform MMSE equilization
    H = diag(rayleighChannel_h); % channel matrix
    equilizedSymbols_h = H \ rxSymbols_awgn_h; % equilize
    
    if ~isempty(id_l)
        H = diag(rayleighChannel_l); % channel matrix
        equilizedSymbols_l = H \ rxSymbols_awgn_l; % equilize
    end

    % demodulation
    rxData_equilized_h = pskdemod(equilizedSymbols_h, data.M, pi/4);
    if ~isempty(id_l)
        rxData_equilized_l = pskdemod(equilizedSymbols_l, data.M, pi/4);
    end

    % calculate SER (Symbol Error Rate)
    ser_equilized_h = sum(d_h ~= rxData_equilized_h)/data.numsymbols;
    if ~isempty(id_l)
        ser_equilized_l = sum(d_l ~= rxData_equilized_l)/data.numsymbols;
    end

    % calcualte ber
    ber_h = ser_equilized_h;
    if ~isempty(id_l)
        ber_l = ser_equilized_l;
    end

end