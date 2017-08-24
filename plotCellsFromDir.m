function plotCellsFromDir(baseDirName, groupID)

  featureDir = strjoin({baseDirName, 'datafiles', num2str(groupID)}, '\');
  datasumsDir = strjoin({baseDirName, 'datasums', num2str(groupID)}, '\');
  
  featureFileList = listFilesInDir(featureDir);
  datasumFileList = listFilesInDir(datasumsDir);
  
  if length(featureFileList) ~= length(datasumFileList)
    throw(MException('NeuronTaxonomy:InputFileError', ...
      'Not the same number of datasums and feature file!'));
  end
  
  for i = 1 : length(datasumFileList)
    thisDSFile = datasumFileList{i};
    dsNameStruct = fitDatasumFilename(thisDSFile);
    
    if isempty(dsNameStruct)
      throw(MException('NeuronTaxonomy:InputFileError', ...
        'Not proper filename format!'));
    end
    
    featureFileIdx = ~cellfun(@isempty, regexp(featureFileList, ['_',dsNameStruct.id,'_']));
    featureFileName = featureFileList{featureFileIdx};
    
    datasumStructure = load(strjoin({datasumsDir,thisDSFile},'\'));
    ivStructure = datasumStructure.datasum.iv;
    ivStructure.cellName = sprintf('%s, %s', dsNameStruct.fname, strrep(dsNameStruct.post,'_',''));
    featureStructure = load(strjoin({featureDir,featureFileName},'\'));
    featureStructure = featureStructure.cellStruct;
    
    plotAllSweepsWithFeatures(ivStructure, featureStructure.apFeatures);
    
  end
  
end

% Split datasum's filename into parts
function nameStructure = fitDatasumFilename(fileName)
  pattern = ['(?<pref>(datasum))', '_', '(?<id>(0*\d+))', '_', '(?<fname>(\d{7}\w{1,2}\d?\.mat))', '_', '(?<post>(g\d+_s\d+_c\d+))', '.mat'];
  nameStructure = regexp(fileName, pattern, 'names');
end

% Split datasum's filename into parts
function nameStructure = fitDatafileFilename(fileName)
  pattern = ['(?<pref>(data_iv))', '_', '(?<id>(0*\d+))', '_', '(?<fname>(\d{7}\w{1,2}\d?\.mat))', '_', '(?<post>(g\d+_s\d+_c\d+))', '.mat'];
  nameStructure = regexp(fileName, pattern, 'names');
end