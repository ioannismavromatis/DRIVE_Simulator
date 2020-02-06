% test_segments_intersect
% =======================
%
% Test routine for segment intersections MEX routines.
% TODO: expand including multiple cases, etc.
%
% by Francesco Montorsi, 05/03/2012
%
function test_segments_intersect

    clc;
    close all;
    
    figure; hold all;

    
    % TESTS FOR segment_intersect_test VARIANT
    
    assert(segment_intersect_test([0 0], [10 10], [5 -5], [5 5]) == 1);
    
    
    
    % TESTS FOR X-ALIGNED SEGMENTS
    
    segment1_test = [10 10 20 10];      % as [x1 y1  x2 y2]
    segment2_test = [22 10 35 10];      % as [x1 y1  x2 y2]
    draw_segments(segment1_test, segment2_test);
    assert(segments_intersect_test(segment1_test, segment2_test) == 0);
    
    segment1_test = [10 10 20 10];      % as [x1 y1  x2 y2]
    segment2_test = [12 10 35 10];      % as [x1 y1  x2 y2]
    draw_segments(segment1_test, segment2_test);
    assert(segments_intersect_test(segment1_test, segment2_test) == -1);


    % TESTS FOR Y-ALIGNED SEGMENTS
    
    segment1_test = [10 -10 10 -20];      % as [x1 y1  x2 y2]
    segment2_test = [10 -21 10 -23];      % as [x1 y1  x2 y2]
    draw_segments(segment1_test, segment2_test);
    assert(segments_intersect_test(segment1_test, segment2_test) == 0);
    
    segment1_test = [13 -10 13 -5];      % as [x1 y1  x2 y2]
    segment2_test = [13 -1 13 -4];      % as [x1 y1  x2 y2]
    draw_segments(segment1_test, segment2_test);
    assert(segments_intersect_test(segment1_test, segment2_test) == 0);

    
    
    % TESTS FOR SEGMENTS WITH ANGULAR COEFFICIENT = 1

    segment1_test = [30 30 34 34];      % as [x1 y1  x2 y2]
    segment2_test = [35 35 38 38];      % as [x1 y1  x2 y2]
    draw_segments(segment1_test, segment2_test);
    assert(segments_intersect_test(segment1_test, segment2_test) == 0);


    segment1_test = [30 30 34 34];      % as [x1 y1  x2 y2]
    segment2_test = [30 30 38 38];      % as [x1 y1  x2 y2]
    draw_segments(segment1_test, segment2_test);
    assert(segments_intersect_test(segment1_test, segment2_test) == -1);

        % segments with a endpoint in common give -1:
    segment1_test = [34 34 25 25];      % as [x1 y1  x2 y2]
    segment2_test = [34 34 38 38];      % as [x1 y1  x2 y2]
    draw_segments(segment1_test, segment2_test);
    assert(segments_intersect_test(segment1_test, segment2_test) == -1);

    segment1_test = [34 34 25 25];      % as [x1 y1  x2 y2]
    segment2_test = [27 15 27 38];      % as [x1 y1  x2 y2]
    draw_segments(segment1_test, segment2_test);
    assert(segments_intersect_test(segment1_test, segment2_test) == 1);

    
    
    
    % MIXED TESTS
    
    poly = [
         3     3
         3    33
        25    33
        25    25
        33    25
        33    24
        22    24
        22    32
        19    32
        19    15
        22    15
        22    21
        25    21
        25    15
        28    15
        28    21
        33    21
        33    20
        31    20
        31    14
        16    14
        16    29
        12    29
        12    23
         5    23
         5    19
        12    19
        12    10
        31    10
        31     8
         9     8
         9    16
         5    16
         5     4
        30     4
        30     5
        36     5
        36     3 ];

    segments = [ poly circshift(poly,[-1 0]) ];    
    draw_polygons(poly);
    
    segment_test = [6 5 10 5];      % as [x1 y1  x2 y2]
    plot([segment_test(1) segment_test(3)], ...
         [segment_test(2) segment_test(4)], '-^');
    assert(segments_intersect_test(segments, segment_test) == 0);
    
    
    segment_test = [6 5 10 35];      % as [x1 y1  x2 y2]
    plot([segment_test(1) segment_test(3)], ...
         [segment_test(2) segment_test(4)], '-^');
    assert(segments_intersect_test(segments, segment_test) == 4);

    
    
    % TESTS FOR segment_intersect_test_vector VARIANT
    
    figure; hold all;
    segment1_test(1,:) = [10 10 30 10];      % as [x1 y1  x2 y2]
    segment1_test(2,:) = [10 12 20 12];      % as [x1 y1  x2 y2]
    segment2_test = [22 6 35 16];      % as [x1 y1  x2 y2]
    draw_segments(segment1_test(1,:), segment2_test);
    draw_segments(segment1_test(2,:), segment2_test);
    out = segments_intersect_test_vector(segment1_test, segment2_test);
    assert(out(1) == 1 && out(2) == 0);
    
    
    fprintf('ALL TESTS OK\n');
    
    
    function draw_segments(segment1_test, segment2_test)
        plot([segment1_test(1) segment1_test(3)], ...
             [segment1_test(2) segment1_test(4)], '-^');
        plot([segment2_test(1) segment2_test(3)], ...
             [segment2_test(2) segment2_test(4)], '-^');
    end
    
    function h = draw_polygons(poly_pts)
        h = figure;
        hold all;
        
        % close the polygon repeating the first point at the end
        if sum(poly_pts(end,:) == poly_pts(1,:)) ~= 2
            poly_pts = [ poly_pts ; poly_pts(1,:) ];
        end

        plot(poly_pts(:,1), poly_pts(:,2), '-*', 'DisplayName', 'Map Boundaries');
        for idxx = 1:size(poly_pts,1)
            text(poly_pts(idxx,1),poly_pts(idxx,2),sprintf('%d',idxx));
        end
    end
end