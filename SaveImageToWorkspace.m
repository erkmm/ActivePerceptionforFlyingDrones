classdef SaveImageToWorkspace < matlab.System
    %#codegen

    properties (Access = private)
        StepCounter int32 = 1;
    end

    methods (Access = protected)
        function y = stepImpl(obj, u)
            coder.extrinsic('assignin', 'sprintf');

            if coder.target('MATLAB')
                stepStr = sprintf('%04d', obj.StepCounter);
                varName = ['image_step_', stepStr];
                assignin('base', varName, uint8(u));
            end

            obj.StepCounter = obj.StepCounter + 1;

            % Pass-through
            y = u;
        end

        function resetImpl(obj)
            obj.StepCounter = 1;
        end

        function num = getNumInputsImpl(~)
            num = 1;
        end

        function num = getNumOutputsImpl(~)
            num = 1;
        end

        function flag = isInputSizeLockedImpl(~,~)
            flag = true;
        end

        function [name1] = getInputNamesImpl(~)
            name1 = 'u';
        end

        function [name1] = getOutputNamesImpl(~)
            name1 = 'y';
        end
    end
end
