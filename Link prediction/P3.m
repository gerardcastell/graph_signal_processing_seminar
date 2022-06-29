clear all
close all
%% Reading and cleaning up the data
data = readtable('dataset/ELwork36.dat','ReadVariableNames',false);
data_m=table2array(data);
G=graph(data_m);

%Plot
figure(1);
plot(G)
title('Original graph');
%% Common Neighbors randperm
X=ones(size(data_m,1));
X=triu(X);
X=X-diag(diag(X));
[row, col] = find(X);
rc=[row col]; %Row and col that are 1 (All possible edges in a graph)

rnd_indexes = randperm(630, 630/5);
rm = rc(rnd_indexes,:);%Random edges generated
s_rm = rm(:,1);
t_rm = rm(:,2);

G_obs = rmedge(G,s_rm, t_rm);%Graph G removing the random edges

%Plot
figure(2);
plot(G_obs)
title('Graph without 126 edges');


%% Getting score and correcting
th=10;
G_pred = G_obs;
predicted_true = [];

for i = 1:size(rm,1)%Changed rm for rc -> Score just for unknown edges
    disp(['Checking edge (', num2str(rm(i,1)), ',', num2str(rm(i,2)), ')']);
    score = CNScoring(G_obs, rm(i,1), rm(i,2));
    if score>=th
       disp(['Edge (', num2str(rm(i,1)), ',', num2str(rm(i,2)), ') is added...'])
       G_pred = addedge(G_pred, rm(i,1), rm(i,2), 1);
       predicted_true = [predicted_true; rm(i,:)];
    else
       G_pred = rmedge(G_pred, rm(i,1), rm(i,2));
    end    
end

%% Plot corrected
figure(3);
plot(G_pred)
title('Graph predicted');

%% Probability of detection and false alarm
[s_G, t_G] = findedge(G);
[s_G_pred, t_G_pred] = findedge(G_pred);
idx_G = [s_G, t_G];
idx_G_pred = [s_G_pred, t_G_pred];

real_1=0;
real_0=0;
predicted_true_1 = 0;

for i = 1:size(predicted_true,1)
    for j = 1:size(idx_G,1)
        if all(predicted_true(i, :) == idx_G(j,:))
            disp(['Found ', num2str(predicted_true(i,1)), ',', num2str(predicted_true(i,2))])
            predicted_true_1 = predicted_true_1 + 1;
        end
    end
end

to_be_true_1 = 0;
for i = 1:size(rm,1)
    for j = 1:size(idx_G,1)
        if all(rm(i, :) == idx_G(j,:))
            disp(['Random true 1 ', num2str(rm(i,1)), ',', num2str(rm(i,2))])
            to_be_true_1 = to_be_true_1 + 1;
        end
    end
end

predicted_false_1 = size(predicted_true, 1) - predicted_true_1;% All predicted as 1 minus the real predicted as 1;
real_0 = size(rm,1) - to_be_true_1;
PD = predicted_true_1/to_be_true_1
PF = predicted_false_1/real_0
