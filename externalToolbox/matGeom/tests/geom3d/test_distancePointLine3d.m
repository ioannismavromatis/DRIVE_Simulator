function test_suite = test_distancePointLine3d
%TESTDISTANCEPOINTLINE3D  One-line description here, please.
%   output = testDistancePointLine3d(input)
%
%   Example
%   testDistancePointLine3d
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-06-19,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.

test_suite = functiontests(localfunctions); 

function testOx(testCase) %#ok<*DEFNU>

% line parallel to Ox axis
point   = [10 10 10];
line    = [10 20 30 10 0 0];
dist    = distancePointLine3d(point, line);
testCase.assertEqual(hypot(10, 20), dist, 'AbsTol', .01);
