

ds1 = strsplit(fileList(closestDiffs(i).ids(1)){1},'_');

if length(ds1)==6
  iv1 = load(strcat('/media/borde/Data/mdata/data/IVs/',ds1(3),'.mat'){1}).iv.(strcat(ds1(4),'_',ds1(5),'_',strtok(ds1(6),'.')(1)){1});
  cell1 = load(strcat('/media/borde/Data/mdata/IV/IVs/A/data_iv_',ds1(2),'_',ds1(3),'.mat_',ds1(4),'_',ds1(5),'_',ds1(6)){1}).cellStruct;
else
  iv1 = load(strcat('/media/borde/Data/mdata/data/IVs/',ds1(4),'.mat'){1}).iv.(strcat(ds1(5),'_',ds1(6),'_',strtok(ds1(7),'.')(1)){1});
  cell1 = load(strcat('/media/borde/Data/mdata/IV/IVs/A/data_iv_',ds1(2),'_',ds1(3),'_',ds1(4),'.mat_',ds1(5),'_',ds1(6),'_',ds1(7)){1}).cellStruct;
end

ds2 = strsplit(fileList(closestDiffs(i).ids(2)){1},'_');

if length(ds2)==6
  iv2 = load(strcat('/media/borde/Data/mdata/data/IVs/',ds2(3),'.mat'){1}).iv.(strcat(ds2(4),'_',ds2(5),'_',strtok(ds2(6),'.')(1)){1});
  cell2 = load(strcat('/media/borde/Data/mdata/IV/IVs/B/data_iv_',ds2(2),'_',ds2(3),'.mat_',ds2(4),'_',ds2(5),'_',ds2(6)){1}).cellStruct;
else
  iv2 = load(strcat('/media/borde/Data/mdata/data/IVs/',ds2(4),'.mat'){1}).iv.(strcat(ds2(5),'_',ds2(6),'_',strtok(ds2(7),'.')(1)){1});
  cell2 = load(strcat('/media/borde/Data/mdata/IV/IVs/B/data_iv_',ds2(2),'_',ds2(3),'_',ds2(4),'.mat_',ds2(5),'_',ds2(6),'_',ds2(7)){1}).cellStruct;
end