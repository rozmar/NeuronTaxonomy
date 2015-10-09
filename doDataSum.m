%
%
%
function doDataSum(rawDir,rawName,fdir,fname,id,outputDir,cellname)

    cell=load([fdir,'/',fname]);
    cell = cell.cellStruct;			
	iv=load([rawDir,'/',rawName]);
    iv = iv.iv.(strtrim(cellname));
		
	datasum = calculateElfiz(cell,iv.current,iv.time);
	ramp = datasum.ramp;
    size(ramp)
	datasum = rmfield(datasum,'ramp');
	datasum.rampx = ramp(1);
	datasum.rampy = ramp(2);
		
	save([outputDir,'/datasum_',id,'_',rawName,'_',strtrim(cellname),'.mat'],'datasum');

end