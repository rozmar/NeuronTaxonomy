% Converts structures put in cellarray into an array of structures.
function structureArray = convertArrayOfStruct(arrayOfStr)
  nArray = length(arrayOfStr);
  for i = 1 : nArray
    structureArray(i) = arrayOfStr{i}; 
  end
end