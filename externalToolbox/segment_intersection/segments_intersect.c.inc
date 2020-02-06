/*
    segments_intersect.c.inc: simple code to be included in a MEX file
    by Francesco Montorsi, 06/03/2012
*/

#include <math.h>
#include "mex.h"
#include "matrix.h"
#include "float.h"      /* for DBL_EPSILON */


/*
   PREPROCESSOR
*/

#ifndef FALSE
#define FALSE                   (0)
#endif

#ifndef TRUE
#define TRUE                    (1)
#endif

#ifndef ENABLE_DEBUG_PRINTF
#define ENABLE_DEBUG_PRINTF     (0)
#endif

#define EPS                     (10*DBL_EPSILON)


/*
    Returns 1 if the two segments intersect, 
            0 if the segments have no intersection,
            -1 if the segments have infinite intersections (e.g. they overlap). 
*/
int segment_intersect(double p0_x, double p0_y, double p1_x, double p1_y, 
                      double p2_x, double p2_y, double p3_x, double p3_y) 
                       /*, double *i_x, double *i_y) */
{
    /* 
       taken from http://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
       which is again taken from:
          Andre LaMothe, "Tricks of the Windows Game Programming Gurus (2nd Edition)", 
          2 edition (June 29, 2002), ISBN 978-0672323690, Sams.
          
        Note that basically the same code is available at:
          http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/pdb.c
          
        Finally note that I added all the "odd case" handling code
        (e.g. for the case where segments are collinear).
    */

    double s1_x, s1_y, s2_x, s2_y;
    double numa, numb, den;
    double s, t;
    
    s1_x = p1_x - p0_x;     s1_y = p1_y - p0_y;
    s2_x = p3_x - p2_x;     s2_y = p3_y - p2_y;
    
    den = -s2_x * s1_y + s1_x * s2_y;
        /* note that this denominator can be written as 
                s1_x*s2_x*( s2_m - s1_m)
           where s1_m is the angular coefficient of the first segment and
                 s2_m is the angular coefficient of the second segment.
           
           This means that den = 0 if s1_m = s2_m (parallel/coincident segments);
           moreover, den = 0 also when the angular coefficient of both is +INF because
           both the segments are y-aligned.
        */
    
    numa = -s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y);
    numb = +s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x);
    if (fabs(den) < EPS)
    {
        if (fabs(numa) < EPS && fabs(numb) < EPS)
        {
            /* the two segments are collinear... check if they do intersect by projecting them on one axis */
            if (fabs(s1_y) < EPS)
            {
                double s1_leftmost,s1_rightmost, s2_leftmost,s2_rightmost;
                
                /* segments are parallel to the x axis... project them on x */
                s1_leftmost = (p0_x < p1_x) ?  p0_x : p1_x;
                s1_rightmost = (p0_x >= p1_x) ?  p0_x : p1_x;
#if ENABLE_DEBUG_PRINTF
                mexPrintf("segment1: (%.2f;%.2f)-(%.2f;%.2f)\n", s1_leftmost, p0_y, s1_rightmost, p1_y);
                mexPrintf("segment1: (%.2f;%.2f)-(%.2f;%.2f)\n", p2_x, p2_y, p3_x, p3_y);
                mexPrintf("the segments are collinear and parallel to the x axis... checking for intersections\n");
#endif
                if ((s1_leftmost <= p2_x && p2_x <= s1_rightmost) ||
                     (s1_leftmost <= p3_x && p3_x <= s1_rightmost))
                     return -1;
                     
                /* last possibility to check: segment 1 maybe entirely contained in segment 2 */
                s2_leftmost = (p2_x < p3_x) ?  p2_x : p3_x;
                s2_rightmost = (p2_x >= p3_x) ?  p2_x : p3_x;
#if ENABLE_DEBUG_PRINTF
                mexPrintf("segment1: (%.2f;%.2f)-(%.2f;%.2f)\n", s1_leftmost, p0_y, s1_rightmost, p1_y);
                mexPrintf("segment1: (%.2f;%.2f)-(%.2f;%.2f)\n", s2_leftmost, p2_y, s2_rightmost, p3_y);
                mexPrintf("the segments are collinear and parallel to the x axis... checking for intersections\n");
#endif
                if ((s2_leftmost <= p0_x && p0_x <= s2_rightmost) ||
                     (s2_leftmost <= p1_x && p1_x <= s2_rightmost))
                     return -1;
                     
                return 0;
            }
            else
            {
                double s1_bottommost,s1_upmost, s2_bottommost,s2_upmost;
                
                /* segments are parallel to the x axis... project them on x */
                s1_bottommost = (p0_y < p1_y) ?  p0_y : p1_y;
                s1_upmost = (p0_y >= p1_y) ?  p0_y : p1_y;
#if ENABLE_DEBUG_PRINTF
                mexPrintf("segment1: (%.2f;%.2f)-(%.2f;%.2f)\n", s1_bottommost, p0_y, s1_upmost, p1_y);
                mexPrintf("segment1: (%.2f;%.2f)-(%.2f;%.2f)\n", p2_y, p2_y, p3_y, p3_y);
                mexPrintf("the segments are collinear but NOT parallel to the x axis... checking for intersections\n");
#endif
                if ((s1_bottommost <= p2_y && p2_y <= s1_upmost) ||
                     (s1_bottommost <= p3_y && p3_y <= s1_upmost))
                     return -1;
                     
                /* last possibility to check: segment 1 maybe entirely contained in segment 2 */
                s2_bottommost = (p2_y < p3_y) ?  p2_y : p3_y;
                s2_upmost = (p2_y >= p3_y) ?  p2_y : p3_y;
#if ENABLE_DEBUG_PRINTF
                mexPrintf("segment1: (%.2f;%.2f)-(%.2f;%.2f)\n", s1_bottommost, p0_y, s1_upmost, p1_y);
                mexPrintf("segment1: (%.2f;%.2f)-(%.2f;%.2f)\n", s2_bottommost, p2_y, s2_upmost, p3_y);
                mexPrintf("the segments are collinear but NOT parallel to the x axis... checking for intersections\n");
#endif
                if ((s2_bottommost <= p0_y && p0_y <= s2_upmost) ||
                     (s2_bottommost <= p1_y && p1_y <= s2_upmost))
                     return -1;
                     
                return 0;
            }
        }
        else
        {
#if ENABLE_DEBUG_PRINTF
            mexPrintf("segment1: (%.2f;%.2f)-(%.2f;%.2f)\n", p0_x, p0_y, p1_x, p1_y);
            mexPrintf("segment1: (%.2f;%.2f)-(%.2f;%.2f)\n", p2_x, p2_y, p3_x, p3_y);
            mexPrintf("the segments are parallel but not collinear\n");
#endif
            return 0;   /* the two segments are parallel (no intersection)... */
        }
    }

    s = numa / den;
    t = numb / den;

    if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
    {
        /* these lines would provide the intersection point (I'm not interested in it,however)
        if (i_x != NULL)
            *i_x = p0_x + (t * s1_x);
        if (i_y != NULL)
            *i_y = p0_y + (t * s1_y);
        */
        return 1;
    }

    return 0;
}

