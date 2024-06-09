
function snr=calc_snr_noma_qos(para, hsq, pk_qos, user_pair_id)
    snr = zeros(1, para.N);
    [num_freq, num_user_per] = size(user_pair_id);
    for index=1: num_freq
        one_user_pair = user_pair_id(index, :);
        if length(one_user_pair) == 1
            id_h = one_user_pair(1);
            snr(id_h) = hsq(id_h)*pk_qos(id_h)/(para.sigma_sq);
        else
            id_h = one_user_pair(1);
            id_l = one_user_pair(2);

            snr(id_h) = hsq(id_h)*pk_qos(id_h)/(hsq(id_h)*pk_qos(id_l) + para.sigma_sq); % low priority is the interference here
            snr(id_l) = hsq(id_l)*pk_qos(id_l)/(para.sigma_sq); % SIC removed the strong high priority user's signal
        end
    end

end