close all;
clear all;
%% Load data
Y_C = load('temp.mat').Y;
A = load('adjacency.mat').A;
P = load('position.mat').position_matrix;
%T(Celsius) = (T(F ahrenheit) − 32) ∗ 5/9.
Y = (Y_C- 32)*5/9;
%% Plot temperature in Celsius 
mesh(Y);
colorbar
xlabel('Day', 'Rotation',20)
ylabel('Station', 'Rotation',-30)
zlabel('Temperature (Celsius)')
title('Temperature')