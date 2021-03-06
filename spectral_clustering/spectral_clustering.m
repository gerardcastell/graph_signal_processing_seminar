%% 1.Reading and cleanning up the data
data = readtable('agaricus-lepiota.txt','ReadVariableNames',false);
data(:,12)=[];

data_label=data(:,1);
data_features=data(:,2:end);

data_label_c = categorical(data_label{:,:});
data_feature_c = categorical(data_features{:,:});
%% 2. Feature vector encoding

[~,~, data_feature_vec]=unique(data_feature_c);
data_features_n=reshape(data_feature_vec, size(data_features));

[~,~, data_label_vec]=unique(data_label_c);
data_label_n=reshape(data_label_vec, size(data_label));

%% Forming a graph

A = pdist2(data_features_n,data_features_n, 'hamming');

G=graph(A); 
figure(1)
plot(G)
title('Mushrooms Graph')
%% 4. Spectral clustering
on=ones(size(A,1),1);
D_vec=(A*on);
D_mat=diag(D_vec);
D_inv2=diag(D_vec.^(-.5));
L=D_mat-A;
%LL=laplacian(G);
nL=D_inv2*L*D_inv2;
[veps,vaps]=eig(nL);
k=2;
idx=kmeans(veps(:,1:2),k);

%% 5. Performance evaluation & 6.Visual inspection
confchart = figure;
confusionchart(data_label_n, idx)
C=confusionmat(data_label_n, idx);
confusionchart(C);
figure(2)
h=gscatter(veps(:,1), veps(:,2), idx);
title('Scatter plot. Normalized Laplacian. 2 clusters')

figure(3)
h_r=gscatter(veps(:,1), veps(:,2), data_label_n);
title('Sparcification using the real labels')

%% We repeat it with a different number of clusters
k=3;
idx3=kmeans(veps(:,1:3),k);
C3=confusionmat(data_label_n, idx3);
confusionchart(C3);
figure(4)
formats = [".r", ".b", ".g"];

for i = 1:3
    points = veps(idx3 == i, 1:3);
    scatter3(points(:, 1), points(:, 2), points(:, 3), formats(i), 'DisplayName', "Cluster " + i);
    hold on
end

legend('Location', 'Best')
title 'Scatter plot. Normalized Laplacian. 3 clusters'
hold off

%% 7. Alternative embeddings and graoh sparcification

%Unormalized Laplacian matrix
[veps_L,vaps_L]=eig(L);
k=2;
idx_L=kmeans(veps_L(:,1:2),k);

figure(5)
h_un=gscatter(veps_L(:,1), veps_L(:,2), idx_L);
title('Scatter plot. Unormalized Laplacian. 2 clusters')

% Random-walk Laplacian matrix
D_inv=diag(1./D_vec);
rwL=D_inv*L;
[veps_rw,vaps_rw]=eig(rwL);
k=2;
idx_rw=kmeans(veps_rw(:,1:2),k);
figure(6)
h_rw=gscatter(veps_rw(:,1), veps_rw(:,2), idx_rw);
title('Scatter plot. Random-walk Laplacian. 2 clusters')

