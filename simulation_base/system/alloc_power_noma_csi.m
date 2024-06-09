% Allocate power based on NOMA CSI

function Pi = alloc_power_noma_csi(para, hsq)
    one_by_hsq = 1./hsq;
    Pi = one_by_hsq .* (para.P/sum(one_by_hsq));
end
