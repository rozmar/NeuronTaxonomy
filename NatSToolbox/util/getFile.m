% getFile loads the given file and perform some preprocessing task. Drop
% the last sample point, if the length of the signal is not even (it is
% necessary for despiking) and downsample the signal with the given ratio.
%
% S = getFile(inputDir, fileName, fieldNameArray, parameters)
%   - inputDir path for the file
%   - fileName name of the file
%   - fieldNameArray array of fields in the following order:
%       {signal, trough, peak, spike}
%   - parameters (optional)
%      - downSample downsample ratio for the signal
%   - S returns the loaded and modified structure
% [S, title] = getFile(inputDir, fileName, fieldNameArray, parameters)
%   - returns the name of the cell for the plots
function [S, title] = getFile(inputDir, fileName, fieldNameArray, parameters)
  title = getCellName(fileName);
  printStatus('Loading');
  fprintf('%s\n', fileName);
  
  S = load(strcat(inputDir, fileName));
  S = dataFileNameChecker(S, fieldNameArray);
  
  wbName = lower(fieldNameArray{1});
  
  % If the length of the signal is not even, drop the last point. It is
  % needed for the despiking.
  if mod(length(S.(wbName).values),2)==1
    S.(wbName).values =  S.(wbName).values(1:end-1);
    S.(wbName).times =  S.(wbName).times(1:end-1);
  end
 
end