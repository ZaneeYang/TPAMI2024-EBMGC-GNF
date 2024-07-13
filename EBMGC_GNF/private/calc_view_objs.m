function objs = calc_view_objs(Ls, Y, grid_cnt)
     
    global p                   
      
    if isempty(grid_cnt)
        n = size(Y, 1);
        n_grid = full(sum(Y)');
    else
        n = sum(grid_cnt);
        n_grid = Y' * grid_cnt;
    end
    

        yyn = 1 ./ ( n_grid .^p);                         

      
    objs = cellfun(@(L) vecnorm(full(L * Y), 1) * yyn, Ls);
    objs = sqrt(objs)';
end
