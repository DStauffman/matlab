classdef test_bin2hex < matlab.unittest.TestCase %#ok<*PROP>

    % Tests the bin2hex function with the following cases:
    %     Nominal
    %     lower case
    %     upper case
    %     padded every 4
    %     padded every 8
    %     small char arrays
    %     small string arrays
    %     less than one hex
    %     empty x2
    %     combined options
    %     cell array
    %     string array
    %     bad inputs x3

    properties
        bin,
        hex
    end

    methods (TestMethodSetup)
        function initialize(self)
            self.bin = '0000 0001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100 1101 1110 1111';
            self.hex = '0123456789ABCDEF';
        end
    end

    methods (Test)
        function test_nominal(self)
            hex = matspace.utils.bin2hex(self.bin);
            self.verifyEqual(hex, self.hex);
        end

        function test_lower(self)
            hex = matspace.utils.bin2hex(self.bin, 'lower');
            self.verifyEqual(hex, lower(self.hex));
        end

        function test_upper(self)
            hex = matspace.utils.bin2hex(self.bin, 'upper');
            self.verifyEqual(hex, upper(self.hex));
        end

        function test_pad4(self)
            hex = matspace.utils.bin2hex(self.bin, 'pad4');
            self.verifyEqual(hex, '0123 4567 89AB CDEF');
        end

        function test_pad8(self)
            hex = matspace.utils.bin2hex(self.bin, 'pad8');
            self.verifyEqual(hex, '01234567 89ABCDEF');
        end

        function test_short_bin1(self)
            small_bin = string(self.bin).split(' ');
            for i = 1:16
                hex = matspace.utils.bin2hex(char(small_bin(i)));
                self.verifyEqual(hex, char(self.hex(i)));
            end
        end

        function test_short_bin2(self)
            small_bin = string(self.bin).split(' ');
            for i = 1:16
                hex = matspace.utils.bin2hex(char(small_bin(i)));
                self.verifyEqual(hex, self.hex(i));
            end
        end

        function test_shorter_bin(self)
            hex = matspace.utils.bin2hex('111');
            self.verifyEqual(hex, '7');
        end

        function test_empty_bin1(self)
            hex = matspace.utils.bin2hex('');
            self.verifyEqual(hex, '');
        end

        function test_empty_bin2(self)
            hex = matspace.utils.bin2hex([], 'upper');
            self.verifyEqual(hex, '');
        end

        function test_multiple_options(self)
            hex = matspace.utils.bin2hex('00000001111111110000', 'pad4', 'lower');
            self.verifyEqual(hex, '0 1ff0');
        end

        function test_multiple_options2(self)
            hex = matspace.utils.bin2hex('00000001111111110000', 'pad8', 'upper');
            self.verifyEqual(hex, '01FF0');
        end

        function test_multiple_bins1(self)
            hex = matspace.utils.bin2hex({self.bin, '0', '11110000'});
            self.verifyEqual(hex, {self.hex, '0', 'F0'});
        end

        function test_multiple_bins2(self)
            hex = matspace.utils.bin2hex(string({self.bin, '0', '11110000'}));
            self.verifyEqual(hex, string({self.hex, '0', 'F0'}));
        end

        function test_bad_input_sizes(self)
            self.verifyError(@() matspace.utils.bin2hex(), 'MATLAB:minrhs');
        end

        function test_bad_chars(self)
            self.verifyError(@() matspace.utils.bin2hex('0000-1111'), 'matspace:bin2hex:BadChars');
        end

        function test_bad_options(self)
            self.verifyError(@() matspace.utils.bin2hex(self.bin, 'bad_option'), 'matspace:bin2hex:BadOption');
        end
    end
end