% dataFileNameChecker checks if the given datafile contains the given
% fieldnames. If a fieldname is present but with other capitalization, the
% name will be converted to lowercase. Anyway error will be shown.
%
% Parameters
% fixedData = dataFileNameChecker(dataFile, fieldNames)
%  dataFile - data structure which fields have to be checked
%  expFieldNames - array of expected channel names
%
% fixedData checked and corrected structure
function fixedData = dataFileNameChecker(dataFile, expFieldNames) 

  %% ---------------------------
  %  Initialization
  %% ---------------------------
  realFieldNames = fieldnames(dataFile);
  %% ---------------------------
  
  %% ---------------------------
  %  Loop through each expected 
  %  fieldname
  %% ---------------------------
  for i = 1 : length(expFieldNames)
      
    % Skip unnecessary fields
    if isempty(expFieldNames{i})
      continue;
    end
      
    % Regexp for the current expected fieldname
    thisExpField = expFieldNames{i};
    fieldRegexp  = ['^',thisExpField,'$'];
    % Find fields with this name
    strCell     = regexp(realFieldNames, fieldRegexp);
    idx         = cellfun(@(x) ~isempty(x), strCell);
    
    % If there isn't match
    if sum(idx)==0
      % try to find converted to lowercase
      strCell = regexp(lower(realFieldNames), fieldRegexp);
      idx = cellfun(@(x) ~isempty(x), strCell);
      
      % If there is a match, convert to lowercase
      if sum(idx)==1
        fixedData.(thisExpField) = dataFile.(realFieldNames{idx});
        warning('%s has been renamed to %s.', realFieldNames{idx}, thisExpField);
      else
        throw(MException('MATLAB:inputFieldMissing',sprintf('Field %s is missing from input file!', thisExpField)));
      end
    % If the original value can be found, save it to the output
    else
        fixedData.(thisExpField) = dataFile.(thisExpField);  
    end
  end
  %% ---------------------------
  
end