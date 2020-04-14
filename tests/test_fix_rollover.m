classdef test_fix_rollover < matlab.unittest.TestCase %#ok<*PROP>

% Tests the fix_rollover function with the following cases:
%     Nominal
%     Matrix dim 1
%     Matrix dim 2
%     Log level 1
%     Optional inputs

    properties
        data,
        data2,
        exp,
        roll,
        log_level,
        dim,
    end

    methods (TestMethodSetup)
        function initialize(self)
            self.data  = [1 2 3 4 5 6 0 1  3  6  0  6  5 2];
            self.data2 = [];
            self.exp   = [1 2 3 4 5 6 7 8 10 13 14 13 12 9];
            self.roll  = 7;
            self.log_level = 10;
            self.dim   = [];
        end
    end

    methods (Test)
        function test_nominal(self)
            out = verifyWarning(self, @() fix_rollover(self.data, self.roll, self.log_level), 'matspace:rollover');
            self.verifyEqual(out, self.exp);
        end

        function test_matrix_dim1(self)
            dim  = 1;
            data = [self.data; self.data];
            exp  = [self.data; self.data];
            out  = fix_rollover(data, self.roll, self.log_level, dim);
            self.verifyEqual(out, exp);
        end

        function test_matrix_dim2(self)
            self.dim   = 2;
            self.data2 = [self.data; self.data];
            exp        = [self.exp; self.exp];
            out        = verifyWarning(self, @() fix_rollover(self.data2, self.roll, self.log_level, self.dim), 'matspace:rollover');
            self.verifyEqual(out, exp);
        end

        function test_log_level(self)
            self.log_level = 1;
            out = fix_rollover(self.data, self.roll, self.log_level);
            self.verifyEqual(out, self.exp);
        end

        function test_optional_inputs(self)
            import matlab.unittest.fixtures.SuppressedWarningsFixture
            self.applyFixture(SuppressedWarningsFixture('matspace:rollover'));
            out = fix_rollover(self.data, self.roll);
            % out = verifyWarning(self, @() fix_rollover(self.data, self.roll), 'matspace:rollover');
            self.verifyEqual(out, self.exp);
        end
    end
end