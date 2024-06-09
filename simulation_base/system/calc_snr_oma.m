

function snr=calc_snr_oma(para, hsq, pk)
    snr = hsq .* pk / para.sigma_sq;
end
