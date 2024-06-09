
function Ri=calc_rate_noma_qos(para, hsq, pk_qos, user_pair_id)
    snr = calc_snr_noma_qos(para, hsq, pk_qos, user_pair_id);
    Ri = log2(1 + snr);
end