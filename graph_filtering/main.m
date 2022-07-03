clear all
%% Reading and cleaning up the data
A = load('dataset/adjacency.mat');
Y = load('dataset/temp.mat');
pos = load('dataset/position.mat');
Y = cell2mat(struct2cell(Y));
A = cell2mat(struct2cell(A));
pos = cell2mat(struct2cell(pos));
%From F to C
Y = (Y-32).*(5/9);
figure(1);
mesh(Y);

xlabel('Time [day]', 'Rotation',20)
ylabel('Station number', 'Rotation',-30)
zlabel('Temperature [C]')
title('Temperature in the stations for each day of the year');

%% Building graph
%pos comes from position.mat and has 2 columns
G = gsp_graph(A,pos);

figure(2);
gsp_plot_graph(G);
title('Directed graph of the US weather dataset');

%% Generation of an undirected graph
hawaii = [17.52, -152.48; 17.14, -157.79; 20.783, -156.95];
idx_to_rm = [];
for j=1:size(hawaii,1)
    for i=1:size(pos,1)
        if pos(i,1)== hawaii(j,1) && pos(i,2)== hawaii(j,2)
            idx_to_rm = [idx_to_rm i];
        end
    end
end

A_no_hawai = A;
P_no_hawai = pos;
Y_no_hawai = Y;

idx_to_rm = flip(idx_to_rm);
A_no_hawai(idx_to_rm(1),:)=[];
A_no_hawai(idx_to_rm(2),:)=[];
A_no_hawai(idx_to_rm(3),:)=[];
A_no_hawai(:,idx_to_rm(1))=[];
A_no_hawai(:,idx_to_rm(2))=[];
A_no_hawai(:,idx_to_rm(3))=[];
P_no_hawai(idx_to_rm(1),:)=[];
P_no_hawai(idx_to_rm(2),:)=[];
P_no_hawai(idx_to_rm(3),:)=[];
Y_no_hawai(idx_to_rm(1),:)=[];
Y_no_hawai(idx_to_rm(2),:)=[];
Y_no_hawai(idx_to_rm(3),:)=[];


figure(3);
G_no_hawai = gsp_graph(A_no_hawai, P_no_hawai);
gsp_plot_graph(G_no_hawai);
title('Weather graph without hawaii');

%% Undirected graph
A_u = sign(A_no_hawai.' + A_no_hawai);

figure(4);
G_u = gsp_graph(A_u, P_no_hawai);
gsp_plot_graph(G_u);
title('Undirected Weather graph');
%% Low pass filter
dia = randperm(365,1);
x = Y_no_hawai(:,dia);
G_u = gsp_compute_fourier_basis(G_u);

h_hat_l= 1./(1+G_u.e);
x_hat = G_u.U' * x;

y_hat_l = h_hat_l.*x_hat;
y_l = G_u.U*y_hat_l;

%% Plot results
figure(5);
param.climits=[min(x)-0.5, max(x)+0.5];
subplot(211); gsp_plot_signal(G_u,x,param); title(['Original data of day ', num2str(dia)]);
subplot(212); gsp_plot_signal(G_u,y_l,param); title(['Result of applying low pass filter on the day ', num2str(dia)]);

%% High pass filter
lambda_max = max(G_u.e);
h_hat_h= 1./(1-(G_u.e-lambda_max));
y_hat_h = h_hat_h.*x_hat;
y_h = G_u.U*y_hat_h;

%% Plot results
figure(6);
param.climits=[min(x)-0.5, max(x)+0.5];
subplot(211); gsp_plot_signal(G_u,x,param); title(['Original data of day ', num2str(dia)]);
param.climits=[min(y_h)-0.5, max(y_h)+0.5];
subplot(212); gsp_plot_signal(G_u,y_h,param); title(['Result of applying high pass filter on the day ', num2str(dia)]);;


%% Testing four seasons

G_u = gsp_compute_fourier_basis(G_u);

winter = 30;
spring = 150;
summer = 215;
outum = 300;

x_w = Y_no_hawai(:,winter);
x_sp = Y_no_hawai(:,spring);
x_s = Y_no_hawai(:,summer);
x_o = Y_no_hawai(:,outum);

h_l = 1./(1+G_u.e);
h_h = 1./(1-(G_u.e-max(G_u.e)));

% Low pass filter
y_w_l = filter(G_u, x_w, h_l);
y_sp_l = filter(G_u, x_sp, h_l);
y_s_l = filter(G_u, x_s, h_l);
y_o_l = filter(G_u, x_o, h_l);

%High-pass filter
y_w_h = filter(G_u, x_w, h_h);
y_sp_h = filter(G_u, x_sp, h_h);
y_s_h = filter(G_u, x_s, h_h);
y_o_h = filter(G_u, x_o, h_h);

figure(7);
subplot(212); gsp_plot_signal(G_u,x_w); title('Original data of winter');
subplot(221); gsp_plot_signal(G_u,y_w_l); title('Result of applying a low pass filter on winter');
subplot(222); gsp_plot_signal(G_u,y_w_h); title('Result of applying a high pass filter on winter');

figure(8);
subplot(212); gsp_plot_signal(G_u,x_sp); title('Original data of spring');
subplot(221); gsp_plot_signal(G_u,y_sp_l); title('Result of applying a low pass filter on spring');
subplot(222); gsp_plot_signal(G_u,y_sp_h); title('Result of applying a high pass filter on spring');

figure(9);
subplot(212); gsp_plot_signal(G_u,x_s); title('Original data of summer');
subplot(221); gsp_plot_signal(G_u,y_s_l); title('Result of applying a low pass filter on summer');
subplot(222); gsp_plot_signal(G_u,y_s_h); title('Result of applying a high pass filter on summer');

figure(10);
subplot(212); gsp_plot_signal(G_u,x_o); title('Original data of outumn');
subplot(221); gsp_plot_signal(G_u,y_o_l); title('Result of applying a low pass filter on outumn');
subplot(222); gsp_plot_signal(G_u,y_o_h); title('Result of applying a high pass filter on outumn');