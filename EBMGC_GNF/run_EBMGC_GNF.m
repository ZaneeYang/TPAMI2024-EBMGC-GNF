function [y_pred, obj, coeff, n, y_coar, evaltime] = run_AMAOF(As, num_clusters, use_grid, k_n, same_nn)
    if nargin < 5
        use_grid = true;
    end

    if use_grid
        tic;                                                        %%tic,toc搭配记录时间
        [y_coar, coar_grid_cnt, As_coar] = first_nn_merge(As, k_n ,same_nn);
        evaltime = toc;
        n = size(As_coar{1}, 1);

        Y_init_coar = finchpp(graph_avg(As_coar), num_clusters);

        tic;
        [y_pred, obj, coeff] = ebmgc_gnf(As_coar, Y_init_coar, coar_grid_cnt);
        evaltime = evaltime + toc;
        y_pred = vec2ind(y_pred')';
        y_pred = y_pred(y_coar);
    else
        y_coar = [];
        n = size(As{1}, 1);
        Y_init = finchpp(graph_avg(As), num_clusters);
        tic;
        [y_pred, obj, coeff] = ebmgc_gnf(As, Y_init);
        evaltime = toc;
        y_pred = vec2ind(y_pred')';
    end
end
