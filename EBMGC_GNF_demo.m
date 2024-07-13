clear; clc;

addpath('EBMGC_GNF');
addpath('finchpp');
addpath('funs');
global p  %balanced

p= 5;
k_n=4;
same_nn=2;

% load dataset
load('COIL20.mat');
X = cellfun(@(x) (x - mean(x, 2)) ./ std(x, 0, 2), X, 'uni', 0);  %%标准化处理
n = size(X{1}, 1);    
c = numel(unique(Y));

As = cellfun(@(x) constructW_PKN(x, 10), X, 'uni', 0);

[y_pred, obj, coeff, n_g, y_coar, evaltime] = run_EBMGC_GNF(As, c, true, k_n, same_nn);
result = ClusteringMeasure_new(Y, y_pred);
fprintf('time=%f\n', evaltime);
disp(result);
pr=same_edge_precision(y_coar,Y);
disp(pr);