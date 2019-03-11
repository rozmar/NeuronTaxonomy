classdef IVGuiModel < handle
    
    properties
        datasumEntry
        selectedX
        datasumIdx
        gaussFilterSigma
    end
    
    methods
        function this = IVGuiModel()
            this.gaussFilterSigma = 3;
        end
    end
    
end

