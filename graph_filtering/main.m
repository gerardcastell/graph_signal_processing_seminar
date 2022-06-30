close all;
clear all;
run('./gspbox/gsp_start.m')
%% Load data
Y_C = load('temp.mat').Y;
A = load('adjacency.mat').A;
P = load('position.mat').position_matrix;
%T(Celsius) = (T(F ahrenheit) − 32) ∗ 5/9.
Y = (Y_C- 32)*5/9;
%% Plot temperature in Celsius 
figure(1)
mesh(Y);
colorbar
xlabel('Day', 'Rotation',20)
ylabel('Station', 'Rotation',-30)
zlabel('Temperature (Celsius)')
title('Temperature')

%% Generation of an undirected graph
figure(2)
G = gsp_graph(A, P);
gsp_plot_graph(G);
%%
hawai_points=[17.52,-152.48;17.14,-157.79;20.783,-156.95];
idx_to_rm = [];
for j=1:size(hawai_points,1)
    for i=1:size(P,1)
        if P(i,1)== hawai_points(j,1) && P(i,2)== hawai_points(j,2)
            disp(num2str(i));
            idx_to_rm = [idx_to_rm i];
        end
    end
end

A_no_hawai = A;
P_no_hawai = P;
A_no_hawai(idx_to_rm(1),:)=[];
A_no_hawai(idx_to_rm(2),:)=[];
A_no_hawai(idx_to_rm(3),:)=[];
A_no_hawai(:,idx_to_rm(1))=[];
A_no_hawai(:,idx_to_rm(2))=[];
A_no_hawai(:,idx_to_rm(3))=[];
P_no_hawai(idx_to_rm(1),:)=[];
P_no_hawai(idx_to_rm(2),:)=[];
P_no_hawai(idx_to_rm(3),:)=[];

figure()
G_no_hawai = gsp_graph(A_no_hawai, P_no_hawai);
gsp_plot_graph(G_no_hawai);

