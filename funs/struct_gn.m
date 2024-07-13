function first_struct_gn = struct_gn(first_gn, same_nn)
    [n,m]=size(first_gn);
    first_struct_gn = sparse(n, n);

    for i=1:n
        for j=1:m
                if   numel(intersect(first_gn(i,:),first_gn(first_gn(i,m),:)))>=same_nn
                    
                      first_struct_gn(i,first_gn(i,m))=1; 
                      
                end         
        end
    end
    
end