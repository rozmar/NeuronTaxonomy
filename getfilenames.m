
filesnames = {};
for i = 1 : length(princomp.ID);
  filesnames{i} = ['datasum_',princomp.ID{i},'_',princomp.fname{i},'_g',num2str(princomp.gsc{i}(1)),'_s',num2str(princomp.gsc{i}(2)),'_c',num2str(princomp.gsc{i}(3)),'.mat'];
end;  