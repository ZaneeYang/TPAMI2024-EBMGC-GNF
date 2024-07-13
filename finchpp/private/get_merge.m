 function [c,num_clust, mat]=get_merge(c,u,data)
  %% core procedure for mergeing in aLgorthm 1
    u_ =ind2vec(u); num_clust=size(u_,1);

    if ~isempty(c)
     c=getC(c,u');
     else
        c=u';
    end




    mat = u_ * data * u_';
    cnt_mul = sum(u_, 2);
    cnt_mul = cnt_mul * cnt_mul';
    mat = mat ./ cnt_mul;

     function G=getC(G,u)

    [~,~,ig]=unique(G);

    G=u(ig);

    end



  end
