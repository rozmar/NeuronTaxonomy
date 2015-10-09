function [idx1,idx2,matching] = matchTwoClustering(BS,gd)
  idx1 = BS.idx;
  idx2 = gd.abovenoise;
  ord = [];
  for i = 1 : length(gd.ID)
    text = strcat('datasum_',gd.ID(i){1},'_',gd.fname(i){1},'.mat_g',num2str(gd.pregroup_series_channel(i){1}(1)),'_s',num2str(gd.pregroup_series_channel(i){1}(2)),'_c',num2str(gd.pregroup_series_channel(i){1}(3)),'.mat');
    ord = [ ord ; findById(BS.ID,text) ];
  end;
  idx1 = idx1(ord);
  matching = (idx1==idx2);
end