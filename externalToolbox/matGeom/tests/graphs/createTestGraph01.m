function [nodes, edges, values] = createTestGraph01(varargin)
%CREATETESTGRAPH01  One-line description here, please.
%
%   output = createTestGraph01(input)
%
%   Example
%   createTestGraph01
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-05-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

nodes = [ ...
    290 250; ...
    200 300; ...
    100 300; ...
    100 200; ...
    200 200; ...
    240 110; ...
    330 160; ...
    420 200];

edges = [...
    1 2; ...
    1 5; ...
    1 7; ...
    2 3; ...
    2 5; ...
    3 4; ...
    4 5; ...
    5 6; ...
    6 7; ...
    7 8];

values = [80;10; 70; 60; 50; 20; 30; 40];
