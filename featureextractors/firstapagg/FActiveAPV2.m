


function datasum = FActiveAPV2(cell,current,datasum)

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

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%   Get Voltage  %%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	dvrs = cell.dvrs;
	v0 = cell.v0;
	apMaxVReal=firstAP(featS.apMaxReal);
	thresholdVReal=firstAP(featS.thresholdVReal);
	apEndV=(firstAP(featS.apEndV)+dvrs(firstAP(1)));
	halfWidhtV=firstAP(featS.halfWidthV)+dvrs(firstAP(1));
	apAmplitude=firstAP(featS.apAmplitude)+dvrs(firstAP(1));
	dvMaxVReal=firstAP(featS.dvMaxVReal);
	dvMinVReal=firstAP(featS.dvMinVReal);
	ahpV=firstAP(featS.ahpV)+dvrs(firstAP(1));
%	adpV=firstAP(featS.adpV)+dvrs(firstAP(1));
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%% AP Voltages diff from v0 %%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	sweepNum = firstAP(featS.sweepNum);
	datasum.FapMaxVRealV0Diff=apMaxVReal-v0(sweepNum);
	datasum.FthresholdVRealV0Diff=thresholdVReal-v0(sweepNum);
	datasum.FapEndVV0Diff=apEndV-v0(sweepNum);
	datasum.FhalfWidhtVV0Diff=halfWidhtV-v0(sweepNum);
	datasum.FapAmplitudeV0Diff=apAmplitude-v0(sweepNum);
	datasum.FdvMaxVRealV0Diff=dvMaxVReal-v0(sweepNum);
	datasum.FdvMinVRealV0Diff=dvMinVReal-v0(sweepNum);
	datasum.FahpVV0Diff=ahpV-v0(sweepNum);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%% AP Voltages diff from v0 end  %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	
	
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%        AP Volt quotients        %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	datasum.FapMaxVRealthresholdVRealQuot=apMaxVReal./thresholdVReal;
	datasum.FapMaxVRealapEndVQuot=apMaxVReal./apEndV;
	datasum.FapMaxVRealhalfWidhtVQuot=apMaxVReal./halfWidhtV;
	datasum.FapMaxVRealapAmplitudeQuot=apMaxVReal./apAmplitude;
	datasum.FapMaxVRealdvMaxVRealQuot=apMaxVReal./dvMaxVReal;
	datasum.FapMaxVRealdvMinVRealQuot=apMaxVReal./dvMinVReal;
	datasum.FapMaxVRealahpVQuot=apMaxVReal./ahpV;
%	datasum.FapMaxVRealadpVQuot=apMaxVReal./adpV;
	datasum.FthresholdVRealapEndVQuot=thresholdVReal./apEndV;
	datasum.FthresholdVRealhalfWidhtVQuot=thresholdVReal./halfWidhtV;
	datasum.FthresholdVRealapAmplitudeQuot=thresholdVReal./apAmplitude;
	datasum.FthresholdVRealdvMaxVRealQuot=thresholdVReal./dvMaxVReal;
	datasum.FthresholdVRealdvMinVRealQuot=thresholdVReal./dvMinVReal;
	datasum.FthresholdVRealahpVQuot=thresholdVReal./ahpV;
%	datasum.FthresholdVRealadpVQuot=thresholdVReal./adpV;
	datasum.FapEndVhalfWidhtVQuot=apEndV./halfWidhtV;
	datasum.FapEndVapAmplitudeQuot=apEndV./apAmplitude;
	datasum.FapEndVdvMaxVRealQuot=apEndV./dvMaxVReal;
	datasum.FapEndVdvMinVRealQuot=apEndV./dvMinVReal;
	datasum.FapEndVahpVQuot=apEndV./ahpV;
%	datasum.FapEndVadpVQuot=apEndV./adpV;
	datasum.FhalfWidhtVapAmplitudeQuot=halfWidhtV./apAmplitude;
	datasum.FhalfWidhtVdvMaxVRealQuot=halfWidhtV./dvMaxVReal;
	datasum.FhalfWidhtVdvMinVRealQuot=halfWidhtV./dvMinVReal;
	datasum.FhalfWidhtVahpVQuot=halfWidhtV./ahpV;
%	datasum.FhalfWidhtVadpVQuot=halfWidhtV./adpV;
	datasum.FapAmplitudedvMaxVRealQuot=apAmplitude./dvMaxVReal;
	datasum.FapAmplitudedvMinVRealQuot=apAmplitude./dvMinVReal;
	datasum.FapAmplitudeahpVQuot=apAmplitude./ahpV;
%	datasum.FapAmplitudeadpVQuot=apAmplitude./adpV;
	datasum.FdvMaxVRealdvMinVRealQuot=dvMaxVReal./dvMinVReal;
	datasum.FdvMaxVRealahpVQuot=dvMaxVReal./ahpV;
%	datasum.FdvMaxVRealadpVQuot=dvMaxVReal./adpV;
	datasum.FdvMinVRealahpVQuot=dvMinVReal./ahpV;
%	datasum.FdvMinVRealadpVQuot=dvMinVReal./adpV;
%	datasum.FahpVadpVQuot=ahpV./adpV;
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%            AP Volt quotients            %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%            AP Volt differences          %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	datasum.FapMaxVRealthresholdVRealDiff=apMaxVReal-thresholdVReal;
	datasum.FapMaxVRealapEndVDiff=apMaxVReal-apEndV;
	datasum.FapMaxVRealhalfWidhtVDiff=apMaxVReal-halfWidhtV;
	datasum.FapMaxVRealapAmplitudeDiff=apMaxVReal-apAmplitude;
	datasum.FapMaxVRealdvMaxVRealDiff=apMaxVReal-dvMaxVReal;
	datasum.FapMaxVRealdvMinVRealDiff=apMaxVReal-dvMinVReal;
	datasum.FapMaxVRealahpVDiff=apMaxVReal-ahpV;
%	datasum.FapMaxVRealadpVDiff=apMaxVReal-adpV;
	datasum.FthresholdVRealapEndVDiff=thresholdVReal-apEndV;
	datasum.FthresholdVRealhalfWidhtVDiff=thresholdVReal-halfWidhtV;
	datasum.FthresholdVRealapAmplitudeDiff=thresholdVReal-apAmplitude;
	datasum.FthresholdVRealdvMaxVRealDiff=thresholdVReal-dvMaxVReal;
	datasum.FthresholdVRealdvMinVRealDiff=thresholdVReal-dvMinVReal;
	datasum.FthresholdVRealahpVDiff=thresholdVReal-ahpV;
%	datasum.FthresholdVRealadpVDiff=thresholdVReal-adpV;
	datasum.FapEndVhalfWidhtVDiff=apEndV-halfWidhtV;
	datasum.FapEndVapAmplitudeDiff=apEndV-apAmplitude;
	datasum.FapEndVdvMaxVRealDiff=apEndV-dvMaxVReal;
	datasum.FapEndVdvMinVRealDiff=apEndV-dvMinVReal;
	datasum.FapEndVahpVDiff=apEndV-ahpV;
%	datasum.FapEndVadpVDiff=apEndV-adpV;
	datasum.FhalfWidhtVapAmplitudeDiff=halfWidhtV-apAmplitude;
	datasum.FhalfWidhtVdvMaxVRealDiff=halfWidhtV-dvMaxVReal;
	datasum.FhalfWidhtVdvMinVRealDiff=halfWidhtV-dvMinVReal;
	datasum.FhalfWidhtVahpVDiff=halfWidhtV-ahpV;
%	datasum.FhalfWidhtVadpVDiff=halfWidhtV-adpV;
	datasum.FapAmplitudedvMaxVRealDiff=apAmplitude-dvMaxVReal;
	datasum.FapAmplitudedvMinVRealDiff=apAmplitude-dvMinVReal;
	datasum.FapAmplitudeahpVDiff=apAmplitude-ahpV;
%	datasum.FapAmplitudeadpVDiff=apAmplitude-adpV;
	datasum.FdvMaxVRealdvMinVRealDiff=dvMaxVReal-dvMinVReal;
	datasum.FdvMaxVRealahpVDiff=dvMaxVReal-ahpV;
%	datasum.FdvMaxVRealadpVDiff=dvMaxVReal-adpV;
	datasum.FdvMinVRealahpVDiff=dvMinVReal-ahpV;
%	datasum.FdvMinVRealadpVDiff=dvMinVReal-adpV;
%	datasum.FahpVadpVDiff=ahpV-adpV;
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%        AP Volt differences end      %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%%% Minden feszültség kivonva a v0-ból			             - OK 
	%%% Concavityk is legyenek benne (min, max)			              - OK
	%%% Át kell nézni a apmaxokat, miért csúsznak el néhány helyen (+ fekete x, apend)   - OK
%	%%% Egyelőre vegyük ki a adp				             - OK
	%%% AHP és threshold közötti 0-90 intervallum és a ISI hányadosa
	%%% Minden, amit átlagolt, ott legyen szórás is és a szórás/átlag		             - OK
	%%% Megnézni az első olyan AP-re, ahol van legalább 2 ezeket a tulajdonságokat
	
end
