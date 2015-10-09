

function datasum = aggActiveAPVDiffQuotient(datasum)
	datasum=VdiffMeanQuot(datasum);
	datasum = VdiffMinMaxQuot(datasum);
end
