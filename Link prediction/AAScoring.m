function score_AA = AAScoring(G,s,t)
%param s: An array of source nodes
%param t: An array of target edges
%param G: Graph
    s_neighbors = neighbors(G,s);
    t_neighbors = neighbors(G,t);
    isec = intersect(s_neighbors,t_neighbors);
    score_AA = 0;
    for i = 1:size(isec,1)
        d = degree(G, isec);
        score_AA = score_AA + 1./log(d);
    end
end