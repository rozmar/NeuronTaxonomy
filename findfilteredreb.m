

for i = 1 : length(fileList)
  tmp = strsplit(fileList{i},'_');
  if length(tmp)==7
    ivname = tmp(4);
    gsc = strcat(tmp(5),'_',tmp(6),'_',strtok(tmp(7),'.'));
  else
    ivname = tmp(3);
    gsc = strcat(tmp(4),'_',tmp(5),'_',strtok(tmp(6),'.'));
  end
  
  switch(y(i))
    case 1 classlabel = 'A';
    case -1 classlabel = 'B';
    otherwise classlabel = 'C';
  end
   
  iv = load(strcat('/home/borde/Munka/mdata/data/IVs/',ivname,'.mat'){1}).iv.(gsc{1});
  
  cell = featureExtract(iv,'/home/borde/Munka/NeuroScience/featureextractors');
  
  vsagvrebound(i) = mean(cell.vsag.-cell.vrebound);
  
end