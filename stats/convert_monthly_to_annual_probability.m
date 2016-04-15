function [annual] = convert_monthly_to_annual_probability(monthly)

% CONVERT_MONTHLY_TO_ANNUAL_PROBABILITY  converts a given monthly probability into the
%     equivalent annual one.
%
% Input:
%     monthly : (1xN) monthly probability [ndim]
%
% Output:
%     annual : (1xN) annual probability [ndim]
%
% Prototype:
%     monthly = [0, 0.1, 1];
%     annual  = convert_monthly_to_annual_probability(monthly);
%     assert(all(abs(annual - [0, 0.71757046, 1]) < 1e-7));
%
% Change Log:
%     Written by David C. Stauffer in April 2016.

% hard-coded values
MONTHS_PER_YEAR = 12;

% calculate annual probability
annual = 1 - (1 - monthly).^MONTHS_PER_YEAR;