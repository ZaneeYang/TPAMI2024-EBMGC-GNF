function r = same_edge_precision(y1, y2)
    y1 = ind2vec(y1');
    y2 = ind2vec(y2');
    G1 = y1' * y1;
    G2 = y2' * y2;
    r = full(sum(G1 & G2, 'all') / sum(G1, 'all'));
end