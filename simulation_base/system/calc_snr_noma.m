
function snr=calc_snr_noma(para, hsq, pk)
    snr = zeros(1, para.N);
    for k=1: para.N
        snr(k) = pk(k)/(para.sigma_sq + sum(pk(k+1: end)) );
    end
end