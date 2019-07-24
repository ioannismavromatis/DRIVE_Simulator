function test_suite = test_parametrize
%TESTPARAMETRIZE  One-line description here, please.
%
%   output = testParametrize(input)
%
%   Example
%   testParametrize
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-05-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

test_suite = functiontests(localfunctions); 

function testSquare(testCase) %#ok<*DEFNU>
% Tests with a square of perimeter 40
p1 = [10 10];
p2 = [20 10];
p3 = [20 20];
p4 = [10 20];
square = [p1;p2;p3;p4];
exp = [0;10;20;30];

testCase.assertEqual(exp, parametrize(square));

function testSquare3d(testCase)
% Tests with a square of perimeter 40
p1 = [10 10 0];
p2 = [20 10 0];
p3 = [20 20 0];
p4 = [10 20 0];
square = [p1;p2;p3;p4];
exp = [0;10;20;30];

testCase.assertEqual(exp, parametrize(square));

function testSquareNormaized(testCase) %#ok<*DEFNU>
% Tests with a square of perimeter 40
p1 = [10 10];
p2 = [20 10];
p3 = [20 20];
p4 = [10 20];
square = [p1;p2;p3;p4;p1];
exp = [0;.25;.5;.75;1];

testCase.assertEqual(exp, parametrize(square, 'normalize', true));
