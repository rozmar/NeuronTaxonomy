% Converts the input vector to row.
function rowVector = toRow(inputVector)
  rowVector = inputVector;
  if size(inputVector,2)<size(inputVector,1)
    rowVector = rowVector'; 
  end
end