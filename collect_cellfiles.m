for j = 1 : length(examine)
    for i = 1 : length(fileList) 
        sI = regexp(fileList{i},examine{j});
        if length(sI)>0              
            examfiles{j}=strrep(fileList{i},'datasum_','data_iv_');
            load(['/media/borde/Data/mdata/IV/IVs/C/',examfiles{j},'.mat']);
            examcells{j} = cell;
            examidx(j)=i;
        end;
    end;
end;
