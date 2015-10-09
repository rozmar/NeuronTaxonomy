
ind = closestDiffs(i).ids;

figure();
clf;



colors = ['r'; 'b'];
label = ['A'; 'B'];
%AP = [ 6 ; 19 ];

for j = 1 : 2 
  tmp = strsplit(fileList{ind(j)},'_');
  
  subplot(1,2,j);
  featureList{bestFeatures(i)}
  if length(tmp)==7
    %plotFeatureWithAP(strcat('/media/borde/Data/mdata/data/IVs/',tmp(4),'.mat'),strcat(tmp(5),'_',tmp(6),'_',strtok(tmp(7),'.')),strcat('/media/borde/Data/mdata/IV/IVs/',label(j)),strcat('data_iv_',tmp(2),'_',tmp(3),'_',tmp(4),'.mat_',tmp(5),'_',tmp(6),'_',tmp(7)),featureList{bestFeatures(i)},colors(j));
    drawap(strcat('/media/borde/Data/mdata/data/IVs/',tmp(4),'.mat'),strcat(tmp(5),'_',tmp(6),'_',strtok(tmp(7),'.')),strcat('/media/borde/Data/mdata/IV/IVs/',label(j)),strcat('data_iv_',tmp(2),'_',tmp(3),'_',tmp(4),'.mat_',tmp(5),'_',tmp(6),'_',tmp(7)),featureList{bestFeatures(i)},colors(j),AP(j));
  elseif length(tmp)==6
    %plotFeatureWithAP(strcat('/media/borde/Data/mdata/data/IVs/',tmp(3),'.mat'),strcat(tmp(4),'_',tmp(5),'_',strtok(tmp(6),'.')),strcat('/media/borde/Data/mdata/IV/IVs/',label(j)),strcat('data_iv_',tmp(2),'_',tmp(3),'.mat_',tmp(4),'_',tmp(5),'_',tmp(6)),featureList{bestFeatures(i)},colors(j));
    drawap(strcat('/media/borde/Data/mdata/data/IVs/',tmp(3),'.mat'),strcat(tmp(4),'_',tmp(5),'_',strtok(tmp(6),'.')),strcat('/media/borde/Data/mdata/IV/IVs/',label(j)),strcat('data_iv_',tmp(2),'_',tmp(3),'.mat_',tmp(4),'_',tmp(5),'_',tmp(6)),featureList{bestFeatures(i)},colors(j),AP(j));
  end
  ylim([-0.06,0.06]);
end