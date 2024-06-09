
function Ri = calc_rate_noma(para, hsq, Pi)
    Ri = [];
    for i=1: para.N
        deno = para.sigma_sq/hsq(i);
        for k=i+1: para.N
            deno = deno + Pi(k);
        end
        Ri(i) = Pi(i)/deno;
    end    

end