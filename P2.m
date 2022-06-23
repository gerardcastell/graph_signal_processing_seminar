clear all
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
%data_label_s=data_label_n-1;
%data_label_s(data_label_s==0)=2;

%% Forming a graph

A = pdist2(data_features_n,data_features_n, 'hamming');

G=graph(A); 
%plot(G)

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

%% 5. Performance evaluation
C=confusionmat(data_label_n, idx);
h=gscatter(veps(:,1), veps(:,2), idx);
%% 6. Visual inspection

