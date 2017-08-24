% Split datasum's filename into parts
function nameStructure = splitDatasumFilename(fileName)
  pattern = ['(?<pref>(datasum))', '_', '(?<id>(0*\d+))', '_', '(?<fname>(\d{7}\w{1,2}\d?\.mat))', '_', '(?<post>(g\d+_s\d+_c\d+))', '.mat'];
  nameStructure = regexp(fileName, pattern, 'names');
end