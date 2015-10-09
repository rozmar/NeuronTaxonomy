
Ramp = {};
dvMax = {};
dvMin = {};
threshold = {};
ahp = {};

for i = 1 : length(celllist)
  tmp = strsplit(fileList{i},'_');
  if length(tmp)==7
    cellname = strcat('data_iv_',tmp(2),'_',tmp(3),'_',tmp(4),'_',tmp(5),'_',tmp(6),'_',tmp(7));
  else
    cellname = strcat('data_iv_',tmp(2),'_',tmp(3),'_',tmp(4),'_',tmp(5),'_',tmp(6));
  end
  
  switch(y(i))
    case 1 classlabel = 'A';
    case 0 classlabel = 'B';
    otherwise classlabel = 'C';
  end
 
  cell = load(strcat('/media/borde/Data/mdata/IV/IVs/',classlabel,'/',cellname){1}).cellStruct;
  
  Ramp{i}.ramp = cell.ramp(:,1);
  dvMax{i}.dvm = cell.apFeatures(:,35);
  dvMin{i}.dvm = cell.apFeatures(:,36);
  threshold{i}.th = cell.apFeatures(:,34);
  ahp{i}.ahp = cell.apFeatures(:,38).+cell.dvrs(cell.apFeatures(:,1));
  
  printf("%s processed.\n",cellname{1});
  fflush(stdout);
end