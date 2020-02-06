/*

    segment_intersect_test.c
        optimized segment intersection test
    by Francesco Montorsi, 06/03/2012

    Build this MEX file by entering the appropriate command at the MATLAB prompt:
        mex -v segment_intersect_test.c
        
    Usage in MATLAB:
       
        n_intersections = segment_intersect_test(p1, p2, p3, p4);
        
    where
    
        p1-p2 = first segment endpoints (as 1x2 matrices)
        p3-p4 = second segment endpoints (as 1x2 matrices)
        n_intersections = 0 (no intersection), 1 (they do intersect),
                          -1 if the segments have infinite intersections (e.g. they overlap).
        
        
    TESTS (to be run in MATLAB):
    
        assert(segment_intersect_test([0 0], [10 0], [5 -5], [5 +5]) == 1);
        assert(segment_intersect_test([0 0], [10 0], [15 -5], [15 +5]) == 0);
        
        
    To unload the resulting MEX file from MATLAB run:
    
        clear segment_intersect_test
*/

#include <math.h>
#include "mex.h"
#include "matrix.h"
#include "float.h"      /* for DBL_EPSILON */

#define ENABLE_DEBUG_PRINTF     (0)

#include "segments_intersect.c.inc"


/* the gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    const double *p1, *p2, *p3, *p4;

    /* check for proper number of arguments */
    /* NOTE: You do not need an else statement when using mexErrMsgTxt
     within an if statement, because it will never get to the else
     statement if mexErrMsgTxt is executed. (mexErrMsgTxt breaks you out of
     the MEX-file) */
    if (nrhs!=4) 
        mexErrMsgTxt("Four input points required.");
    if (nlhs!=1) 
        mexErrMsgTxt("One output required.");

    /* check to make sure the second input argument is a vector correctly sized */
    if (mxGetM(prhs[0]) != 1 || mxGetN(prhs[0]) != 2 ||        /* first point */ 
        mxGetM(prhs[1]) != 1 || mxGetN(prhs[1]) != 2 ||        /* second point */ 
        mxGetM(prhs[2]) != 1 || mxGetN(prhs[2]) != 2 ||        /* third point */ 
        mxGetM(prhs[3]) != 1 || mxGetN(prhs[3]) != 2)          /* fourth point */ 
        mexErrMsgTxt("Input points should be 1x2 matrices (x y).");

    /*  get pointers to the inputs */
    p1 = mxGetPr(prhs[0]);
    p2 = mxGetPr(prhs[1]);
    p3 = mxGetPr(prhs[2]);
    p4 = mxGetPr(prhs[3]);

    /*  the output is just a scalar */
    plhs[0] = mxCreateDoubleScalar(segment_intersect(p1[0],p1[1], p2[0],p2[1], p3[0],p3[1], p4[0],p4[1]));
}
