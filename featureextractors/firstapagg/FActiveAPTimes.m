% This function aggregates the time features of AP-s
%
% In parameter it is expected the cell (with extracted data)
% time vector and the output struct.
function datasum = FActiveAPTimes(cell,x,datasum)
	
	%load the names of the AP features
	load("/home/borde/Munka/NeuroScience/featureextractors/apFeatures.mat","featS");
		
	apFeatures = cell.apFeatures;
	firingSweep = unique(apFeatures(:,1));
	firstAP = [];
	for i=1:size(firingSweep,1)
		sweepAps = apFeatures(find(apFeatures(:,1)==firingSweep(i)),:);
		if size(sweepAps,1)<2
			continue;
		else
			firstAP = sweepAps(1,:);
			break;
		end	
	end
		
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%% Get AP realted position and convert to time %%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	apMax=x(firstAP(featS.apMaxPos));
	threshold=x(firstAP(featS.thresholdPos));
	apEnd=x(firstAP(featS.apEndPos));
	halfWidthStart=firstAP(featS.halfWidthStart);
	halfWidthEnd=firstAP(featS.halfWidthEnd);
	dvMax=x(firstAP(featS.dvMaxPos));
	dvMin=x(firstAP(featS.dvMinPos));
	ahp=x(firstAP(featS.ahpPos));
	%adp=x(firstAP(featS.adpPos));
	
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%          AP time differences        %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	datasum.FapMaxthresholdDiff=apMax-threshold;
	datasum.FapMaxapEndDiff=apMax-apEnd;
	datasum.FapMaxhalfWidthStartDiff=apMax-halfWidthStart;
	datasum.FapMaxhalfWidthEndDiff=apMax-halfWidthEnd;
	datasum.FapMaxdvMaxDiff=apMax-dvMax;
	datasum.FapMaxdvMinDiff=apMax-dvMin;
	datasum.FapMaxahpDiff=apMax-ahp;
	%datasum.FapMaxadpDiff=apMax-adp;
	datasum.FthresholdapEndDiff=threshold-apEnd;
	datasum.FthresholdhalfWidthStartDiff=threshold-halfWidthStart;
	datasum.FthresholdhalfWidthEndDiff=threshold-halfWidthEnd;
	datasum.FthresholddvMaxDiff=threshold-dvMax;
	datasum.FthresholddvMinDiff=threshold-dvMin;
	datasum.FthresholdahpDiff=threshold-ahp;
	%datasum.FthresholdadpDiff=threshold-adp;
	datasum.FapEndhalfWidthStartDiff=apEnd-halfWidthStart;
	datasum.FapEndhalfWidthEndDiff=apEnd-halfWidthEnd;
	datasum.FapEnddvMaxDiff=apEnd-dvMax;
	datasum.FapEnddvMinDiff=apEnd-dvMin;
	datasum.FapEndahpDiff=apEnd-ahp;
	%datasum.FapEndadpDiff=apEnd-adp;
	datasum.FhalfWidthStarthalfWidthEndDiff=halfWidthStart-halfWidthEnd;
	datasum.FhalfWidthStartdvMaxDiff=halfWidthStart-dvMax;
	datasum.FhalfWidthStartdvMinDiff=halfWidthStart-dvMin;
	datasum.FhalfWidthStartahpDiff=halfWidthStart-ahp;
	%datasum.FhalfWidthStartadpDiff=halfWidthStart-adp;
	datasum.FhalfWidthEnddvMaxDiff=halfWidthEnd-dvMax;
	datasum.FhalfWidthEnddvMinDiff=halfWidthEnd-dvMin;
	datasum.FhalfWidthEndahpDiff=halfWidthEnd-ahp;
	%datasum.FhalfWidthEndadpDiff=halfWidthEnd-adp;
	datasum.FdvMaxdvMinDiff=dvMax-dvMin;
	datasum.FdvMaxahpDiff=dvMax-ahp;
	%datasum.FdvMaxadpDiff=dvMax-adp;
	datasum.FdvMinahpDiff=dvMin-ahp;
	%datasum.FdvMinadpDiff=dvMin-adp;
	%datasum.FahpadpDiff=ahp-adp;
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%     AP time differences end     %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
end
