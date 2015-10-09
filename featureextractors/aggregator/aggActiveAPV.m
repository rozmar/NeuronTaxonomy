

function datasum = aggActiveAPV(cell,current,datasum)

	%load the names of the AP features
	load('/home/borde/Munka/NeuroScience/featureextractors/apFeatures.mat','featS');
	apFeatures = cell.apFeatures;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%% Get Voltages  %%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	dvrs = cell.dvrs;
	v0 = cell.v0;
	apMaxVReal=cell.apFeatures(:,featS.apMaxReal);
	
	thresholdVReal=cell.apFeatures(:,featS.thresholdVReal);
	threshold5VReal = (cell.apFeatures(:,featS.threshold5V)+dvrs(cell.apFeatures(:,1)));
	
	apEndV=(cell.apFeatures(:,featS.apEndV)+dvrs(cell.apFeatures(:,1)));
	apEnd5V=(cell.apFeatures(:,featS.apEnd5V)+dvrs(cell.apFeatures(:,1)));
	
	halfWidhtV=cell.apFeatures(:,featS.halfWidthV)+dvrs(cell.apFeatures(:,1));
	
	dvMaxVReal=cell.apFeatures(:,featS.dvMaxVReal);
	dvMinVReal=cell.apFeatures(:,featS.dvMinVReal);
	
	ahpV=cell.apFeatures(:,featS.ahpV)+dvrs(cell.apFeatures(:,1));
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%% Get Voltages END %%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%% Feature Voltages in absolute value, min and max, std  %%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	datasum.apMaxVReal=nanmean(apMaxVReal);
	datasum.apMaxVRealMin=min(apMaxVReal);
	datasum.apMaxVRealMax=max(apMaxVReal);
	datasum.apMaxVRealStd=nanstd(apMaxVReal);
	
	datasum.thresholdVReal=nanmean(thresholdVReal);
	datasum.thresholdVRealMin=min(thresholdVReal);
	datasum.thresholdVRealMax=max(thresholdVReal);
	datasum.thresholdVRealStd=nanstd(thresholdVReal);
	
	datasum.apEndV=nanmean(apEndV);
	datasum.apEndVMin=min(apEndV);
	datasum.apEndVMax=max(apEndV);
	datasum.apEndVStd=nanstd(apEndV);
	
	datasum.threshold5VReal=nanmean(threshold5VReal);
	datasum.threshold5VRealMin=min(threshold5VReal);
	datasum.threshold5VRealMax=max(threshold5VReal);
	datasum.threshold5VRealStd=nanstd(threshold5VReal);
	
	datasum.apEnd5V=nanmean(apEnd5V);
	datasum.apEnd5VMin=min(apEnd5V);
	datasum.apEnd5VMax=max(apEnd5V);
	datasum.apEnd5VStd=nanstd(apEnd5V);
	
	datasum.halfWidhtV=nanmean(halfWidhtV);
	datasum.halfWidhtVMin=min(halfWidhtV);
	datasum.halfWidhtVMax=max(halfWidhtV);
	datasum.halfWidhtVStd=nanstd(halfWidhtV);
	
	datasum.dvMaxVReal=nanmean(dvMaxVReal);
	datasum.dvMaxVRealMin=min(dvMaxVReal);
	datasum.dvMaxVRealMax=max(dvMaxVReal);
	datasum.dvMaxVRealStd=nanstd(dvMaxVReal);
	
	datasum.dvMinVReal=nanmean(dvMinVReal);
	datasum.dvMinVRealMin=min(dvMinVReal);
	datasum.dvMinVRealMax=max(dvMinVReal);
	datasum.dvMinVRealStd=nanstd(dvMinVReal);
	
	datasum.ahpV=nanmean(ahpV);
	datasum.ahpVMin=min(ahpV);
	datasum.ahpVMax=max(ahpV);
	datasum.ahpVStd=nanstd(ahpV);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%% Feature Voltages in absolute value, min and max, std END %%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%% AP Voltages diff from v0  %%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	sweepNum = cell.apFeatures(:,featS.sweepNum);
	
	datasum.apMaxVRealV0Diff =nanmean(apMaxVReal-v0(sweepNum));
	datasum.apMaxVRealV0DiffMin =min(apMaxVReal-v0(sweepNum));
	datasum.apMaxVRealV0DiffMax =max(apMaxVReal-v0(sweepNum));
	datasum.apMaxVRealV0DiffStd =nanstd(apMaxVReal-v0(sweepNum));
	
	datasum.thresholdVRealV0Diff =nanmean(thresholdVReal-v0(sweepNum));
	datasum.thresholdVRealV0DiffMin =min(thresholdVReal-v0(sweepNum));
	datasum.thresholdVRealV0DiffMax =max(thresholdVReal-v0(sweepNum));
	datasum.thresholdVRealV0DiffStd =nanstd(thresholdVReal-v0(sweepNum));
	
	datasum.apEndVV0Diff =nanmean(apEndV-v0(sweepNum));
	datasum.apEndVV0DiffMin =min(apEndV-v0(sweepNum));
	datasum.apEndVV0DiffMax =max(apEndV-v0(sweepNum));
	datasum.apEndVV0DiffStd =nanstd(apEndV-v0(sweepNum));
	
	datasum.threshold5VRealV0Diff =nanmean(threshold5VReal-v0(sweepNum));
	datasum.threshold5VRealV0DiffMin =min(threshold5VReal-v0(sweepNum));
	datasum.threshold5VRealV0DiffMax =max(threshold5VReal-v0(sweepNum));
	datasum.threshold5VRealV0DiffStd =nanstd(threshold5VReal-v0(sweepNum));
	
	datasum.apEnd5VV0Diff =nanmean(apEnd5V-v0(sweepNum));
	datasum.apEnd5VV0DiffMin =min(apEnd5V-v0(sweepNum));
	datasum.apEnd5VV0DiffMax =max(apEnd5V-v0(sweepNum));
	datasum.apEnd5VV0DiffStd =nanstd(apEnd5V-v0(sweepNum));
	
	datasum.halfWidhtVV0Diff =nanmean(halfWidhtV-v0(sweepNum));
	datasum.halfWidhtVV0DiffMin =min(halfWidhtV-v0(sweepNum));
	datasum.halfWidhtVV0DiffMax =max(halfWidhtV-v0(sweepNum));
	datasum.halfWidhtVV0DiffStd =nanstd(halfWidhtV-v0(sweepNum));
	
	datasum.dvMaxVRealV0Diff =nanmean(dvMaxVReal-v0(sweepNum));
	datasum.dvMaxVRealV0DiffMin =min(dvMaxVReal-v0(sweepNum));
	datasum.dvMaxVRealV0DiffMax =max(dvMaxVReal-v0(sweepNum));
	datasum.dvMaxVRealV0DiffStd =nanstd(dvMaxVReal-v0(sweepNum));
	
	datasum.dvMinVRealV0Diff =nanmean(dvMinVReal-v0(sweepNum));
	datasum.dvMinVRealV0DiffMin =min(dvMinVReal-v0(sweepNum));
	datasum.dvMinVRealV0DiffMax =max(dvMinVReal-v0(sweepNum));
	datasum.dvMinVRealV0DiffStd =nanstd(dvMinVReal-v0(sweepNum));
	
	datasum.ahpVV0Diff =nanmean(ahpV-v0(sweepNum));
	datasum.ahpVV0DiffMin =min(ahpV-v0(sweepNum));
	datasum.ahpVV0DiffMax =max(ahpV-v0(sweepNum));
	datasum.ahpVV0DiffStd =nanstd(ahpV-v0(sweepNum));
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	%%%%%%%%%%%%% AP Voltages diff from v0 END %%%%%%%%%%%%	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%   AP Voltages quotients    %%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	datasum.apMaxVRealthresholdVRealQuot=nanmean(apMaxVReal./thresholdVReal);
	datasum.apMaxVRealapEndVQuot=nanmean(apMaxVReal./apEndV);
	datasum.apMaxVRealhalfWidhtVQuot=nanmean(apMaxVReal./halfWidhtV);
	datasum.apMaxVRealdvMaxVRealQuot=nanmean(apMaxVReal./dvMaxVReal);
	datasum.apMaxVRealdvMinVRealQuot=nanmean(apMaxVReal./dvMinVReal);
	datasum.apMaxVRealahpVQuot=nanmean(apMaxVReal./ahpV);
	
	datasum.threshold5VRealapMaxVRealQuot=nanmean(threshold5VReal./apMaxVReal);
	datasum.threshold5VRealthresholdVRealQuot=nanmean(threshold5VReal./thresholdVReal);
	datasum.threshold5VRealapEndVQuot=nanmean(threshold5VReal./apEndV);
	datasum.threshold5VRealhalfWidhtVQuot=nanmean(threshold5VReal./halfWidhtV);
	datasum.threshold5VRealdvMaxVRealQuot=nanmean(threshold5VReal./dvMaxVReal);
	datasum.threshold5VRealdvMinVRealQuot=nanmean(threshold5VReal./dvMinVReal);
	datasum.threshold5VRealahpVQuot=nanmean(threshold5VReal./ahpV);
	
	datasum.apEnd5VapMaxVRealQuot=nanmean(apEnd5V./apMaxVReal);
	datasum.apEnd5VthresholdVRealQuot=nanmean(apEnd5V./thresholdVReal);
	datasum.apEnd5VapEndVQuot=nanmean(apEnd5V./apEndV);
	datasum.apEnd5VhalfWidhtVQuot=nanmean(apEnd5V./halfWidhtV);
	datasum.apEnd5VdvMaxVRealQuot=nanmean(apEnd5V./dvMaxVReal);
	datasum.apEnd5VdvMinVRealQuot=nanmean(apEnd5V./dvMinVReal);
	datasum.apEnd5VahpVQuot=nanmean(apEnd5V./ahpV);
	
	datasum.thresholdVRealapEndVQuot=nanmean(thresholdVReal./apEndV);
	datasum.thresholdVRealhalfWidhtVQuot=nanmean(thresholdVReal./halfWidhtV);
	datasum.thresholdVRealdvMaxVRealQuot=nanmean(thresholdVReal./dvMaxVReal);
	datasum.thresholdVRealdvMinVRealQuot=nanmean(thresholdVReal./dvMinVReal);
	datasum.thresholdVRealahpVQuot=nanmean(thresholdVReal./ahpV);
	
	datasum.apEndVhalfWidhtVQuot=nanmean(apEndV./halfWidhtV);
	datasum.apEndVdvMaxVRealQuot=nanmean(apEndV./dvMaxVReal);
	datasum.apEndVdvMinVRealQuot=nanmean(apEndV./dvMinVReal);
	datasum.apEndVahpVQuot=nanmean(apEndV./ahpV);
	
	datasum.halfWidhtVdvMaxVRealQuot=nanmean(halfWidhtV./dvMaxVReal);
	datasum.halfWidhtVdvMinVRealQuot=nanmean(halfWidhtV./dvMinVReal);
	datasum.halfWidhtVahpVQuot=nanmean(halfWidhtV./ahpV);
	
	datasum.dvMaxVRealdvMinVRealQuot=nanmean(dvMaxVReal./dvMinVReal);
	datasum.dvMaxVRealahpVQuot=nanmean(dvMaxVReal./ahpV);
	
	datasum.dvMinVRealahpVQuot=nanmean(dvMinVReal./ahpV);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%% AP Voltages quotients END %%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%   AP Voltages differences  %%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	datasum.apMaxVRealthresholdVRealDiff=nanmean(apMaxVReal-thresholdVReal);
	datasum.apMaxVRealapEndVDiff=nanmean(apMaxVReal-apEndV);
	datasum.apMaxVRealhalfWidhtVDiff=nanmean(apMaxVReal-halfWidhtV);
	datasum.apMaxVRealdvMaxVRealDiff=nanmean(apMaxVReal-dvMaxVReal);
	datasum.apMaxVRealdvMinVRealDiff=nanmean(apMaxVReal-dvMinVReal);
	datasum.apMaxVRealahpVDiff=nanmean(apMaxVReal-ahpV);
	
	datasum.thresholdVRealapEndVDiff=nanmean(thresholdVReal-apEndV);
	datasum.thresholdVRealhalfWidhtVDiff=nanmean(thresholdVReal-halfWidhtV);
	datasum.thresholdVRealdvMaxVRealDiff=nanmean(thresholdVReal-dvMaxVReal);
	datasum.thresholdVRealdvMinVRealDiff=nanmean(thresholdVReal-dvMinVReal);
	datasum.thresholdVRealahpVDiff=nanmean(thresholdVReal-ahpV);
	
	datasum.threshold5VRealapMaxVRealQuot=nanmean(threshold5VReal-apMaxVReal);
	datasum.threshold5VRealthresholdVRealQuot=nanmean(threshold5VReal-thresholdVReal);
	datasum.threshold5VRealapEndVQuot=nanmean(threshold5VReal-apEndV);
	datasum.threshold5VRealhalfWidhtVQuot=nanmean(threshold5VReal-halfWidhtV);
	datasum.threshold5VRealdvMaxVRealQuot=nanmean(threshold5VReal-dvMaxVReal);
	datasum.threshold5VRealdvMinVRealQuot=nanmean(threshold5VReal-dvMinVReal);
	datasum.threshold5VRealahpVQuot=nanmean(threshold5VReal-ahpV);	
	
	datasum.apEnd5VapMaxVRealQuot=nanmean(apEnd5V-apMaxVReal);
	datasum.apEnd5VthresholdVRealQuot=nanmean(apEnd5V-thresholdVReal);
	datasum.apEnd5VapEndVQuot=nanmean(apEnd5V-apEndV);
	datasum.apEnd5VhalfWidhtVQuot=nanmean(apEnd5V-halfWidhtV);
	datasum.apEnd5VdvMaxVRealQuot=nanmean(apEnd5V-dvMaxVReal);
	datasum.apEnd5VdvMinVRealQuot=nanmean(apEnd5V-dvMinVReal);
	datasum.apEnd5VahpVQuot=nanmean(apEnd5V-ahpV);
	
	datasum.apEndVhalfWidhtVDiff=nanmean(apEndV-halfWidhtV);
	datasum.apEndVdvMaxVRealDiff=nanmean(apEndV-dvMaxVReal);
	datasum.apEndVdvMinVRealDiff=nanmean(apEndV-dvMinVReal);
	datasum.apEndVahpVDiff=nanmean(apEndV-ahpV);
	
	datasum.halfWidhtVdvMaxVRealDiff=nanmean(halfWidhtV-dvMaxVReal);
	datasum.halfWidhtVdvMinVRealDiff=nanmean(halfWidhtV-dvMinVReal);
	datasum.halfWidhtVahpVDiff=nanmean(halfWidhtV-ahpV);
	
	datasum.dvMaxVRealdvMinVRealDiff=nanmean(dvMaxVReal-dvMinVReal);
	datasum.dvMaxVRealahpVDiff=nanmean(dvMaxVReal-ahpV);
	
	datasum.dvMinVRealahpVDiff=nanmean(dvMinVReal-ahpV);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%   AP Voltages differences END   %%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%      AP Voltage quotients stdev %%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	datasum.apMaxVRealthresholdVRealQuotStd=nanstd(apMaxVReal./thresholdVReal);
	datasum.apMaxVRealapEndVQuotStd=nanstd(apMaxVReal./apEndV);
	datasum.apMaxVRealhalfWidhtVQuotStd=nanstd(apMaxVReal./halfWidhtV);
	datasum.apMaxVRealdvMaxVRealQuotStd=nanstd(apMaxVReal./dvMaxVReal);
	datasum.apMaxVRealdvMinVRealQuotStd=nanstd(apMaxVReal./dvMinVReal);
	datasum.apMaxVRealahpVQuotStd=nanstd(apMaxVReal./ahpV);
	
	datasum.thresholdVRealapEndVQuotStd=nanstd(thresholdVReal./apEndV);
	datasum.thresholdVRealhalfWidhtVQuotStd=nanstd(thresholdVReal./halfWidhtV);
	datasum.thresholdVRealdvMaxVRealQuotStd=nanstd(thresholdVReal./dvMaxVReal);
	datasum.thresholdVRealdvMinVRealQuotStd=nanstd(thresholdVReal./dvMinVReal);
	datasum.thresholdVRealahpVQuotStd=nanstd(thresholdVReal./ahpV);
	
	datasum.apEndVhalfWidhtVQuotStd=nanstd(apEndV./halfWidhtV);
	datasum.apEndVdvMaxVRealQuotStd=nanstd(apEndV./dvMaxVReal);
	datasum.apEndVdvMinVRealQuotStd=nanstd(apEndV./dvMinVReal);
	datasum.apEndVahpVQuotStd=nanstd(apEndV./ahpV);
	
	datasum.threshold5VRealapMaxVRealQuotStd=nanstd(threshold5VReal./apMaxVReal);
	datasum.threshold5VRealthresholdVRealQuotStd=nanstd(threshold5VReal./thresholdVReal);
	datasum.threshold5VRealapEndVQuotStd=nanstd(threshold5VReal./apEndV);
	datasum.threshold5VRealhalfWidhtVQuotStd=nanstd(threshold5VReal./halfWidhtV);
	datasum.threshold5VRealdvMaxVRealQuotStd=nanstd(threshold5VReal./dvMaxVReal);
	datasum.threshold5VRealdvMinVRealQuotStd=nanstd(threshold5VReal./dvMinVReal);
	datasum.threshold5VRealahpVQuotStd=nanstd(threshold5VReal./ahpV);	
	
	datasum.apEnd5VapMaxVRealQuotStd=nanstd(apEnd5V./apMaxVReal);
	datasum.apEnd5VthresholdVRealQuotStd=nanstd(apEnd5V./thresholdVReal);
	datasum.apEnd5VapEndVQuotStd=nanstd(apEnd5V./apEndV);
	datasum.apEnd5VhalfWidhtVQuotStd=nanstd(apEnd5V./halfWidhtV);
	datasum.apEnd5VdvMaxVRealQuotStd=nanstd(apEnd5V./dvMaxVReal);
	datasum.apEnd5VdvMinVRealQuotStd=nanstd(apEnd5V./dvMinVReal);
	datasum.apEnd5VahpVQuotStd=nanstd(apEnd5V./ahpV);
	
	datasum.halfWidhtVdvMaxVRealQuotStd=nanstd(halfWidhtV./dvMaxVReal);
	datasum.halfWidhtVdvMinVRealQuotStd=nanstd(halfWidhtV./dvMinVReal);
	datasum.halfWidhtVahpVQuotStd=nanstd(halfWidhtV./ahpV);
	
	datasum.dvMaxVRealdvMinVRealQuotStd=nanstd(dvMaxVReal./dvMinVReal);
	datasum.dvMaxVRealahpVQuotStd=nanstd(dvMaxVReal./ahpV);
	
	datasum.dvMinVRealahpVQuotStd=nanstd(dvMinVReal./ahpV);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%  AP Voltage quotients stdev END %%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%  AP Voltage differences stdev %%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
	datasum.apMaxVRealthresholdVRealDiffStd=nanstd(apMaxVReal-thresholdVReal);
	datasum.apMaxVRealapEndVDiffStd=nanstd(apMaxVReal-apEndV);
	datasum.apMaxVRealhalfWidhtVDiffStd=nanstd(apMaxVReal-halfWidhtV);
	datasum.apMaxVRealdvMaxVRealDiffStd=nanstd(apMaxVReal-dvMaxVReal);
	datasum.apMaxVRealdvMinVRealDiffStd=nanstd(apMaxVReal-dvMinVReal);
	datasum.apMaxVRealahpVDiffStd=nanstd(apMaxVReal-ahpV);
	
	datasum.thresholdVRealapEndVDiffStd=nanstd(thresholdVReal-apEndV);
	datasum.thresholdVRealhalfWidhtVDiffStd=nanstd(thresholdVReal-halfWidhtV);
	datasum.thresholdVRealdvMaxVRealDiffStd=nanstd(thresholdVReal-dvMaxVReal);
	datasum.thresholdVRealdvMinVRealDiffStd=nanstd(thresholdVReal-dvMinVReal);
	datasum.thresholdVRealahpVDiffStd=nanstd(thresholdVReal-ahpV);
	
	datasum.apEndVhalfWidhtVDiffStd=nanstd(apEndV-halfWidhtV);
	datasum.apEndVdvMaxVRealDiffStd=nanstd(apEndV-dvMaxVReal);
	datasum.apEndVdvMinVRealDiffStd=nanstd(apEndV-dvMinVReal);
	datasum.apEndVahpVDiffStd=nanstd(apEndV-ahpV);
	
	datasum.threshold5VRealapMaxVRealQuotStd=nanstd(threshold5VReal-apMaxVReal);
	datasum.threshold5VRealthresholdVRealQuotStd=nanstd(threshold5VReal-thresholdVReal);
	datasum.threshold5VRealapEndVQuotStd=nanstd(threshold5VReal-apEndV);
	datasum.threshold5VRealhalfWidhtVQuotStd=nanstd(threshold5VReal-halfWidhtV);
	datasum.threshold5VRealdvMaxVRealQuotStd=nanstd(threshold5VReal-dvMaxVReal);
	datasum.threshold5VRealdvMinVRealQuotStd=nanstd(threshold5VReal-dvMinVReal);
	datasum.threshold5VRealahpVQuotStd=nanstd(threshold5VReal-ahpV);	
	
	datasum.apEnd5VapMaxVRealQuotStd=nanstd(apEnd5V-apMaxVReal);
	datasum.apEnd5VthresholdVRealQuotStd=nanstd(apEnd5V-thresholdVReal);
	datasum.apEnd5VapEndVQuotStd=nanstd(apEnd5V-apEndV);
	datasum.apEnd5VhalfWidhtVQuotStd=nanstd(apEnd5V-halfWidhtV);
	datasum.apEnd5VdvMaxVRealQuotStd=nanstd(apEnd5V-dvMaxVReal);
	datasum.apEnd5VdvMinVRealQuotStd=nanstd(apEnd5V-dvMinVReal);
	datasum.apEnd5VahpVQuotStd=nanstd(apEnd5V-ahpV);		
	
	datasum.halfWidhtVdvMaxVRealDiffStd=nanstd(halfWidhtV-dvMaxVReal);
	datasum.halfWidhtVdvMinVRealDiffStd=nanstd(halfWidhtV-dvMinVReal);
	datasum.halfWidhtVahpVDiffStd=nanstd(halfWidhtV-ahpV);
	
	datasum.dvMaxVRealdvMinVRealDiffStd=nanstd(dvMaxVReal-dvMinVReal);
	datasum.dvMaxVRealahpVDiffStd=nanstd(dvMaxVReal-ahpV);
	
	datasum.dvMinVRealahpVDiffStd=nanstd(dvMinVReal-ahpV);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%  AP Voltage differences stdev END %%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%  AP Voltage quotients min-max END %%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	datasum.apMaxVRealthresholdVRealQuotMin=min(apMaxVReal./thresholdVReal);
	datasum.apMaxVRealthresholdVRealQuotMax=max(apMaxVReal./thresholdVReal);
	datasum.apMaxVRealapEndVQuotMin=min(apMaxVReal./apEndV);
	datasum.apMaxVRealapEndVQuotMax=max(apMaxVReal./apEndV);
	datasum.apMaxVRealhalfWidhtVQuotMin=min(apMaxVReal./halfWidhtV);
	datasum.apMaxVRealhalfWidhtVQuotMax=max(apMaxVReal./halfWidhtV);
	datasum.apMaxVRealdvMaxVRealQuotMin=min(apMaxVReal./dvMaxVReal);
	datasum.apMaxVRealdvMaxVRealQuotMax=max(apMaxVReal./dvMaxVReal);
	datasum.apMaxVRealdvMinVRealQuotMin=min(apMaxVReal./dvMinVReal);
	datasum.apMaxVRealdvMinVRealQuotMax=max(apMaxVReal./dvMinVReal);
	datasum.apMaxVRealahpVQuotMin=min(apMaxVReal./ahpV);
	datasum.apMaxVRealahpVQuotMax=max(apMaxVReal./ahpV);
	
	datasum.threshold5VRealapMaxVRealQuotMin=min(threshold5VReal./apMaxVReal);
	datasum.threshold5VRealthresholdVRealQuotMin=min(threshold5VReal./thresholdVReal);
	datasum.threshold5VRealapEndVQuotMin=min(threshold5VReal./apEndV);
	datasum.threshold5VRealhalfWidhtVQuotMin=min(threshold5VReal./halfWidhtV);
	datasum.threshold5VRealdvMaxVRealQuotMin=min(threshold5VReal./dvMaxVReal);
	datasum.threshold5VRealdvMinVRealQuotMin=min(threshold5VReal./dvMinVReal);
	datasum.threshold5VRealahpVQuotMin=min(threshold5VReal./ahpV);	
	datasum.apEnd5VapMaxVRealQuotMin=min(apEnd5V./apMaxVReal);
	datasum.apEnd5VthresholdVRealQuotMin=min(apEnd5V./thresholdVReal);
	datasum.apEnd5VapEndVQuotMin=min(apEnd5V./apEndV);
	datasum.apEnd5VhalfWidhtVQuotMin=min(apEnd5V./halfWidhtV);
	datasum.apEnd5VdvMaxVRealQuotMin=min(apEnd5V./dvMaxVReal);
	datasum.apEnd5VdvMinVRealQuotMin=min(apEnd5V./dvMinVReal);
	datasum.apEnd5VahpVQuotMin=min(apEnd5V./ahpV);
	datasum.threshold5VRealapMaxVRealQuotMax=max(threshold5VReal./apMaxVReal);
	datasum.threshold5VRealthresholdVRealQuotMax=max(threshold5VReal./thresholdVReal);
	datasum.threshold5VRealapEndVQuotMax=max(threshold5VReal./apEndV);
	datasum.threshold5VRealhalfWidhtVQuotMax=max(threshold5VReal./halfWidhtV);
	datasum.threshold5VRealdvMaxVRealQuotMax=max(threshold5VReal./dvMaxVReal);
	datasum.threshold5VRealdvMinVRealQuotMax=max(threshold5VReal./dvMinVReal);
	datasum.threshold5VRealahpVQuotMax=max(threshold5VReal./ahpV);
	datasum.apEnd5VapMaxVRealQuotMax=max(apEnd5V./apMaxVReal);
	datasum.apEnd5VthresholdVRealQuotMax=max(apEnd5V./thresholdVReal);
	datasum.apEnd5VapEndVQuotMax=max(apEnd5V./apEndV);
	datasum.apEnd5VhalfWidhtVQuotMax=max(apEnd5V./halfWidhtV);
	datasum.apEnd5VdvMaxVRealQuotMax=max(apEnd5V./dvMaxVReal);
	datasum.apEnd5VdvMinVRealQuotMax=max(apEnd5V./dvMinVReal);
	datasum.apEnd5VahpVQuotMax=max(apEnd5V./ahpV);	
	
	datasum.thresholdVRealapEndVQuotMin=min(thresholdVReal./apEndV);
	datasum.thresholdVRealapEndVQuotMax=max(thresholdVReal./apEndV);
	datasum.thresholdVRealhalfWidhtVQuotMin=min(thresholdVReal./halfWidhtV);
	datasum.thresholdVRealhalfWidhtVQuotMax=max(thresholdVReal./halfWidhtV);
	datasum.thresholdVRealdvMaxVRealQuotMin=min(thresholdVReal./dvMaxVReal);
	datasum.thresholdVRealdvMaxVRealQuotMax=max(thresholdVReal./dvMaxVReal);
	datasum.thresholdVRealdvMinVRealQuotMin=min(thresholdVReal./dvMinVReal);
	datasum.thresholdVRealdvMinVRealQuotMax=max(thresholdVReal./dvMinVReal);
	datasum.thresholdVRealahpVQuotMin=min(thresholdVReal./ahpV);
	datasum.thresholdVRealahpVQuotMax=max(thresholdVReal./ahpV);
	
	datasum.apEndVhalfWidhtVQuotMin=min(apEndV./halfWidhtV);
	datasum.apEndVhalfWidhtVQuotMax=max(apEndV./halfWidhtV);
	datasum.apEndVdvMaxVRealQuotMin=min(apEndV./dvMaxVReal);
	datasum.apEndVdvMaxVRealQuotMax=max(apEndV./dvMaxVReal);
	datasum.apEndVdvMinVRealQuotMin=min(apEndV./dvMinVReal);
	datasum.apEndVdvMinVRealQuotMax=max(apEndV./dvMinVReal);
	datasum.apEndVahpVQuotMin=min(apEndV./ahpV);
	datasum.apEndVahpVQuotMax=max(apEndV./ahpV);
	
	datasum.halfWidhtVdvMaxVRealQuotMin=min(halfWidhtV./dvMaxVReal);
	datasum.halfWidhtVdvMaxVRealQuotMax=max(halfWidhtV./dvMaxVReal);
	datasum.halfWidhtVdvMinVRealQuotMin=min(halfWidhtV./dvMinVReal);
	datasum.halfWidhtVdvMinVRealQuotMax=max(halfWidhtV./dvMinVReal);
	datasum.halfWidhtVahpVQuotMin=min(halfWidhtV./ahpV);
	datasum.halfWidhtVahpVQuotMax=max(halfWidhtV./ahpV);
	
	datasum.dvMaxVRealdvMinVRealQuotMin=min(dvMaxVReal./dvMinVReal);
	datasum.dvMaxVRealdvMinVRealQuotMax=max(dvMaxVReal./dvMinVReal);
	datasum.dvMaxVRealahpVQuotMin=min(dvMaxVReal./ahpV);
	datasum.dvMaxVRealahpVQuotMax=max(dvMaxVReal./ahpV);
	
	datasum.dvMinVRealahpVQuotMin=min(dvMinVReal./ahpV);
	datasum.dvMinVRealahpVQuotMax=max(dvMinVReal./ahpV);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%% AP Voltage quotients min-max END %%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%% AP Voltage differences min-max END %%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	datasum.apMaxVRealthresholdVRealDiffMin=min(apMaxVReal-thresholdVReal);
	datasum.apMaxVRealthresholdVRealDiffMax=max(apMaxVReal-thresholdVReal);
	datasum.apMaxVRealapEndVDiffMin=min(apMaxVReal-apEndV);
	datasum.apMaxVRealapEndVDiffMax=max(apMaxVReal-apEndV);
	datasum.apMaxVRealhalfWidhtVDiffMin=min(apMaxVReal-halfWidhtV);
	datasum.apMaxVRealhalfWidhtVDiffMax=max(apMaxVReal-halfWidhtV);
	datasum.apMaxVRealdvMaxVRealDiffMin=min(apMaxVReal-dvMaxVReal);
	datasum.apMaxVRealdvMaxVRealDiffMax=max(apMaxVReal-dvMaxVReal);
	datasum.apMaxVRealdvMinVRealDiffMin=min(apMaxVReal-dvMinVReal);
	datasum.apMaxVRealdvMinVRealDiffMax=max(apMaxVReal-dvMinVReal);
	datasum.apMaxVRealahpVDiffMin=min(apMaxVReal-ahpV);
	datasum.apMaxVRealahpVDiffMax=max(apMaxVReal-ahpV);
		
	datasum.thresholdVRealapEndVDiffMin=min(thresholdVReal-apEndV);
	datasum.thresholdVRealapEndVDiffMax=max(thresholdVReal-apEndV);
	datasum.thresholdVRealhalfWidhtVDiffMin=min(thresholdVReal-halfWidhtV);
	datasum.thresholdVRealhalfWidhtVDiffMax=max(thresholdVReal-halfWidhtV);
	datasum.thresholdVRealdvMaxVRealDiffMin=min(thresholdVReal-dvMaxVReal);
	datasum.thresholdVRealdvMaxVRealDiffMax=max(thresholdVReal-dvMaxVReal);
	datasum.thresholdVRealdvMinVRealDiffMin=min(thresholdVReal-dvMinVReal);
	datasum.thresholdVRealdvMinVRealDiffMax=max(thresholdVReal-dvMinVReal);
	datasum.thresholdVRealahpVDiffMin=min(thresholdVReal-ahpV);
	datasum.thresholdVRealahpVDiffMax=max(thresholdVReal-ahpV);
	
	datasum.apEndVhalfWidhtVDiffMin=min(apEndV-halfWidhtV);
	datasum.apEndVhalfWidhtVDiffMax=max(apEndV-halfWidhtV);
	datasum.apEndVdvMaxVRealDiffMin=min(apEndV-dvMaxVReal);
	datasum.apEndVdvMaxVRealDiffMax=max(apEndV-dvMaxVReal);
	datasum.apEndVdvMinVRealDiffMin=min(apEndV-dvMinVReal);
	datasum.apEndVdvMinVRealDiffMax=max(apEndV-dvMinVReal);
	datasum.apEndVahpVDiffMin=min(apEndV-ahpV);
	datasum.apEndVahpVDiffMax=max(apEndV-ahpV);
	
	datasum.halfWidhtVdvMaxVRealDiffMin=min(halfWidhtV-dvMaxVReal);
	datasum.halfWidhtVdvMaxVRealDiffMax=max(halfWidhtV-dvMaxVReal);
	datasum.halfWidhtVdvMinVRealDiffMin=min(halfWidhtV-dvMinVReal);
	datasum.halfWidhtVdvMinVRealDiffMax=max(halfWidhtV-dvMinVReal);
	datasum.halfWidhtVahpVDiffMin=min(halfWidhtV-ahpV);
	datasum.halfWidhtVahpVDiffMax=max(halfWidhtV-ahpV);

	datasum.dvMaxVRealdvMinVRealDiffMin=min(dvMaxVReal-dvMinVReal);
	datasum.dvMaxVRealdvMinVRealDiffMax=max(dvMaxVReal-dvMinVReal);
	datasum.dvMaxVRealahpVDiffMin=min(dvMaxVReal-ahpV);
	datasum.dvMaxVRealahpVDiffMax=max(dvMaxVReal-ahpV);
	
	datasum.dvMinVRealahpVDiffMin=min(dvMinVReal-ahpV);
	datasum.dvMinVRealahpVDiffMax=max(dvMinVReal-ahpV);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%  AP Voltage differences min-max END %%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
end
