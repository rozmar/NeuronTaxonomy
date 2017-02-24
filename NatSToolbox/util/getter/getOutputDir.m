% getOutputDir returns the output directory from the given parameter
% structure.
%
% Parameters 
%  - parameters - the parameter structure
% Return value
%  - outputDir - the path for the output dir
function outputDir = getOutputDir(parameters)
  outputDir = parameters.output.dir;
end