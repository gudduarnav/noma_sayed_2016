
function ber=ber_qpsk_noma_qos(para, hsq, pk, data, user_pair_id)
    
    [num_freq, num_user_per_freq] = size(user_pair_id);
    ber = zeros(1, para.N);

    for index=1: num_freq
        one_user_pair = user_pair_id(index, :);
        counter = length(one_user_pair);
        P_total = 0;

        if counter == 1
            id_h = one_user_pair(1);
            id_l = [];
            P_total = pk(id_h);
        else
            id_h = one_user_pair(1);
            id_l = one_user_pair(2);
            P_total = pk(id_h) + pk(id_l);
        end


        [ber_h, ber_l] = ber_qpsk_noma_qos_pair(para, hsq, pk, data, id_h, id_l, P_total);
        
        if counter==1
            ber(id_h) = ber_h;
        else
            ber(id_h) = ber_h;
            ber(id_l) = ber_l;
        end
    end
end
