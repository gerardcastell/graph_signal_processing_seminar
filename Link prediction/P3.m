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
th=5;
G_pred = G_obs;
predicted_true = [];

for i = 1:size(rm,1)%Changed rm for rc -> Score just for unknown edges
%     disp(['Checking edge (', num2str(rm(i,1)), ',', num2str(rm(i,2)), ')']);
    score = CNScoring(G_obs, rm(i,1), rm(i,2));
    if score>=th
%        disp(['Edge (', num2str(rm(i,1)), ',', num2str(rm(i,2)), ') is added...'])
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
[PD, PF] = CalcProbs(5,G,rm, @CNScoring);

%% ROC curve
th_table = [];
for i=0:0.05:10 
    [PD, PF] = CalcProbs(i,G,rm, @CNScoring);
    th_table = [th_table; PD PF];
end
figure(4);
plot(th_table(:,2), th_table(:,1),'DisplayName','Common Neighbors');
title('ROC space')
xlabel('False Positive Rate (1 - Specificity)') 
ylabel('True Positive Rate (Sensitivity)')


% legend({'Common Neighbors','Jaccard','Adamic–Adar'},'Location','southwest')

hold on
%% Other link prediction methods
th_table = [];
for i=0:0.05:10
    [PD, PF] = CalcProbs(i,G,rm, @JScoring);
    th_table = [th_table; PD PF];
end
%figure(5);
plot(th_table(:,2), th_table(:,1), 'DisplayName','Jaccard');
%title('ROC with Jaccard index')
%% 
th_table = [];
for i=0:0.05:10 
    [PD, PF] = CalcProbs(i,G,rm, @AAScoring);
    th_table = [th_table; PD PF];
end
%figure(6);
plot(th_table(:,2), th_table(:,1), 'DisplayName','Adamic–Adar');
plot([0 1], [0 1],'--', 'DisplayName','Random Classifier')
%title('ROC with Adamic–Adar index')
legend('Location','southeast')


hold off