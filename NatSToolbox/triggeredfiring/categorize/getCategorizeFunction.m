% This function returns the function handle of the proper classification
% function.
function [categorizationFunction,categorizationBase] = getCategorizeFunction(mode)

  if strcmpi(mode, 'no')
    categorizationFunction = @singleCategory;
    categorizationBase = 'triggerVector';
  elseif strcmpi(mode, 'rand')
    categorizationFunction = @randomCategory;
    categorizationBase = 'triggerVector';
  elseif strcmpi(mode, 'weightedrand')
    categorizationFunction = @weightedRandomCategory;
    categorizationBase = 'triggerVector';
  elseif strcmpi(mode, 'sec_pos')
    categorizationFunction = @positionCategory;
    categorizationBase = 'positionVector';
  elseif strcmpi(mode, 'cycle_length')
    categorizationFunction = @cyclelenCategory;
    categorizationBase = 'neighborMatrix';
  elseif strcmpi(mode, 'cycle_frequency')
    categorizationFunction = @cyclefreqCategory;
    categorizationBase = 'neighborMatrix';
  else
    errorMsg = sprintf('Classification %s is not a valid classification type (or still not implemented)!', mode);
    errordlg(errorMsg);
    error(errorMsg); %#ok<SPERR>
  end
      
end