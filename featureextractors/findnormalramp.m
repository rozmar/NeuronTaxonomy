

for i = 1 : length(fileList)
  tmp = strsplit(fileList{i},'_');
  if length(tmp)==7
    cellname = strcat('data_iv_',tmp(2),'_',tmp(3),'_',tmp(4),'.mat_',tmp(5),'_',tmp(6),'_',tmp(7));
  else
    cellname = strcat('data_iv_',tmp(2),'_',tmp(3),'.mat_',tmp(4),'_',tmp(5),'_',tmp(6));
  end
  
  switch(y(i))
    case 1 classlabel = 'A';
    case -1 classlabel = 'B';
    otherwise classlabel = 'C';
  end
 
  cell = load(strcat('/media/borde/Data/mdata/IV/IVs/',classlabel,'/',cellname){1}).cellStruct;
  
  rhe_1ramp(i) = cell.ramp(cell.rheobase-1,1);
  
end