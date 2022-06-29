%% Reading and cleaning up the data
data = readtable('LazegaLawyers/ELwork36.dat');
data_m = table2array(data);
%% Plot the graph
G=graph(data_m); 
figure(1)
plot(G)
title('Graph')

%% Common Neighbors
n_vertex = 630;
n_edges_to_rm = n_vertex / 5;
edges_to_rm = randperm(n_vertex,n_edges_to_rm);
%G_rm = rmedge(G, edges_to_rm);
for i = 1:edges_to_rm
end
%% prueba

vectors = [];
for i = 1:36
    for j = i+1:36
        vectors = [vectors [i j]];
    end
end
