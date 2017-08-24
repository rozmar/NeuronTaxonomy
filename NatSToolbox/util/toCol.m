% Converts the input vector to column.
function colVector = toCol(inputVector)
  colVector = inputVector;
  if size(inputVector,2)>size(inputVector,1)
    colVector = colVector'; 
  end
end