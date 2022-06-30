function score_J = JScoring(G,s,t)
%param s: is a scalar, source node
%param t: is a scalar, target node
%param G: is a graph
    score_CN = CNScoring(G,s,t);
    s_neighbors = neighbors(G,s);
    t_neighbors = neighbors(G,t);
    U=union(s_neighbors,t_neighbors);
    size_U = size(U,1);
    score_J = score_CN/size_U;
end