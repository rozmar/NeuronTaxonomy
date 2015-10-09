


function datasum = aggPassTime(cell,x,datasum)
	%load the names of the AP features
	load('/home/borde/Munka/NeuroScience/featureextractors/apFeatures.mat','featS');
	
	taustart = x(cell.taustart);
	tauend = x(cell.tauend);
	rebound = cell.trebound;
	
	datasum.tau090 = mean(cell.tau0_90risetime);
	datasum.reb090 = mean(cell.reb0_90risetime);
	datasum.tau090Std = std(cell.tau0_90risetime);
	datasum.reb090Std = std(cell.reb0_90risetime);
	datasum.tau090Stdtau090Quot=datasum.tau090Std/datasum.tau090;
	datasum.reb090Stdreb090=datasum.reb090Std/datasum.reb090;
	%datasum.hump090 = mean(cell.hump(:,4));
	
	datasum.tauendtaustartDiff = mean( tauend - taustart);
	datasum.reboundtaustartDiff = mean( rebound - taustart);
	datasum.reboundtauendDiff = mean( rebound - tauend);
	datasum.tauendtaustartDiffStd = std( tauend - taustart);
	datasum.reboundtaustartDiffStd = std( rebound - taustart);
	datasum.reboundtauendDiffStd = std( rebound - tauend);
	
	datasum.tauendtaustartDiffStdtauendtaustartDiff = datasum.tauendtaustartDiffStd/datasum.tauendtaustartDiff;
	datasum.reboundtaustartDiffStdreboundtaustartDiff = datasum.reboundtaustartDiffStd/datasum.reboundtaustartDiff;
	datasum.reboundtauendDiffStdreboundtauendDiff = datasum.reboundtauendDiffStd/datasum.reboundtauendDiff;
	
	datasum.tauendtaustartQuot = mean( datasum.tauendtaustartDiff ./ datasum.reboundtaustartDiff);
	datasum.reboundtaustartQuot = mean( datasum.tauendtaustartDiff ./ datasum.reboundtauendDiff);
	datasum.reboundtauendQuot = mean( datasum.reboundtaustartDiff ./ datasum.reboundtauendDiff);
	datasum.tauendtaustartQuotStd = std( datasum.tauendtaustartDiff ./ datasum.reboundtaustartDiff);
	datasum.reboundtaustartQuotStd = std( datasum.tauendtaustartDiff ./ datasum.reboundtauendDiff);
	datasum.reboundtauendQuotStd = std( datasum.reboundtaustartDiff ./ datasum.reboundtauendDiff);
	
	datasum.tauendtaustartQuotStdtauendtaustartQuot=datasum.tauendtaustartQuotStd/datasum.tauendtaustartQuot;
	datasum.reboundtaustartQuotStdreboundtaustartQuot = datasum.reboundtaustartQuotStd/datasum.reboundtaustartQuot;
	datasum.reboundtauendQuotStdreboundtauendQuot = datasum.reboundtauendQuotStd/datasum.reboundtauendQuot;
end