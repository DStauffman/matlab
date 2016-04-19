classdef(Enumeration) Gender < int32

% Gender is a enumerator class definition for the possible genders.
%
% Input:
%     None
%
% Output:
%     Gender ....... : (enum) possible values
%         null   = 0 : not a valid setting, used to preallocate
%         female = 1 : female
%         male   = 2 : male
%
% Prototype:
%     Gender.female         % returns female as an enumeratod Gender type
%     double(Gender.female) % returns 1, which is the enumerated value of Gender.female
%     char(Gender.female)   % returns 'female' as a character string
%     class(Gender.female)  % returns 'Gender' as a character string
%
% Methods:
%     is_female : returns a boolean for whether the person is female or not.
%     is_male   : returns a boolean for whether the person is male or not.
%
% Change Log:
%     1.  Written by David C. Stauffer in June 2013.
%     2.  Added to DStauffman MATLAB library in December 2015.
%     3.  Updated by David C. Stauffer in April 2016 to include methods for determing male/female.

    enumeration
        null(0)
        female(1)
        male(2)
        uncirc_male(3)
        circ_male(4)
    end

    methods
        function out = is_female(obj)
            out = obj == Gender.female;
        end
        function out = is_male(obj)
            out = obj == Gender.male | obj == Gender.uncirc_male | obj == Gender.circ_male; % more explicit
            % out = obj > 0 & obj ~= 1; % slightly faster option
        end
    end
end