function [Lr, Sp, G1, G2, U, S, V] = gsp_gpcatv_2g(X, gamma1, gamma2, G1, G2, param)
%GSP_GPCATV_2G Graph PCA using TV (2 graphs)
%   Usage: [Lr] = gsp_gpcatv_2g(X, gamma1, gamma2, G1, G2);
%          [Lr] = gsp_gpcatv_2g(X, gamma1, gamma2, G1, G2, param);
%          [Lr, Sp] = gsp_gpcatv_2g( ... );
%          [Lr, Sp, G1, G2] = gsp_gpcatv_2g( ... );
%          [Lr, Sp, G1, G2, U, S, V] = gsp_gpcatv_2g( ... );
%
%   Input parameters: 
%       X       : Input data (matrix of double)
%       gamma1  : Regularization parameter 1 (double)
%       gamma2  : Regularization parameter 2 (double)
%       G1      : Graph 1 (between the line of the data )
%       G2      : Graph 2 (between the column of the data )
%       param   : Optional parameters
%
%   Output Parameters:
%       Lr      : Low-rank part of the data
%       Sp      : Sparse part of the data
%       G1      : Graph 1 (between the line of the data )
%       G2      : Graph 2 (between the column of the data )
%       U       : Part of the SVD of Lr
%       S       : Part of the SVD of Lr
%       V       : Part of the SVD of Lr
%
%   This function compute a low rank approximation of the data stored in
%   Lr by solving an optimization problem:
%
%      argmin_Lr || Lr - X ||_1  + gamma1 || X ||_TVG + gamma2 tr( X L2 X^T)
%
%   The sparse part is given by  S = X - L_r . 
%   
%   If 0 is given for G1 and/or G2, the corresponding graph(s) will
%   be computed internally. The graph construction can be tuned using the
%   optional parameter: param.paramnn.
%
%   Other optional parameters are used in optimization. For details about
%   those, please see the help of the function SOLVEP . 
%
%   If the number of output argument is greater than 2. The function, will
%   additionally compute a very economical SVD such that  Lr = U S V^T.
%
%   This function uses the UNLocBoX to be working.
%
%   References:
%     N. Shahid, N. Perraudin, V. Kalofolias, and P. Vandergheynst. Fast
%     robust pca on graphs. arXiv preprint arXiv:1507.08173, 2015.
%     
%     
%
%   See also: gsp_frpcaog_1g
%
%   Url: https://epfl-lts2.github.io/gspbox-html/doc/graph_ml/gsp_gpcatv_2g.html

% Copyright (C) 2013-2016 Nathanael Perraudin, Johan Paratte, David I Shuman.
% This file is part of GSPbox version 0.7.5
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% If you use this toolbox please kindly cite
%     N. Perraudin, J. Paratte, D. Shuman, V. Kalofolias, P. Vandergheynst,
%     and D. K. Hammond. GSPBOX: A toolbox for signal processing on graphs.
%     ArXiv e-prints, Aug. 2014.
% http://arxiv.org/abs/1408.5781

% Author: Nathanael Perraudin
% Date  : 19th October 2015

%% Optional parameters

if nargin<6
    param = struct;
end

if ~isfield(param, 'verbose'), param.verbose = 1; end
if ~isfield(param, 'paramnn'), param.paramnn = struct; end

if ~isstruct(G1) 
    G1 = gsp_nn_graph(transpose(X), param.paramnn);
end

if ~isstruct(G2) 
    G2 = gsp_nn_graph(X, param.paramnn);
end

if ~isfield(G1,'lmax')
    G1 = gsp_estimate_lmax(G1);
end

if ~isfield(G2,'lmax')
    G2 = gsp_estimate_lmax(G2);
end


if ~isfield(G1,'Diff')
    G1 = gsp_adj2vec(G1);
end
if ~isfield(G2,'Diff')
    G2 = gsp_adj2vec(G2);
end

%%


paraml1.verbose = param.verbose -1;
paraml1.y = X;
f1.prox = @(x,T) prox_l1(x,T,paraml1);
f1.eval = @(x) norm(x(:),1);


D1 = G1.Diff;
param_tvl1.verbose = param.verbose - 1;
f2.prox = @(x,T) prox_l1(x,T*gamma1,param_tvl1);
f2.eval = @(x) gamma1*sum(sum(abs(D*x)));
f2.L= @(x) D1*x;
f2.Lt = @(x) D1'*x;
f2.norm_L = 2*G1.lmax;

f3.grad = @(x) gamma2*(2*x*G2.L);
f3.eval = @(x) gamma2*sum(gsp_norm_tik(G2,x'));
f3.beta = 2*gamma2*G2.lmax;

paramsolver = param;
paramsolver.algo = 'fb_based_primal_dual';

Lr = solvep(X,{f1,f2,f3},paramsolver);

Sp = X-Lr;

%% Optional arguments
if nargout>4
    [U, S , V] = svdecon(Lr);
end

end



