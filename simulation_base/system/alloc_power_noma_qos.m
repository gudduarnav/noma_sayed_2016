% Allocate power based on QoS

function [Pi, user_pair_id] = alloc_power_noma_qos(para, hsq)
    % calculate OMA capacity
    Pi_oma = alloc_power_oma(para, hsq);
    Ri_oma = calc_rate_oma(para, hsq, Pi_oma);

    % calculate NOMA demand capacity
    R_noma = para.C .* Ri_oma;

    % calculate gamma
    gamma = 2.^(R_noma/1) - 1;

    % look for the one with highest priority and then move to low priority
    [sored_R_noma, idx] = sort(R_noma, 'descend'); 

    % group the users into frequency pairs
    % (highest and lowest)
    id_pair = [];

    while length(idx) ~= 0
        if length(idx) >= 2
            id_pair = [id_pair; idx(1), idx(end)];
            idx(1) = [];
            idx(end) = [];
        else length(idx) == 1
            id_pair = [id_pair; idx(1), []];
            idx(1) = [];
        end
    end


    [num_freq_blocks, num_items_on_freq_block] = size(id_pair); 


    % divide the power among frequency blocks equally
    P_total_per_block = para.P/num_freq_blocks;

    P_allocation = [];

    for index = 1: num_freq_blocks
        % get the high user and low user
        id = id_pair(index, :);
        if length(id) == 1
            % if there is one user on this frequency block
            % allocate all power to this user only
            P_allocation = [P_allocation; P_total_per_block, []];
        else
            % there are two users on this frequency block
            % allocate QoS based power to this user

            % get ids of this user
            id_h = id(1); % high priority user
            id_l = id(2); % low priority user

            % calculate high user power
            rho = P_total_per_block / para.sigma_sq;
            Ph = gamma * (hsq(id_h)+1/rho) * P_total_per_block / (hsq(id_h) * (gamma+1));
            Ph = max([Ph, 0]); % power must be nonnegative
            
            % calculate low user power
            Pl = P_total_per_block - Ph; 
            Pl = max([0, Pl]); % power must be nonnegative;

            % save this allocated power
            P_allocation = [P_allocation; Ph, Pl];
        end

    end
    
    % allocate actual power
    Pi = zeros(1, para.N);

    for index = 1: num_freq_blocks
        id = id_pair(index, :);
        if length(id) == 1
            id_h = id(1);
            Pi(id_h) = P_allocation(index,1);
        else
            id_h = id(1);
            id_l = id(2);

            Pi(id_h) = P_allocation(index, 1);
            Pi(id_l) = P_allocation(index, 2);
        end

    end

    % save the pairs
    user_pair_id = id_pair;

end
