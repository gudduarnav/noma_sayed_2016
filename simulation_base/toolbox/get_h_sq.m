
function hsq=get_h_sq(r, wave_len)
    h = get_h(r, wave_len);
    hsq = abs(h).^2;
end
