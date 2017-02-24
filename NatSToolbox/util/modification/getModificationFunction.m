% This function returns the function handle of the proper modifier
% function.
function modificationFunction = getModificationFunction(mode)

  if strcmpi(mode, 'no')
    modificationFunction = @identityFunction;
  elseif strcmpi(mode, 'align_nearest')
    modificationFunction = @moveTriggerToNearestEvent;
  elseif strcmpi(mode, 'align_peak_nearest')
    modificationFunction = @moveTriggerToNearestEventAroundPeak;
  else
    errorMsg = sprintf('Modification function %s is not a valid modification type (or still not implemented)!', mode);
    errordlg(errorMsg);
    error(errorMsg); %#ok<SPERR>
  end
      
end