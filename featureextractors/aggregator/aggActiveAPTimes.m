% This function aggregates the time features of AP-s
%
% In parameter it is expected the cell (with extracted data)
% time vector and the output struct.
function datasum = aggActiveAPTimes(cell,x,datasum)
	
	%load the names of the AP features
	load('/home/borde/Munka/NeuroScience/featureextractors/apFeatures.mat','featS');
	apFeatures = cell.apFeatures;
		
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%% Get AP realted position and convert to time %%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	apMax=x(apFeatures(:,featS.apMaxPos));
	threshold=x(apFeatures(:,featS.thresholdPos));
	threshold5=x(apFeatures(:,featS.threshold5Pos));
	apEnd=x(apFeatures(:,featS.apEndPos));
	apEnd5=x(apFeatures(:,featS.apEnd5Pos));
	halfWidthStart=apFeatures(:,featS.halfWidthStart);
	halfWidthEnd=apFeatures(:,featS.halfWidthEnd);
	dvMax=apFeatures(:,featS.dvMaxT);
	dvMin=apFeatures(:,featS.dvMinT);
	ahp=x(apFeatures(:,featS.ahpPos));
   	if ( size(cell.ahp090,2)==0 )
     	  ahp90 = NaN;
  	else
    	  ahp90 = cell.ahp090(:,2);
        end
        if ( size(cell.ahp05,2)==0 )
          ahp10 = NaN;
        else
          ahp10 = cell.ahp05(:,2);
        end  
	
	datasum.ahp90 = nanmean(ahp90);
	datasum.ahp10 = nanmean(ahp10);
	datasum.ahp90Min= min(ahp90);
	datasum.ahp10Min = min(ahp10);
	datasum.ahp90Max = max(ahp90);
	datasum.ahp10Max = max(ahp10);
	datasum.ahp90Std = nanstd(ahp90);
	datasum.ahp10Std = nanstd(ahp10);
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%          AP time differences        %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	datasum.threshold5apMaxDiff=nanmean(apMax-threshold5);
	datasum.threshold5thresholdDiff=nanmean(threshold5-threshold);
	datasum.threshold5apEndDiff=nanmean(threshold5-apEnd);
	datasum.threshold5halfWidthStartDiff=nanmean(threshold5-halfWidthStart);
	datasum.threshold5halfWidthEndDiff=nanmean(threshold5-halfWidthEnd);
	datasum.threshold5dvMaxDiff=nanmean(threshold5-dvMax);
	datasum.threshold5dvMinDiff=nanmean(threshold5-dvMin);
	datasum.threshold5ahpDiff=nanmean(threshold5-ahp);	

	datasum.apEnd5apMaxDiff=nanmean(apMax-apEnd5);
	datasum.apEnd5threshold5Diff=nanmean(apEnd5-threshold5);
	datasum.apEnd5thresholdDiff=nanmean(apEnd5-threshold);
	datasum.apEnd5apEndDiff=nanmean(apEnd5-apEnd);
	datasum.apEnd5halfWidthStartDiff=nanmean(apEnd5-halfWidthStart);
	datasum.apEnd5halfWidthEndDiff=nanmean(apEnd5-halfWidthEnd);
	datasum.apEnd5dvMaxDiff=nanmean(apEnd5-dvMax);
	datasum.apEnd5dvMinDiff=nanmean(apEnd5-dvMin);
	datasum.apEnd5ahpDiff=nanmean(apEnd5-ahp);	
			
	datasum.apMaxthresholdDiff=nanmean(apMax-threshold);
	datasum.apMaxapEndDiff=nanmean(apMax-apEnd);
	datasum.apMaxhalfWidthStartDiff=nanmean(apMax-halfWidthStart);
	datasum.apMaxhalfWidthEndDiff=nanmean(apMax-halfWidthEnd);
	datasum.apMaxdvMaxDiff=nanmean(apMax-dvMax);
	datasum.apMaxdvMinDiff=nanmean(apMax-dvMin);
	datasum.apMaxahpDiff=nanmean(apMax-ahp);
	
	datasum.thresholdapEndDiff=nanmean(threshold-apEnd);
	datasum.thresholdhalfWidthStartDiff=nanmean(threshold-halfWidthStart);
	datasum.thresholdhalfWidthEndDiff=nanmean(threshold-halfWidthEnd);
	datasum.thresholddvMaxDiff=nanmean(threshold-dvMax);
	datasum.thresholddvMinDiff=nanmean(threshold-dvMin);
	datasum.thresholdahpDiff=nanmean(threshold-ahp);
	
	datasum.apEndhalfWidthStartDiff=nanmean(apEnd-halfWidthStart);
	datasum.apEndhalfWidthEndDiff=nanmean(apEnd-halfWidthEnd);
	datasum.apEnddvMaxDiff=nanmean(apEnd-dvMax);
	datasum.apEnddvMinDiff=nanmean(apEnd-dvMin);
	datasum.apEndahpDiff=nanmean(apEnd-ahp);
	
	datasum.halfWidthStarthalfWidthEndDiff=nanmean(halfWidthStart-halfWidthEnd);
	datasum.halfWidthStartdvMaxDiff=nanmean(halfWidthStart-dvMax);
	datasum.halfWidthStartdvMinDiff=nanmean(halfWidthStart-dvMin);
	datasum.halfWidthStartahpDiff=nanmean(halfWidthStart-ahp);
	
	datasum.halfWidthEnddvMaxDiff=nanmean(halfWidthEnd-dvMax);
	datasum.halfWidthEnddvMinDiff=nanmean(halfWidthEnd-dvMin);
	datasum.halfWidthEndahpDiff=nanmean(halfWidthEnd-ahp);
	
	datasum.dvMaxdvMinDiff=nanmean(dvMax-dvMin);
	datasum.dvMaxahpDiff=nanmean(dvMax-ahp);
	
	datasum.dvMinahpDiff=nanmean(dvMin-ahp);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%     AP time differences end     %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%     AP time differences std    %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	datasum.threshold5apMaxDiffStd=nanstd(apMax-threshold5);
	datasum.threshold5thresholdDiffStd=nanstd(threshold5-threshold);
	datasum.threshold5apEndDiffStd=nanstd(threshold5-apEnd);
	datasum.threshold5halfWidthStartDiffStd=nanstd(threshold5-halfWidthStart);
	datasum.threshold5halfWidthEndDiffStd=nanstd(threshold5-halfWidthEnd);
	datasum.threshold5dvMaxDiffStd=nanstd(threshold5-dvMax);
	datasum.threshold5dvMinDiffStd=nanstd(threshold5-dvMin);
	datasum.threshold5ahpDiffStd=nanstd(threshold5-ahp);	

	datasum.apEnd5apMaxDiffStd=nanstd(apMax-apEnd5);
	datasum.apEnd5threshold5DiffStd=nanstd(apEnd5-threshold5);
	datasum.apEnd5thresholdDiffStd=nanstd(apEnd5-threshold);
	datasum.apEnd5apEndDiffStd=nanstd(apEnd5-apEnd);
	datasum.apEnd5halfWidthStartDiffStd=nanstd(apEnd5-halfWidthStart);
	datasum.apEnd5halfWidthEndDiffStd=nanstd(apEnd5-halfWidthEnd);
	datasum.apEnd5dvMaxDiffStd=nanstd(apEnd5-dvMax);
	datasum.apEnd5dvMinDiffStd=nanstd(apEnd5-dvMin);
	datasum.apEnd5ahpDiffStd=nanstd(apEnd5-ahp);	
			
	datasum.apMaxthresholdDiffStd=nanstd(apMax-threshold);
	datasum.apMaxapEndDiffStd=nanstd(apMax-apEnd);
	datasum.apMaxhalfWidthStartDiffStd=nanstd(apMax-halfWidthStart);
	datasum.apMaxhalfWidthEndDiffStd=nanstd(apMax-halfWidthEnd);
	datasum.apMaxdvMaxDiffStd=nanstd(apMax-dvMax);
	datasum.apMaxdvMinDiffStd=nanstd(apMax-dvMin);
	datasum.apMaxahpDiffStd=nanstd(apMax-ahp);
	
	datasum.thresholdapEndDiffStd=nanstd(threshold-apEnd);
	datasum.thresholdhalfWidthStartDiffStd=nanstd(threshold-halfWidthStart);
	datasum.thresholdhalfWidthEndDiffStd=nanstd(threshold-halfWidthEnd);
	datasum.thresholddvMaxDiffStd=nanstd(threshold-dvMax);
	datasum.thresholddvMinDiffStd=nanstd(threshold-dvMin);
	datasum.thresholdahpDiffStd=nanstd(threshold-ahp);
	
	datasum.apEndhalfWidthStartDiffStd=nanstd(apEnd-halfWidthStart);
	datasum.apEndhalfWidthEndDiffStd=nanstd(apEnd-halfWidthEnd);
	datasum.apEnddvMaxDiffStd=nanstd(apEnd-dvMax);
	datasum.apEnddvMinDiffStd=nanstd(apEnd-dvMin);
	datasum.apEndahpDiffStd=nanstd(apEnd-ahp);
	
	datasum.halfWidthStarthalfWidthEndDiffStd=nanstd(halfWidthStart-halfWidthEnd);
	datasum.halfWidthStartdvMaxDiffStd=nanstd(halfWidthStart-dvMax);
	datasum.halfWidthStartdvMinDiffStd=nanstd(halfWidthStart-dvMin);
	datasum.halfWidthStartahpDiffStd=nanstd(halfWidthStart-ahp);
	
	datasum.halfWidthEnddvMaxDiffStd=nanstd(halfWidthEnd-dvMax);
	datasum.halfWidthEnddvMinDiffStd=nanstd(halfWidthEnd-dvMin);
	datasum.halfWidthEndahpDiffStd=nanstd(halfWidthEnd-ahp);
	
	datasum.dvMaxdvMinDiffStd=nanstd(dvMax-dvMin);
	datasum.dvMaxahpDiffStd=nanstd(dvMax-ahp);
	
	datasum.dvMinahpDiffStd=nanstd(dvMin-ahp);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%   AP time differences std end %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%     AP time differences min     %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	datasum.threshold5apMaxDiffMin=min(apMax-threshold5);
	datasum.threshold5thresholdDiffMin=min(threshold5-threshold);
	datasum.threshold5apEndDiffMin=min(threshold5-apEnd);
	datasum.threshold5halfWidthStartDiffMin=min(threshold5-halfWidthStart);
	datasum.threshold5halfWidthEndDiffMin=min(threshold5-halfWidthEnd);
	datasum.threshold5dvMaxDiffMin=min(threshold5-dvMax);
	datasum.threshold5dvMinDiffMin=min(threshold5-dvMin);
	datasum.threshold5ahpDiffMin=min(threshold5-ahp);	

	datasum.apEnd5apMaxDiffMin=min(apMax-apEnd5);
	datasum.apEnd5threshold5DiffMin=min(apEnd5-threshold5);
	datasum.apEnd5thresholdDiffMin=min(apEnd5-threshold);
	datasum.apEnd5apEndDiffMin=min(apEnd5-apEnd);
	datasum.apEnd5halfWidthStartDiffMin=min(apEnd5-halfWidthStart);
	datasum.apEnd5halfWidthEndDiffMin=min(apEnd5-halfWidthEnd);
	datasum.apEnd5dvMaxDiffMin=min(apEnd5-dvMax);
	datasum.apEnd5dvMinDiffMin=min(apEnd5-dvMin);
	datasum.apEnd5ahpDiffMin=min(apEnd5-ahp);		
			
	datasum.apMaxthresholdDiffMin=min(apMax-threshold);
	datasum.apMaxapEndDiffMin=min(apMax-apEnd);
	datasum.apMaxhalfWidthStartDiffMin=min(apMax-halfWidthStart);
	datasum.apMaxhalfWidthEndDiffMin=min(apMax-halfWidthEnd);
	datasum.apMaxdvMaxDiffMin=min(apMax-dvMax);
	datasum.apMaxdvMinDiffMin=min(apMax-dvMin);
	datasum.apMaxahpDiffMin=min(apMax-ahp);
	
	datasum.thresholdapEndDiffMin=min(threshold-apEnd);
	datasum.thresholdhalfWidthStartDiffMin=min(threshold-halfWidthStart);
	datasum.thresholdhalfWidthEndDiffMin=min(threshold-halfWidthEnd);
	datasum.thresholddvMaxDiffMin=min(threshold-dvMax);
	datasum.thresholddvMinDiffMin=min(threshold-dvMin);
	datasum.thresholdahpDiffMin=min(threshold-ahp);
	
	datasum.apEndhalfWidthStartDiffMin=min(apEnd-halfWidthStart);
	datasum.apEndhalfWidthEndDiffMin=min(apEnd-halfWidthEnd);
	datasum.apEnddvMaxDiffMin=min(apEnd-dvMax);
	datasum.apEnddvMinDiffMin=min(apEnd-dvMin);
	datasum.apEndahpDiffMin=min(apEnd-ahp);
	
	datasum.halfWidthStarthalfWidthEndDiffMin=min(halfWidthStart-halfWidthEnd);
	datasum.halfWidthStartdvMaxDiffMin=min(halfWidthStart-dvMax);
	datasum.halfWidthStartdvMinDiffMin=min(halfWidthStart-dvMin);
	datasum.halfWidthStartahpDiffMin=min(halfWidthStart-ahp);
	
	datasum.halfWidthEnddvMaxDiffMin=min(halfWidthEnd-dvMax);
	datasum.halfWidthEnddvMinDiffMin=min(halfWidthEnd-dvMin);
	datasum.halfWidthEndahpDiffMin=min(halfWidthEnd-ahp);
	
	datasum.dvMaxdvMinDiffMin=min(dvMax-dvMin);
	datasum.dvMaxahpDiffMin=min(dvMax-ahp);
	
	datasum.dvMinahpDiffMin=min(dvMin-ahp);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%    AP time differences min END  %%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%     AP time differences max     %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	datasum.threshold5apMaxDiffMax=max(apMax-threshold5);
	datasum.threshold5thresholdDiffMax=max(threshold5-threshold);
	datasum.threshold5apEndDiffMax=max(threshold5-apEnd);
	datasum.threshold5halfWidthStartDiffMax=max(threshold5-halfWidthStart);
	datasum.threshold5halfWidthEndDiffMax=max(threshold5-halfWidthEnd);
	datasum.threshold5dvMaxDiffMax=max(threshold5-dvMax);
	datasum.threshold5dvMinDiffMax=max(threshold5-dvMax);
	datasum.threshold5ahpDiffMax=max(threshold5-ahp);	

	datasum.apEnd5apMaxDiffMax=max(apMax-apEnd5);
	datasum.apEnd5threshold5DiffMax=max(apEnd5-threshold5);
	datasum.apEnd5thresholdDiffMax=max(apEnd5-threshold);
	datasum.apEnd5apEndDiffMax=max(apEnd5-apEnd);
	datasum.apEnd5halfWidthStartDiffMax=max(apEnd5-halfWidthStart);
	datasum.apEnd5halfWidthEndDiffMax=max(apEnd5-halfWidthEnd);
	datasum.apEnd5dvMaxDiffMax=max(apEnd5-dvMax);
	datasum.apEnd5dvMinDiffMax=max(apEnd5-dvMax);
	datasum.apEnd5ahpDiffMax=max(apEnd5-ahp);		
	
	datasum.apMaxthresholdDiffMax=max(apMax-threshold);
	datasum.apMaxapEndDiffMax=max(apMax-apEnd);
	datasum.apMaxhalfWidthStartDiffMax=max(apMax-halfWidthStart);
	datasum.apMaxhalfWidthEndDiffMax=max(apMax-halfWidthEnd);
	datasum.apMaxdvMaxDiffMax=max(apMax-dvMax);
	datasum.apMaxdvMinDiffMax=max(apMax-dvMin);
	datasum.apMaxahpDiffMax=max(apMax-ahp);
	
	datasum.thresholdapEndDiffMax=max(threshold-apEnd);
	datasum.thresholdhalfWidthStartDiffMax=max(threshold-halfWidthStart);
	datasum.thresholdhalfWidthEndDiffMax=max(threshold-halfWidthEnd);
	datasum.thresholddvMaxDiffMax=max(threshold-dvMax);
	datasum.thresholddvMinDiffMax=max(threshold-dvMin);
	datasum.thresholdahpDiffMax=max(threshold-ahp);
	
	datasum.apEndhalfWidthStartDiffMax=max(apEnd-halfWidthStart);
	datasum.apEndhalfWidthEndDiffMax=max(apEnd-halfWidthEnd);
	datasum.apEnddvMaxDiffMax=max(apEnd-dvMax);
	datasum.apEnddvMinDiffMax=max(apEnd-dvMin);
	datasum.apEndahpDiffMax=max(apEnd-ahp);
	
	datasum.halfWidthStarthalfWidthEndDiffMax=max(halfWidthStart-halfWidthEnd);
	datasum.halfWidthStartdvMaxDiffMax=max(halfWidthStart-dvMax);
	datasum.halfWidthStartdvMinDiffMax=max(halfWidthStart-dvMin);
	datasum.halfWidthStartahpDiffMax=max(halfWidthStart-ahp);
	
	datasum.halfWidthEnddvMaxDiffMax=max(halfWidthEnd-dvMax);
	datasum.halfWidthEnddvMinDiffMax=max(halfWidthEnd-dvMin);
	datasum.halfWidthEndahpDiffMax=max(halfWidthEnd-ahp);
	
	datasum.dvMaxdvMinDiffMax=max(dvMax-dvMin);
	datasum.dvMaxahpDiffMax=max(dvMax-ahp);
	
	datasum.dvMinahpDiffMax=max(dvMin-ahp);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%    AP time differences max END  %%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
end
