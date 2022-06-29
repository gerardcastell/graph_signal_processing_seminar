function score = CNScoring(G, s, t)
    %param s: is a scalar, source node
    %param t: is a scalar, target node
    %param G: is a graph
    s_neighbors = neighbors(G,s);
    t_neighbors = neighbors(G,t);
    CN = intersect(s_neighbors,t_neighbors);
    score=size(CN);
    score = score(1);
end