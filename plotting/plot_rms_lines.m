function plot_rms_lines(x,y)

% PLOT_RMS_LINES  plots a vertical line at the RMS start and stop times.
%
% Summary:
%     There are two vertical lines created.  The first at x(1) and the second at x(2).
%     The first line is orange, and the second is lavender.  Both have magenta crosses at
%     the top and bottom.  The lines are added to the plot regardless of the figure hold state.
%
% Input:
%     x : (1x2) vector of xmin and xmax values at which to draw the lines [num]
%     y : (1x2) vector of ymin and ymax values at which to extend the lines vertically [num]
%
% Output:
%     (NONE)
%
% Prototype:
%     f1 = figure;
%     plot(1:10,1:10);
%     plot_rms_lines([2 5],[1 10]);
%
%     % clean up
%     close(f1);
%
% Change Log:
%     1.  Added to DStauffman's MATLAB libary from GARSE in Sept 2013.

% initial figure hold state
hold_state = ishold;
hold on;

% Bug in Matlab when using MarkerEdgeColor and the plotbrowser (for R2014A (8.3) to R2015B (9.6), fixed in R2016A (9.0)):
if ~verLessThan('matlab', '9.0') || verLessThan('matlab','8.3')
    plot([x(1) x(1)],y,'LineStyle','--','Color',[   1 0.75 0],'Marker','+','MarkerEdgeColor','m','MarkerSize',10,'DisplayName','RMS Start Time');
    plot([x(2) x(2)],y,'LineStyle','--','Color',[0.75 0.75 1],'Marker','+','MarkerEdgeColor','m','MarkerSize',10,'DisplayName','RMS Stop Time');
else
    plot([x(1) x(1)],y,'LineStyle','--','Color',[   1 0.75 0],'Marker','+','MarkerSize',10,'DisplayName','RMS Start Time');
    plot([x(2) x(2)],y,'LineStyle','--','Color',[0.75 0.75 1],'Marker','+','MarkerSize',10,'DisplayName','RMS Stop Time');
end

% reset hold state if it wasn't previously set
if ~hold_state
    hold off;
end