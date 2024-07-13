function first_struct_nn = struct_nn(first_gn, same_nn)
    [n,m]=size(first_gn);
    first_struct_nn = sparse(n, n);

    for i=1:n
        first_struct_nn(i,first_gn(i,1))=1; 
        first_struct_nn(first_gn(i,1),i)=1; 
    end

%     for i=1:n
%     first_gn1(i,1) = first_gn(i,1);
%     end 
%     first_struct_gn = sparse(1:n, first_gn1, 1, n, n);
    
end
