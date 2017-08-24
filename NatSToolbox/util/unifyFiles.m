function unifyFiles(inputDir, outputDir)
  [fileNameArray, inputDir] = listFilesInDir(inputDir);
  nFile = length(fileNameArray);
  
  
  
  for f = 1 : nFile
    thisFileName = fileNameArray{f}
    S = load(strcat(inputDir,'/',thisFileName));
    namesOfFields = fieldnames(S);
    nField        = length(namesOfFields);
    
    newStructure  = struct();
    
    newStructure.wideband  = S.(getCaseSensitiveName(namesOfFields, 'wideband'));
    newStructure.spike     = S.(getCaseSensitiveName(namesOfFields, 'spike'));
    newStructure.kcomplex  = S.(getCaseSensitiveName(namesOfFields, '(kcomplex|k_complex)'));
    newStructure.spdl_0    = S.(getCaseSensitiveName(namesOfFields, 'spdl_0'));
    
    newStructure.delta_st  = S.deltast;
    newStructure.delta_st  = addTimes(newStructure.delta_st, S.(getCaseSensitiveName(namesOfFields, 'kdeltast')));
    
    newStructure.delta_end = S.deltaend;
    newStructure.delta_end  = addTimes(newStructure.delta_end, S.(getCaseSensitiveName(namesOfFields, 'kdeltaend')));
    
    save(strcat(outputDir,'/',thisFileName), '-struct', 'newStructure');
  end
end

function realName = getCaseSensitiveName(nameArray, caseInsensitiveName)
  for i = 1 : length(nameArray)
     name = nameArray{i};
     if ~isempty(regexpi(lower(name), caseInsensitiveName))
       realName = name;
       return;
     end
  end
  realName = '';
end

function newStruct = addTimes(oldStructure, toAddStructure)
  newStruct = oldStructure;
  newStruct.times  = cat(1, newStruct.times, toAddStructure.times);
  newStruct.length = newStruct.length + toAddStructure.length;
end