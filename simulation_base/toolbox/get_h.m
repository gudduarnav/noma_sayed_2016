
function h=get_h(r, wave_len)
    rho0 = wave_len/(4*pi);
    beta_bar = sqrt(rho0)./r;
    phase = (2*pi/wave_len).*r;
    h = beta_bar .* exp(-1j * phase);
end
