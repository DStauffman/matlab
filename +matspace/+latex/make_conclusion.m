function [out] = make_conclusion(use_mini)

% MAKE_CONCLUSION  Write closing tags at the end of the table.
%
% Input:
%     use_mini : |opt| (scalar), true/false flag for whether to conclude the table as part of a
%                                minipage, default is false
%
% Output:
%     out : (1xN) string, LaTeX text to build the table footer, where each entry in the list is a
%                         row of text in the document.
% Prototype:
%     out = matspace.latex.make_conclusion();
%     assert(all(out == ["        \bottomrule"; "    \end{tabular}"; "\end{table}"; ""]));
%
% Change Log:
%     1.  Ported from Python to Matlab by David C. Stauffer in January 2018.
%     2.  Updated by David C. Stauffer in April 2020 to put into a package.

% optional inputs
switch nargin
    case 0
        use_mini = false;
    case 1
        % nop
    otherwise
        error('matspace:UnexpectedNargin', 'Unexpected number of inputs: "%i"', nargin);
end

% create output
if ~use_mini
    out = ["        \bottomrule"; "    \end{tabular}"; "\end{table}"; ""];
else
    out = ["            \bottomrule"; "        \end{tabular}"; "    \end{minipage}"; "\end{table}"; ""];
end