% getCellName cut the name of the cell from the given filename. It can be
% used for plot title or output filenames.
% 
% cellName = getCellName(fileName)
%   fileName - name of the original file. The name of the cell will be
%               considered as the filename without the extension
%   cellName - the name of the cell
function cellName = getCellName(fileName)
  cellName = strsplit(fileName,'.');
  cellName = strjoin(cellName(1:end-1),'.');
end