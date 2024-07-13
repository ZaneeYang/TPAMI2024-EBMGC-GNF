function [y, cnt, coarsened]= first_nn_merge(As , k_n ,same_nn)
    num_views = numel(As);
    n = size(As{1}, 1);
    
    As2 = cellfun(@(A) spdiags(sparse(n, 1), 0, A), As, 'UniformOutput', false);   
    
%     [~, first_nns] = cellfun(@(A) max(A , [] , 2), As, 'UniformOutput', false);                                                                                    
%     G_first_gns = cellfun(@(first_nn) sparse(1:n, first_nn, 1, n, n), ...
%             first_nns, 'UniformOutput', false);
%非对称
  
%     [~, first_nns] = cellfun(@(A) max(A , [] , 2), As, 'UniformOutput', false);                                                                          
%     G_first_gns = cellfun(@(first_nn) struct_nn(first_nn, same_nn), ...
%             first_nns, 'UniformOutput', false);
%对称

    
    [~, first_gns] = cellfun(@(A) maxk(A , k_n , 2), As, 'UniformOutput', false);         
    G_first_gns = cellfun(@(first_gn) struct_gn(first_gn, same_nn), ...
          first_gns, 'UniformOutput', false);
   
 
    G_shared_first_gn = sparse(n, n);
    for v = 1:num_views
        G_shared_first_gn = G_shared_first_gn + G_first_gns{v};
    end
    G_shared_first_gn = G_shared_first_gn >= fix(num_views / 2) + 1;
    G_shared_first_gn = G_shared_first_gn + G_shared_first_gn';  

    [~, y] = graphconncomp(G_shared_first_gn, 'Directed', false);

    Y = ind2vec(y);
    cnt = full(sum(Y, 2));  %每一类的数目
    coarsened = cellfun(@(A) Y * A * Y', As, 'UniformOutput', false);
    y = y';
end
