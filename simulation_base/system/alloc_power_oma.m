% Allocate power for OMA 

function Pi=alloc_power_oma(para, hsq)
    dims = size(para.r);
    Pi = (para.P / para.N) * ones(dims(1), dims(2));

end
