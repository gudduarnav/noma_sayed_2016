% Generate the channels

function [hsq] = generate_channels(para)
    hsq = get_h_sq(para.r, para.wave_len);
end
