function test_suite = test_normalizeVector3d
%TESTNORMALIZEVECTOR3D  One-line description here, please.
%
%   output = testNormalizeVector3d(input)
%
%   Example
%   testNormalizeVector3d
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

test_suite = functiontests(localfunctions); 

function testOrthoVectors(testCase) %#ok<*DEFNU>

vec1    = [3 0 0];
exp1    = [1 0 0];
norm1   = normalizeVector3d(vec1);
testCase.assertEqual(exp1, norm1);

vec2    = [0 3 0];
exp2    = [0 1 0];
norm2   = normalizeVector3d(vec2);
testCase.assertEqual(exp2, norm2);

vec3    = [0 0 3];
exp3    = [0 0 1];
norm3   = normalizeVector3d(vec3);
testCase.assertEqual(exp3, norm3);

function testDiagoVector(testCase)

vec = [6 8 0];
norm = normalizeVector3d(vec);
exp = [3/5 4/5 0];
testCase.assertEqual(exp, norm);

vec = [0 6 8];
norm = normalizeVector3d(vec);
exp = [0 3/5 4/5];
testCase.assertEqual(exp, norm);


function testArray(testCase)

vecs = [2 0 0;0 3 0;0 0 4];
exp = [1 0 0;0 1 0;0 0 1];
norm = normalizeVector3d(vecs);
testCase.assertEqual(exp, norm);

vecs = [2 0 0;0 3 0;0 0 4;3 0 4];
exp = [1 0 0;0 1 0;0 0 1;3/5 0 4/5];
norm = normalizeVector3d(vecs);
testCase.assertEqual(exp, norm);

