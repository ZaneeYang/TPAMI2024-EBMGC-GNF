function [Y, obj, coeff] = ebmgc_gnf(As, Y, grid_cnt, max_iter)

%   Wu D, Yang Z, Lu J, et al. EBMGC-GNF: Efficient Balanced Multi-view Graph Clustering via Good Neighbor Fusion[J]. 
%   IEEE Transactions on Pattern Analysis and Machine Intelligence, 2024.
%
%   Please contact Danyang Wu <danyangwu.cs@gmail.com> if you have any
%   questions.
%
%   SPDX-FileCopyrightText: 2024 Zhenkun Yang <ftyzknow@mail.scut.edu.cn>
%   SPDX-License-Identifier: MIT
    arguments
        As
        Y
        grid_cnt = []
        max_iter = 50
    end
    Ls = calc_laps(As);

    for iter = 1:max_iter
        view_objs = calc_view_objs(Ls, Y, grid_cnt);
        coeff = 1 ./ (2 .* view_objs);
        obj(iter) = sum(view_objs);
        if iter > 2 && abs((obj(iter) - obj(iter - 1)) / obj(iter - 1)) < 1e-9
            break;
        end

        % Y step
        L = weighted_sum(Ls, coeff);
        Y = solve_Y(L, Y, grid_cnt);
    end
end
