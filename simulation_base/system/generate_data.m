
function data=generate_data(para, numsymbols)
    data.numsymbols = numsymbols;
    data.M = 4; % QPSK
    data.symbols = randi([0, data.M-1], data.numsymbols, para.N);
end
