function [] = yscale_plots(figs, prefix_old, prefix_new)

% YSCALE_PLOTS  rescales yaxis units and vectors for single axis figures.
%
% Summary:
%    1.  Determines children of figure handles.
%    2.  Children that are not tagged as legends and that
%        also maintain a ylabel property are presumed to be
%        plot axis handles and are added to a list.
%    3.  Children of plot axis handles are presumed to express
%        vector plot data (xdata & ydata fields).
%    4.  Function confirms all plot axis ylabels and when
%        it has successful determines scale factor needed to convert
%        to new basis then scales all vector plot data and
%        modifies all plot axis ylabels.
%    5.  Care is taken to replace only that portion of xlabel
%        strings that specify some units using [units].
%    6.  For compatability with manual yextents, this function also rescales
%        yaxis extents if they have been manually established.
%
% Input:
%     figs       : (scalar) or (column) or (row) figure handles [num]
%     prefix_old : (row) existing xaxis unit [enum] see note 1
%     prefix_new : (row) replacement xaxis unit [enum] see note 1
%
% Output:
%     None
%
% Prototype:
%     f1 = figure(5);
%     hold on;
%     plot(linspace(0,3600), 1e-6*(0.1+randn(1,100)), 'r');
%     plot(linspace(0,3600), 1e-6*(0.2+randn(1,100)), 'b');
%     plot(linspace(0,3600), 1e-6*(0.3+ones(1,100)), 'g');
%     plot([0 3600], [1.3e-6 1.3e-6], 'ko');
%     legend('r', 'b', 'g');
%     xlabel('something [sec]');
%     ylabel('something [rad]');
%     figmenu;
%
%     f2 = figure(6);
%     hold on;
%     plot(linspace(0,3600), 1e-6*(0.1+randn(1,100)), 'r');
%     plot(linspace(0,3600), 1e-6*(0.2+randn(1,100)), 'b');
%     plot(linspace(0,3600), 1e-6*(0.3+ones(1,100)), 'g');
%     plot([0 3600], [1.3e-6 1.3e-6], 'ko');
%     legend('r', 'b', 'g');
%     xlabel('something [sec]');
%     ylabel('something [m]');
%     figmenu;
%
%     xscale_plots([f1 f2],'[sec]','[min]');
%     yscale_plots([f1 f2],'unity','micro');
%
%     % clean up
%     close([f1 f2]);
%
% See Also:
%     figmenu, setup_plots, storefig, titleprefix, xextents, xscale_plots
%
% Notes:
%     1.  Allowable prefixes are from any standard metric prefix:
%             % DCS - yes, I realize this list is probably overkill
%             'yotta','zetta','exa','peta','tera','giga','mega',
%             'kilo','hecto','deca','unity','deci','centi','milli',
%             'micro','nano','pico','femto','atto','zepto','yocto'
%
% Change Log:
%     1.  Written by David Stauffer in Nov 2012.
%     3.  Incorporated by David C. Stauffer into DStauffman library in Nov 2016.

%% hard-coded values
% units to exclude from scaling
exclusions = {'[dimensionless]','[normalized]','[ndim]','[%]','\sigma'};

%% determine conversion factor and string prefixes to replace
% get factors and labels
[mult_old, label_old] = get_factors(prefix_old);
[mult_new, label_new] = get_factors(prefix_new);
% find the new effective multiplication factor
mult = mult_old / mult_new;

%% verify existing axis units
cnt = 1;
for hfig = figs
    % check if this is a valid figure handle
    if ~ishandle(hfig)
        warning('dstauffman:YScaleFig', 'Invalid figure handle specified: "%s"', hfig);
        return
    end
    % check that the figure has a valid axis child
    haxs = get(hfig,'children');
    if isempty(haxs)
        warning('dstauffman:YScaleChildren', 'Specified figure does not contain axis.');
        return
    end
    % loop through children axes
    for a = 1:length(haxs)
        % permit if ylabel property exists
        try
            hyut = get(haxs(a), 'ylabel');
        catch exception
            if strcmp(exception.identifier, 'MATLAB:class:InvalidProperty') || ...
                    strcmp(exception.identifier, 'MATLAB:hg:InvalidProperty')
                hyut = [];
            else
                rethrow(exception);
            end
        end
        % permit when ylabel property is not child to axis tagged as legend
        if strcmp('legend', get(haxs(a), 'tag'))
            hyut = [];
        end
        % accumulate permitted axes
        if ~isempty(hyut)
            yunit{cnt,1} = get(hyut,'string'); %#ok<AGROW>
            cnt = cnt+1;
        end
    end
end
% confirm that at least one permitted axes has the desired string
ixs = strfind(yunit,['[',label_old]);
arr = cellfun(@(x) ~isempty(x),ixs);
if ~all(arr)
    warning('dstauffman:YScaleLabel', 'invalid ''ylabel'' property ''string'' exists.');
    return
end

%% rescale units
for hfig = figs
    haxs = get(hfig, 'children');
    for a = 1:length(haxs)
        % permit if ylabel property exists
        try
            hyut = get(haxs(a), 'ylabel');
        catch exception
            if strcmp(exception.identifier, 'MATLAB:class:InvalidProperty') || ...
                    strcmp(exception.identifier, 'MATLAB:hg:InvalidProperty')
                hyut = [];
            else
                rethrow(exception);
            end
        end
        % permit when ylabel property is not child to axis tagged as legend
        if strcmp('legend',get(haxs(a),'tag'))
            hyut = [];
        end
        % modify permitted
        if ~isempty(hyut)
            % get ylabel
            yunt   = get(haxs(a),'ylabel');
            ystr   = get(yunt,'string');
            % check for exclusions
            skip   = false;
            for e = 1:length(exclusions)
                if ~isempty(strfind(ystr,exclusions{e}))
                    skip = true;
                end
            end
            if skip
                break
            end
            % modify axis ylabel
            newstr = strrep(ystr, ['[',label_old], ['[',label_new]);
            set(yunt, 'string', newstr);
            % get y data
            hvec = get(haxs(a), 'children');
            ydat = findobj(hvec, '-property', 'ydata');
            % scale vector data
            for i = 1:length(ydat)
                ydat_scaled = get(ydat(i), 'ydata')*mult;
                set(ydat(i), 'ydata', ydat_scaled);
            end
            % rescale established xaxis extents
            if strcmp(get(haxs(a), 'ylimmode'), 'manual')
                set(haxs(a), 'ylim', [min(min(ydat_scaled)), max(max(ydat_scaled))]);
            end
        end
    end
end

%% Subfunctions
function [mult,label] = get_factors(prefix)

% GET_FACTORS  gets the multiplication factor and unit label for the desired units.
%
% SUMMARY:
%     (NONE)
%
% INPUT:
%     prefix : (row) string specifying the unit standard metric prefix
%                    from: {'yotta','zetta','exa','peta','tera','giga','mega',
%                           'kilo','hecto','deca','unity','deci','centi','milli',
%                           'micro','nano','pico','femto','atto','zepto','yocto'}
%
% OUTPUT:
%     mult   : (scalar) multiplication factor [num]
%     label  : (row) string abbreviation for the prefix [char]
%
% REFERENCE:
%     1.  http://en.wikipedia.org/wiki/Metric_prefix

% find the desired units and label prefix
switch prefix
    case 'yotta'
        mult  = 1e24;
        label = 'Y';
    case 'zetta'
        mult  = 1e21;
        label = 'Z';
    case 'exa'
        mult  = 1e18;
        label = 'E';
    case 'peta'
        mult  = 1e15;
        label = 'P';
    case 'tera'
        mult  = 1e12;
        label = 'T';
    case 'giga'
        mult  = 1e9;
        label = 'G';
    case 'mega'
        mult  = 1e6;
        label = 'M';
    case 'kilo'
        mult  = 1e3;
        label = 'k';
    case 'hecto'
        mult  = 1e2;
        label = 'h';
    case 'deca'
        mult  = 1e1;
        label = 'da';
    case 'unity'
        mult  = 1;
        label = '';
    case 'deci'
        mult  = 1e-1;
        label = 'd';
    case 'centi'
        mult  = 1e-2;
        label = 'c';
    case 'milli'
        mult  = 1e-3;
        label = 'm';
    case 'micro'
        mult  = 1e-6;
        label = '\mu';
    case 'nano'
        mult  = 1e-9;
        label = 'n';
    case 'pico'
        mult  = 1e-12;
        label = 'p';
    case 'femto'
        mult  = 1e-15;
        label = 'f';
    case 'atto'
        mult  = 1e-18;
        label = 'a';
    case 'zepto'
        mult  = 1e-21;
        label = 'z';
    case 'yocto'
        mult  = 1e-24;
        label = 'y';
    otherwise
        error('dstauffman:InvalidPrefix', 'Unexpected value for units prefix: "%s".', prefix);
end