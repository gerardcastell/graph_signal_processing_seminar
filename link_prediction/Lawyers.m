clear all;
close all;
%% Reading and cleaning up the data
data = readtable('ELwork36.dat','ReadVariableNames',false);
data_m=table2array(data);
G=graph(data_m);
plot(G)

%% Common Neighbors
n=size(data_m,1);
X=ones(n,n);
X=triu(X);
X=X-diag(diag(X));
[row,col] = find(X);
rc=[row, col];

%% 
rc(1, 1) = []


