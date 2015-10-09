
FX = [];

for i = 1 : length(fileList)
   
  switch(y(i))
    case 1 classlabel = 'A';
    case 0 classlabel = 'B';
    otherwise classlabel = 'C';
  end
 
  datasum = load(strcat('/media/borde/Data/mdata/datasum/Glia/',classlabel,'/',fileList(i){1})).datasum;
 
  FX = [ FX ; datasum.thresholdVRealahpVDiff datasum.dvMaxVRealdvMinVRealDiff datasum.vsagvreboundDiff];
  
end
