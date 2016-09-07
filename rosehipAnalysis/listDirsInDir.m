% listFilesInDir collects and returns the names of the .mat
% files in the given directory (if there is any).
%
% filenames = listFilesInDir(inputDir)
%   inputDir - path of the directory where to search for files
%   fileNameArray - array of names of files'
% filenames = listFilesInDir(inputDir, inputFile)
%   if exist, returns only the requested file
function [dirNameArray, newInputDir] = listDirsInDir(inputDir)
  
  %-------------------------------
  % Unify Windows and Linux style
  % If input dir name doesn't ends
  % with \ or /, put an / to the end.
  %-------------------------------
  if isempty(regexp(inputDir, '^.*[\/\\]$', 'once'))
    if ispc
      inputDir = strcat(inputDir, '\');  
    elseif isunix
      inputDir = strcat(inputDir, '/');
    end
  end
  newInputDir = inputDir;
  %-------------------------------
    
  %-------------------------------
  % List every item in dir.
  %-------------------------------
  itemList           = dir(inputDir);
  %-------------------------------
  
  %-------------------------------
  % Keep dirs, remove files
  %-------------------------------
  dirFlag           = ([itemList(:).isdir]==1);
  itemList(~dirFlag) = [];
  %-------------------------------
  
  %-------------------------------
  % Remove . and .. 
  %-------------------------------
  dirNameArray = {itemList(:).name}';
  dotDirFlag   = cell2mat(regexp(dirNameArray,'^[\.]{1,2}$'));
  dirNameArray(logical(dotDirFlag)) = [];
  %-------------------------------
end