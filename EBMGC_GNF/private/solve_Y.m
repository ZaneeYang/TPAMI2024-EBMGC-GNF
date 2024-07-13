function [Y, obj] = solve_Y(L, Y, grid_cnt, max_iter, early_stop)

    arguments
        L
        Y
        grid_cnt = []
        max_iter = 50
        early_stop = true
    end
    
    global p
    
    n_cluster = full(sum(Y)');
    if isempty(grid_cnt)
        n = size(Y, 1);
        grid_cnt = ones(n, 1);
        n_grid = n_cluster;
    else
        % total real nodes
        n = sum(grid_cnt);
        % real nodes per cluster
        n_grid = Y' * grid_cnt;
    end

    YL = Y' * L;
    yLy = full(diag(YL * Y));
    YL = full(YL);
%     yyn = n_grid .* (n - n_grid);
    yyn = n_grid .^p;
    L = full(L);  % ATTENTION!

    p_all = vec2ind(Y');

    obj(1) = sum(yLy ./ yyn);
    for iter = 1:max_iter
        for i = 1:size(Y, 1)
            m = p_all(i);
            % avoid generating empty cluster
            if n_cluster(m) == 1
                continue;
            end

            Lii = full(L(i, i));

            yLy_k = yLy + 2 .* YL(:, i) + Lii;
            yLy_k(m) = yLy(m);

            % NOTE: use number of supernodes here
%             yyn_k = (n_grid + grid_cnt(i)) .* (n - grid_cnt(i) - n_grid);
            yyn_k = (n_grid + grid_cnt(i)) .^p;
            yyn_k(m) = yyn(m);

            yLy_0 = yLy;
            yLy_0(m) = yLy(m) - 2 .* YL(m, i) + Lii;

            yyn_0 = yyn;
%             yyn_0(m) = (n_grid(m) - grid_cnt(i)) * (n - n_grid(m) + grid_cnt(i));
            yyn_0(m) = (n_grid(m) - grid_cnt(i)) .^p;

            delta = yLy_k ./ yyn_k - yLy_0 ./ yyn_0;

            [~, r] = min(delta);
            if r ~= m
                yLy(m) = yLy_0(m);
                yyn(m) = yyn_0(m);
                yLy(r) = yLy_k(r);
                yyn(r) = yyn_k(r);

                Li = full(L(i, :));
                YL(r, :) = YL(r, :) + Li;
                YL(m, :) = YL(m, :) - Li;

                n_cluster(r) = n_cluster(r) + 1;
                n_cluster(m) = n_cluster(m) - 1;

                n_grid(r) = n_grid(r) + grid_cnt(i);
                n_grid(m) = n_grid(m) - grid_cnt(i);

                Y(i, r) = 1;
                Y(i, m) = 0;
                p_all(i) = r;
            end
        end
        obj(iter + 1) = sum(yLy ./ yyn);

        if early_stop && iter > 2 && abs((obj(iter + 1) - obj(iter)) / obj(iter)) < 1e-9
            break;
        end
    end
end
