%% Set up needed functions from toolbox module
clear all;close all
run('./gspbox/gsp_start.m')
%run('./unlocbox/init_unlocbox.m')


%% Build a regular grid
% Look for an image of 50x50 pixels, increase contrast to achieve a
% connected graph
bw=imread('images/thunder.png');
bw =sign(imcomplement(bw));
bw=bw(:,:,1);
% [i,j]=find(bw==0);
% for ind=1:length(i)
% bw(i(ind),j(ind))=1;
% end;
[i,j]=find(bw>1);
for ind=1:length(i)
bw(i(ind),j(ind))=1;
end
[g,nodenums] = binaryImageGraph(bw,4);
xcoor = g.Nodes.x;
ycoor = size(nodenums,2)-g.Nodes.y; % Flip to proper plot
figure(2);
plotImageGraph(g)

%% Spectral analysis of the undirected unweighted graph

W=adjacency(g);
G=gsp_graph(W,[xcoor ycoor]);
G = gsp_compute_fourier_basis(G); 
param.climits=[0 0.1];
figure(3);
subplot(311);
gsp_plot_signal(G,G.U(:,1),param);
subplot(312);
gsp_plot_signal(G,G.U(:,2),param);
subplot(313);
gsp_plot_signal(G,G.U(:,3),param);

%% Represent the 4,5,6th eigenvectors
figure(32);
subplot(311);
gsp_plot_signal(G,G.U(:,4),param);
subplot(312);
gsp_plot_signal(G,G.U(:,5),param);
subplot(313);
gsp_plot_signal(G,G.U(:,6),param);


%% Representation of graph signals in 3D
param.bar=1;
figure(4) 
gsp_plot_signal(G,G.U(:,2),param)
title('Second eigenvector as a graph signal')

param.bar=1;
figure(42) 
gsp_plot_signal(G,G.U(:,6),param)
title('Sixth eigenvector as a graph signal')

%% Add some extra edges
%newedg=[144 157;144 157; 146 158; 146 163; 146 168 ; 149 158; 149 169; 153 161; 163 171; 155 160; 155 167;273 276; 273 277; 270 276; 272 277]; 
newedg=[43 17; 31 14; 30 11; 45 15; 31 19; 28 16; 46 18]; 
g=addedge(g,newedg(:,1),newedg(:,2),ones(1,size(newedg,1))); 
xcoor = g.Nodes.x;
ycoor = size(nodenums,2)-g.Nodes.y; 
% Flip to proper plot. 
figure(5);
plotImageGraph(g)
W=adjacency(g);
G=gsp_graph(W,[xcoor ycoor]);
G = gsp_compute_fourier_basis(G);
figure(6)
param.climits=[-0.08 0.08];
param.bar=0; subplot(311);
gsp_plot_signal(G,G.U(:,1),param);
subplot(312);gsp_plot_signal(G,G.U(:,2),param);
subplot(313);gsp_plot_signal(G,G.U(:,3),param);
%% second eigenvectors
figure(8)
param.climits=[-0.1 0.2];
subplot(311);gsp_plot_signal(G,G.U(:,4),param);
subplot(312);gsp_plot_signal(G,G.U(:,8),param);
subplot(313);gsp_plot_signal(G,G.U(:,12),param);
%% Second eigenvector as a graph signal (representation in 3D)
param.bar=1;
figure(7) 
gsp_plot_signal(G,G.U(:,2),param)

%% An additional test. Now U is connected to C, and C to P. Notice the change in the variation of the eigenvectors across the graph.
% [g,nodenums] = binaryImageGraph(bw,4);
% newedg=[144 312;144 326; 146 315; 146 320; 146 321 ; 149 317; 149 319; 153 312; 163 325; 155 315; 155 318;273 276; 273 277; 270 276; 272 277]; g=addedge(g,newedg(:,1),newedg(:,2),ones(1,size(newedg,1))); xcoor = g.Nodes.x;
% ycoor = size(nodenums,2)-g.Nodes.y; 
% % Flip to proper plot. 
% figure(8);
% plotImageGraph(g)
% W=adjacency(g);
% G=gsp_graph(W,[xcoor ycoor]);
% G = gsp_compute_fourier_basis(G);
% figure(9)
% param.climits=[-0.1 0.1];
% param.bar=0; subplot(311);
% gsp_plot_signal(G,G.U(:,1),param);
% subplot(312);gsp_plot_signal(G,G.U(:,2),param);
% subplot(313);gsp_plot_signal(G,G.U(:,3),param);
% % First three eigenvectors
% figure(9)
% param.climits=[-0.1 0.2]; subplot(311);gsp_plot_signal(G,G.U(:,4),param); subplot(312);gsp_plot_signal(G,G.U(:,8),param); subplot(313);gsp_plot_signal(G,G.U(:,12),param);