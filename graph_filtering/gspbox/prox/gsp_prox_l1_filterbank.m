function [sol, info] = gsp_prox_l1_filterbank(x, gamma, G, W, param)
%GSP_PROX_L1_FILTERBANK Proximal L1 operator for a filterbank
%   Usage:  sol = gsp_prox_l1_filterbank(x, T, G, W, param);
%           sol = gsp_prox_l1_filterbank(x, T, G, W);
%           [sol, info] = gsp_prox_l1_filterbank(...)
%
%   Input parameters:
%         x     : Input signal.
%         gamma : Regularization parameter.
%         G     : Graph structure
%         W     : Filterbank (cell array of functions)
%         param : Structure of optional parameters.
%   Output parameters
%         sol   : Solution.
%         info  : Structure summarizing informations at convergence
%
%   This function require the UNLocBoX to be executed.
%
%   GSP_PROX_L1_FILTERBANK(x, gamma, G, W, param) solves:
%
%      sol = argmin_{z} 0.5*||x - z||_2^2 + gamma * || W x ||_1
%
%   Where W is the linear analysis operator associated with the
%   filterbank.
%
%   param is a Matlab structure containing the following fields:
%   
%    param.tight : 1 if A is a tight frame or 0 if not (default = 0)
%   
%    param.tol : is stop criterion for the loop. The algorithm stops if
%
%         (  n(t) - n(t-1) )  / n(t) < tol,
%      
%     where  n(t) = f(x)+ 0.5 X-Z_2^2 is the objective function at
%     iteration t by default, tol=10e-4.
%
%    param.maxit : max. nb. of iterations (default: 200).
%
%    param.verbose : 0 no log, 1 a summary at convergence, 2 print main
%     steps (default: 1)
%
%    param.weights : weights for a weighted L1-norm (default = 1)
%
%
%   info is a Matlab structure containing the following fields:
%
%    info.algo : Algorithm used
%
%    info.iter : Number of iteration
%
%    info.time : Time of exectution of the function in sec.
%
%    info.final_eval : Final evaluation of the function
%
%    info.crit : Stopping critterion used 
%
%
%   See also: gsp_prox_l2_filterbank gsp_norm_l1_filterbank gsp_prox_tv
%
%
%   Url: https://epfl-lts2.github.io/gspbox-html/doc/prox/gsp_prox_l1_filterbank.html

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
% Date: 25 March 2014
%




if nargin < 3
    error('GSP_PROX_TV: You need to provide a graph!');
end

if nargin < 4, param=struct; end

if ~isfield(param, 'verbose'), param.verbose = 1; end
if ~isfield(param, 'tight'), param.tight = 0; end
if ~isfield(param, 'tol'), param.tol = 1e-3; end
if ~isfield(param, 'maxit'), param.maxit = 200; end
if ~isfield(param, 'weights'), param.weights = 1; end

% setting the function ftv

if ~isfield(G,'lmax')
    G = gsp_estimate_lmax(G);
    warning(['GSP_PROX_TV: To be more efficient you should run: ',...
        'G = gsp_estimate_lmax(G); before using this proximal operator.']);
end

[~, B] = gsp_filterbank_bounds(G,W);

param_l1.tight = param.tight;
param_l1.maxit = param.maxit;
param_l1.nu =  B;
param_l1.A = @(x) gsp_filter_analysis(G,W,x);
param_l1.At = @(x) gsp_filter_synthesis(G,W,x);
param_l1.verbose = param.verbose;


[sol,info] = prox_l1(x,gamma,param_l1);

info.algo=mfilename;



end







