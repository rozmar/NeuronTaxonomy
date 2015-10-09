


function datasum = aggActiveAPResistances(cell,current,datasum)
	
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%        AP Resistances       %%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	datasum.apMaxVRealResistance=mean(apMaxVReal./current(apFeatures(:,1)));
	datasum.thresholdVRealResistance=mean(thresholdVReal./current(apFeatures(:,1)));
	datasum.apEndVResistance=mean(apEndV./current(apFeatures(:,1)));
	datasum.halfWidhtVResistance=mean(halfWidhtV./current(apFeatures(:,1)));
	datasum.apAmplitudeResistance=mean(apAmplitude./current(apFeatures(:,1)));
	datasum.dvMaxVRealResistance=mean(dvMaxVReal./current(apFeatures(:,1)));
	datasum.dvMinVRealResistance=mean(dvMinVReal./current(apFeatures(:,1)));
	datasum.ahpVResistance=mean(ahpV./current(apFeatures(:,1)));
	datasum.adpVResistance=mean(adpV./current(apFeatures(:,1)));
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%        AP Resistances end      %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%        AP Resistances quotients       %%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	datasum.apMaxVRealResistancethresholdVRealResistanceQuot=mean(datasum.apMaxVRealResistance/datasum.thresholdVRealResistance);
	datasum.apMaxVRealResistanceapEndVResistanceQuot=mean(datasum.apMaxVRealResistance/datasum.apEndVResistance);
	datasum.apMaxVRealResistancehalfWidhtVResistanceQuot=mean(datasum.apMaxVRealResistance/datasum.halfWidhtVResistance);
	datasum.apMaxVRealResistanceapAmplitudeResistanceQuot=mean(datasum.apMaxVRealResistance/datasum.apAmplitudeResistance);
	datasum.apMaxVRealResistancedvMaxVRealResistanceQuot=mean(datasum.apMaxVRealResistance/datasum.dvMaxVRealResistance);
	datasum.apMaxVRealResistancedvMinVRealResistanceQuot=mean(datasum.apMaxVRealResistance/datasum.dvMinVRealResistance);
	datasum.apMaxVRealResistanceahpVResistanceQuot=mean(datasum.apMaxVRealResistance/datasum.ahpVResistance);
	datasum.apMaxVRealResistanceadpVResistanceQuot=mean(datasum.apMaxVRealResistance/datasum.adpVResistance);
	datasum.thresholdVRealResistanceapEndVResistanceQuot=mean(datasum.thresholdVRealResistance/datasum.apEndVResistance);
	datasum.thresholdVRealResistancehalfWidhtVResistanceQuot=mean(datasum.thresholdVRealResistance/datasum.halfWidhtVResistance);
	datasum.thresholdVRealResistanceapAmplitudeResistanceQuot=mean(datasum.thresholdVRealResistance/datasum.apAmplitudeResistance);
	datasum.thresholdVRealResistancedvMaxVRealResistanceQuot=mean(datasum.thresholdVRealResistance/datasum.dvMaxVRealResistance);
	datasum.thresholdVRealResistancedvMinVRealResistanceQuot=mean(datasum.thresholdVRealResistance/datasum.dvMinVRealResistance);
	datasum.thresholdVRealResistanceahpVResistanceQuot=mean(datasum.thresholdVRealResistance/datasum.ahpVResistance);
	datasum.thresholdVRealResistanceadpVResistanceQuot=mean(datasum.thresholdVRealResistance/datasum.adpVResistance);
	datasum.apEndVResistancehalfWidhtVResistanceQuot=mean(datasum.apEndVResistance/datasum.halfWidhtVResistance);
	datasum.apEndVResistanceapAmplitudeResistanceQuot=mean(datasum.apEndVResistance/datasum.apAmplitudeResistance);
	datasum.apEndVResistancedvMaxVRealResistanceQuot=mean(datasum.apEndVResistance/datasum.dvMaxVRealResistance);
	datasum.apEndVResistancedvMinVRealResistanceQuot=mean(datasum.apEndVResistance/datasum.dvMinVRealResistance);
	datasum.apEndVResistanceahpVResistanceQuot=mean(datasum.apEndVResistance/datasum.ahpVResistance);
	datasum.apEndVResistanceadpVResistanceQuot=mean(datasum.apEndVResistance/datasum.adpVResistance);
	datasum.halfWidhtVResistanceapAmplitudeResistanceQuot=mean(datasum.halfWidhtVResistance/datasum.apAmplitudeResistance);
	datasum.halfWidhtVResistancedvMaxVRealResistanceQuot=mean(datasum.halfWidhtVResistance/datasum.dvMaxVRealResistance);
	datasum.halfWidhtVResistancedvMinVRealResistanceQuot=mean(datasum.halfWidhtVResistance/datasum.dvMinVRealResistance);
	datasum.halfWidhtVResistanceahpVResistanceQuot=mean(datasum.halfWidhtVResistance/datasum.ahpVResistance);
	datasum.halfWidhtVResistanceadpVResistanceQuot=mean(datasum.halfWidhtVResistance/datasum.adpVResistance);
	datasum.apAmplitudeResistancedvMaxVRealResistanceQuot=mean(datasum.apAmplitudeResistance/datasum.dvMaxVRealResistance);
	datasum.apAmplitudeResistancedvMinVRealResistanceQuot=mean(datasum.apAmplitudeResistance/datasum.dvMinVRealResistance);
	datasum.apAmplitudeResistanceahpVResistanceQuot=mean(datasum.apAmplitudeResistance/datasum.ahpVResistance);
	datasum.apAmplitudeResistanceadpVResistanceQuot=mean(datasum.apAmplitudeResistance/datasum.adpVResistance);
	datasum.dvMaxVRealResistancedvMinVRealResistanceQuot=mean(datasum.dvMaxVRealResistance/datasum.dvMinVRealResistance);
	datasum.dvMaxVRealResistanceahpVResistanceQuot=mean(datasum.dvMaxVRealResistance/datasum.ahpVResistance);
	datasum.dvMaxVRealResistanceadpVResistanceQuot=mean(datasum.dvMaxVRealResistance/datasum.adpVResistance);
	datasum.dvMinVRealResistanceahpVResistanceQuot=mean(datasum.dvMinVRealResistance/datasum.ahpVResistance);
	datasum.dvMinVRealResistanceadpVResistanceQuot=mean(datasum.dvMinVRealResistance/datasum.adpVResistance);
	datasum.ahpVResistanceadpVResistanceQuot=mean(datasum.ahpVResistance/datasum.adpVResistance);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%    AP Resistances quotients end  %%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
end