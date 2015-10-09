


function datasum = aggPassiveVoltages(cell,current,datasum)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%     Get passive Voltages     %%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	v0=cell.v0;
	vhyp=cell.vhyp;
	vsag=cell.vsag;
	vrebound=cell.vrebound;
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%    Passive Volt differences %%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	datasum.v0vhypDiff=mean(v0-vhyp);
	datasum.v0vsagDiff=mean(v0(1:size(vsag,1))-vsag);
	datasum.v0vreboundDiff=mean(v0(1:size(vrebound,1))-vrebound);
	datasum.vhypvsagDiff=mean(vhyp(1:size(vsag,1))-vsag);
	datasum.vhypvreboundDiff=mean(vhyp(1:size(vrebound,1))-vrebound);
	datasum.vsagvreboundDiff=mean(vsag-vrebound);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%   Passive Volt differences end %%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%       Passive Voltage Quotients       %%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	datasum.v0vhypQuot=mean(v0./vhyp);
	datasum.v0vsagQuot=mean(v0(1:size(vsag,1))./vsag);
	datasum.v0vreboundQuot=mean(v0(1:size(vrebound,1))./vrebound);
	datasum.vhypvsagQuot=mean(vhyp(1:size(vsag,1))./vsag);
	datasum.vhypvreboundQuot=mean(vhyp(1:size(vrebound,1))./vrebound);
	datasum.vsagvreboundQuot=mean(vsag./vrebound);
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%         Passive Voltage Stdev          %%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	datasum.v0vhypDiffStd=std(v0-vhyp);
	datasum.v0vsagDiffStd=std(v0(1:size(vsag,1))-vsag);
	datasum.v0vreboundDiffStd=std(v0(1:size(vrebound,1))-vrebound);
	datasum.vhypvsagDiffStd=std(vhyp(1:size(vsag,1))-vsag);
	datasum.vhypvreboundDiffStd=std(vhyp(1:size(vrebound,1))-vrebound);
	datasum.vsagvreboundDiffStd=std(vsag-vrebound);
	datasum.v0vhypQuotStd=std(v0./vhyp);
	datasum.v0vsagQuotStd=std(v0(1:size(vsag,1))./vsag);
	datasum.v0vreboundQuotStd=std(v0(1:size(vrebound,1))./vrebound);
	datasum.vhypvsagQuotStd=std(vhyp(1:size(vsag,1))./vsag);
	datasum.vhypvreboundQuotStd=std(vhyp(1:size(vrebound,1))./vrebound);
	datasum.vsagvreboundQuotStd=std(vsag./vrebound);

	
end