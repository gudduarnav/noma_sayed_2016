

function Ri=calc_rate_oma(para, hsq, Pi)
    Ri = (1/para.N) * log2(1 + hsq .* Pi/para.sigma_sq);
end
