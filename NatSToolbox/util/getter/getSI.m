% getSI gets the sample interval of a signal which was given in parameter.
% Parameter
%  - signalStructure - structure which contains a raw signal, and have to
%    have a field named "interval"
% Return value
%  - SI - sample interval in seconds
function SI = getSI(signalStructure)

  % If we don't have interval field, try to calculate the SI
  if ~isfield(signalStructure, 'interval')
    
    % If we don't have time values, we can't calculate SI
    if ~isfield(signalStructure, 'times')
      errorMsg = 'No time vector was given. SI can''t be calculated!';
      errordlg(errorMsg);
      error(errorMsg);
    else
      warningMsg = 'Field ''interval'' is not present in the given structure.';
      warningMsg = strjoin({warningMsg,'SI will be calculated from time vector.'},'\n');
      warning(warningMsg);
      SI = diff(signalStructure.times([1,2]));
    end
    
  else
    SI = signalStructure.interval; 
  end
  
end