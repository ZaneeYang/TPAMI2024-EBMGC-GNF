
function [A, orig_sim,min_sim]= clustRank(orig_sim, initial_rank)
% Implements the clustering eqaution
% copyright M. Saquib Sarfraz (KIT), 2019

s=size(orig_sim,1);  % to handle direct input of initial_rank and avoid computing pdist.. if computing 1-neigbours indices via flann

if ~isempty(initial_rank)
        orig_sim=[]; min_sim=inf;
else
 orig_sim(logical(speye(size(orig_sim))))=0;
 [d,initial_rank]=max(orig_sim,[],2);
 min_sim=min(d);
end


%%% Implementation of The clustering Equation %%

%%% Note only needs integer indices of first neigbours to directly deliver the adj matrix which has
%%% the clusters.

  A=sparse([1:s],initial_rank,1,s,s);

  A= A + sparse([1:s],[1:s],1,s,s);
  A= (A*A');
  A(logical(speye(size(A))))=0;
  A=spones(A);
%%%

end
