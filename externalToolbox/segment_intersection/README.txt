 segment(s)_intersect_test(_vector)  README
 ============================================
 
 by Francesco Montorsi, 06/03/2012, version 1.0 
 
 These routines count the number of intersections among 2-D segments.
 
 Syntax of the routines is:
 
 1) segment_intersect_test:
 
        n_intersections = segment_intersect_test(p1, p2, p3, p4);
    where:
        p1-p2 = first segment endpoints (as 1x2 matrices)
        p3-p4 = second segment endpoints (as 1x2 matrices)
        n_intersections = 0 (no intersection), 1 (they do intersect),
                          -1 if the segments have infinite intersections (e.g. they overlap).
 
 
 2) segments_intersect_test:
 
        n_intersections = segments_intersect_test(XY1, XY2);
    where
        XY1 = segments to check against the segments of XY2 (Nx4 matrix with each row containing [x1 y1 x2 y2])
        XY2 = segments to check against the segments of XY1 (Mx4 matrix with each row containing [x1 y1 x2 y2])
        n_intersections = number of detected intersections or 
                          -1 if some segment pair has infinite intersections (e.g. they overlap).
 
 3) segments_intersect_test_vector:
 
        intersec_vector = segments_intersect_test_vector(XY1, XY2);
    where
        XY1 = segments to check against the segments of XY2 (Nx4 matrix with each row containing [x1 y1 x2 y2])
        XY2 = segments to check against the segments of XY1 (Mx4 matrix with each row containing [x1 y1 x2 y2])
        intersec_vector = Nx1 vector of detected intersections for each segment of XY1... that is, 
                          intersec_vector(i) is the number of intersections of the i-th segment of XY1 with the
                                             segments of XY2 or -1 if the i-th segment of XY1 has infinite 
                                             intersections with some segment of set XY2 (e.g. they overlap).
 
 
 The MATLAB file test_segments_intersect.m contains some simple code which I used to test the
 routines and should also give an idea of the way you can use these functions.
 
 Implementation of the routines is in MEX C code, so that the routines are pretty fast.
 Precompiled binaries cannot be provided due to FileExchange restrictions.
 However the code was compiled and tested under the following platforms:
 - Windows 7 64bit, compiled with Visual Studio 2008
 - GNU/Linux (Ubuntu 11.04) x86_64, compiled with gcc 4.6.1

 To compile the code you just need to issue, from the MATLAB prompt, the following commands:

    mex -v segment_intersect_test.c
    mex -v segments_intersect_test.c
    mex -v segments_intersect_test_vector.c

 (Of course you need to run the commands from the right path, i.e. you need to first select
  as "current folder" the folder containing the C files.)
 Note that you need a C compiler compatible with the MEX MATLAB utility.


 Credits go to:
 - U. Murat Erdem for writing its "Fast Line Segment Intersection" code (as MATLAB function)
     http://www.mathworks.it/matlabcentral/fileexchange/27205-fast-line-segment-intersection
   which I started using (note that the calling syntax of segments_intersect_test routine is
   exactly the same of its routine!)
   
 - Gavin, for his post on
      http://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
   the code he posted is taken from:
      Andre LaMothe, "Tricks of the Windows Game Programming Gurus (2nd Edition)", 
      2 edition (June 29, 2002), ISBN 978-0672323690, Sams.
      
   Note that basically the same code is available at:
      http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/pdb.c
     
 Finally note that I added all the "odd case" handling code (e.g. for the case where segments are collinear)
 to the functions and wrote the test routines.
 
 
 