function y = filter(G,x, h)
%FILTER Summary of this function goes here
%   Detailed explanation goes here
x_hat = G.U' * x;
y_hat_l = h.*x_hat;
y = G.U*y_hat_l;
end

