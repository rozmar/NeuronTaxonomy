
APF = [];
VHyp = [];
VSag = [];
DVSag = [];
VReb = [];
DReb = [];
Hump = [];

for i = 1 : length(fileList)
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
  
  vrs = cell.vrs;
  
  APF = [ APF ; vrs(cell.apFeatures(:,1)) , cell.apFeatures ];
  VHyp = [ VHyp ; vrs , cell.vhyp ];
  VSag = [ VSag ; vrs(1:size(cell.vsag,1)) , cell.vsag ];
  DVSag = [ DVSag ; vrs(1:size(cell.dvsag,1)) , cell.dvsag ];
  VReb = [ VReb ; vrs(1:size(cell.vrebound,1)) , cell.vrebound ];
  DReb = [ DReb ; vrs(1:size(cell.dvrebound,1)) , cell.dvrebound ];
  Hump = [ Hump ; vrs(1:size(cell.hump,1)) , cell.hump ]; 
  
  printf("%s processed.\n",cellname{1});
  fflush(stdout);
end