% listFilesInDir collects and returns the names of the .mat
% files in the given directory (if there is any).
%
% filenames = listFilesInDir(inputDir)
%   inputDir - path of the directory where to search for files
%   fileNameArray - array of names of files'
% filenames = listFilesInDir(inputDir, inputFile)
%   if exist, returns only the requested file
function [fileNameArray, newInputDir] = listFilesInDir(inputDir, inputFile)
  
  %-------------------------------
  % Unify Windows and Linux style
  % If input dir name doesn't ends
  % with \ or /, put an / to the end.
  %-------------------------------
  if isempty(regexp(inputDir, '^.*[\/\\]$', 'once'))
    inputDir = strcat(inputDir, '/');
  end
  newInputDir = inputDir;
  %-------------------------------

  %-------------------------------
  % If file was given, "list" only 
  % that.
  %-------------------------------
  if nargin>1 && ~isempty(inputFile)
    if exist(strcat(inputDir,inputFile), 'file')
      fileNameArray = {inputFile};
    else
      throw(MException('MATLABAnalysis:FileLoad', ...
          sprintf('%s in %s does not exist', ... 
            inputFile, strrep(inputDir,'\','\\'))));
    end
    return;
  end
  %-------------------------------
    
  %-------------------------------
  % Else, list every item in dir.
  %-------------------------------
  itemList           = dir(inputDir);
  %-------------------------------
  
  %-------------------------------
  % Remove dirs, keep only files
  %-------------------------------
  dirFlag           = ([itemList(:).isdir]==1);
  itemList(dirFlag) = [];
  
  dirFlag = false(length(itemList),1);
  for i = 1 : length(itemList)
    if strcmpi(itemList(i).name, '.') || strcmpi(itemList(i).name, '..')
       dirFlag(i) = true;
    end
        
  end
  itemList(dirFlag) = [];
  %-------------------------------
  
  %-------------------------------
  % Remove non-matlab files
  %-------------------------------
  matFileRegex  = '^.*\.mat$';
  fileNameArray = {itemList(:).name}';
  matFileFlag   = cell2mat(regexp(fileNameArray, matFileRegex));
  fileNameArray = fileNameArray(logical(matFileFlag));
  %-------------------------------
end