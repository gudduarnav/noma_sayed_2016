
function ber=ber_qpsk_noma(para, hsq, pk, data)

    for k=1: para.N
        snr = pk(k)/para.sigma_sq; % SNR
        snr = pow2db(snr); % dB. SNR

        d = data.symbols(:, k); % get the symbols for this user

        % generate TX symbols
        txsymbols = pskmod(d, data.M, pi/4); % offset pi/4 grey coded QPSK

        % for interferer
        for l=k+1: para.N
            d_interferer = data.symbols(:, l);
            txsymbols_interferer = pskmod(d_interferer, data.M, pi/4); % modulate interferer symbols
            p_interferer = pk(l) / pk(k); % power coefficient relative to this user
            txsymbols_pa = p_interferer * txsymbols_interferer; % symbols of interferer are scaled by power

            txsymbols = txsymbols + txsymbols_pa; % add this to this symbols
        end


        % generate the rayleigh faded channel
        rayleighChannel = (1/sqrt(2)) * (randn(data.numsymbols,1) + 1j*randn(data.numsymbols,1));
    
        % scale the rayleigh channel
        rayleighChannel = rayleighChannel * hsq(k);

        % apply the channel to symbol
        rxSymbols_rayleigh = rayleighChannel .* txsymbols;

        % apply the AWGN noise
        rxSymbols_awgn = awgn(rxSymbols_rayleigh, snr, 'measured');

        % MMSE equilization
        H = diag(rayleighChannel); % channel matrix
        equilizedSymbols = H \ rxSymbols_awgn; % equilize

        % demodulation
        rxData_equilized = pskdemod(equilizedSymbols, data.M, pi/4);

        % calculate SER (Symbol Error Rate)
        ser_equilized = sum(d ~= rxData_equilized)/data.numsymbols;

        % calculate BER
        ber(k) = ser_equilized;

    end
end
