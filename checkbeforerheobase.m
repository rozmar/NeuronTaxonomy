
Probs = [];

for i = 1 : length(fileList)
  tmp = strsplit(fileList{i},'_');
  if length(tmp)==7
    cellname = strcat('data_iv_',tmp(2),'_',tmp(3),'_',tmp(4),'_',tmp(5),'_',tmp(6),'_',tmp(7));
    ivname = tmp(4);
    gsc = strcat(tmp(5),'_',tmp(6),'_',strtok(tmp(7),'.'));
  else
    cellname = strcat('data_iv_',tmp(2),'_',tmp(3),'_',tmp(4),'_',tmp(5),'_',tmp(6));
    ivname = tmp(3);
    gsc = strcat(tmp(4),'_',tmp(5),'_',strtok(tmp(6),'.'));
  end
  
  switch(y(i))
    case 1 classlabel = 'A';
    case 0 classlabel = 'B';
    otherwise classlabel = 'C';
  end
 
  cell = load(strcat('/home/borde/Munka/mdata/IV/IVs/',classlabel,'/',cellname){1}).cellStruct;
  iv = load(strcat('/home/borde/Munka/mdata/data/IVs/',ivname){1}).iv.(gsc{1});

  %find(iv.current>0)
  %cell.rheobase
  %idx = find(iv.current>0);
  %idx = idx(idx<cell.rheobase);
  %idx = idx(idx>=cell.rheobase-2);
  idx = cell.rheobase-1;
  idx
  fflush(stdout);
  
  posramp_rheo(i) = mean(cell.ramp(idx,1));
  
end
