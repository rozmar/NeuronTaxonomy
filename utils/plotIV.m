% Plots cells features and its IVs.
%
% Expects in parameter the raw IV, the cells features, 
% the name of cells and the name of file.
function plotIV(iv,cell,cellname,fname,filtr)

	load('featureextractors/apFeatures.mat','featS');
	disp('Starting plot');
	figure('Name',cellname,'NumberTitle','off','visible','off');
	
	clf();

	%get raw data
	x=iv.time;
	Y=sweepToMatrix(iv);
    	
	if filtr>0
		fNorm = filtr / (cell.samplingRate/2);               %# normalized cutoff frequency
		[b,a] = butter(6, fNorm, 'low');  %# 10th order filter
		for i=1:size(Y,1)
			Y(i,:) = filtfilt(b, a, Y(i,:));	
		end
	end
	
	%get the last negative current sweep
	lpi = find(iv.current<0,1,'last');
    if isempty(lpi)
        lp=Y(1,:);
    else
        lp=Y(lpi,:);
    end
			
	subplot(2,2,1);
	hold on; 
	plot(x,lp,'b-');			%plot the last negative sweep
	plot(x,Y(1,:),'b-');			%plot the first sweep
	%plot to it the taustart, sag and rebound
	plot([x(cell.tauend(1)-10) x(cell.tauend(1)+10)],[cell.vsag(1) cell.vsag(1)],'r-'); 
	plot(x(cell.taustart),Y(1,cell.taustart),'ro'); 
	plot(cell.trebound(1),cell.vrebound(1),'go');
	plot([x(cell.tauend(lpi)-10) x(cell.tauend(lpi)+10)],[cell.vsag(lpi) cell.vsag(lpi)],'r-'); 
	plot(x(cell.taustart),lp(cell.taustart),'ro'); 
	plot(cell.trebound(lpi),cell.vrebound(lpi),'go');
	xlim([0 x(end)]);
	hold off;
	fprintf('1/4\n');
	rheobase = cell.rheobase;	%get the rheobase sweep
	rbs = Y(rheobase,:);		
		
	%plot the rheobase sweep and the taustart on it
	subplot(2,2,3);
	hold on;
	plot(x,rbs,'b-');
	plot(x(cell.taustart),rbs(cell.taustart),'ro');
	
	
	%draw ramp 
	if isfield(cell, 'ramp') && size(cell.ramp,1)>rheobase-1

		plot(x,(cell.ramp(rheobase,1)*x +cell.ramp(rheobase,2)),'r')
	end
	xlim([0 x(end)]);
	hold off;
	fprintf('2/4\n');
	%get steady sweep 
	subplot(2,2,2)
	hold on;
	ste = cell.steady;
	stes = Y(ste,:);
	plot(x,stes);
	plot(x(cell.taustart),stes(cell.taustart),'ro');
	%get apnum of steady sweep
	apn = cell.apNums(ste);
	
	%get AP-s of this sweep
	if apn>0
		APs = cell.apFeatures(find(cell.apFeatures(:,featS.sweepNum)==ste),:);
	end

	%plot the AP features
	for i=1:apn
		%ap max
		plot(x(APs(i,featS.apMaxPos)),APs(i,featS.apMax),'go');
		%threshold
		plot(x(APs(i,featS.thresholdPos)),APs(i,featS.thresholdV),'go');
		%corrected threshold
		%plot(x(cell.taustart+APs(i,featS.thresholdPos)),APs(i,featS.thresholdVReal),'gx');
		%halfwidth start
		plot(APs(i,featS.halfWidthStart),APs(i,featS.halfWidthV),'ro');
		%halfwidth end
		plot(APs(i,featS.halfWidthEnd),APs(i,featS.halfWidthV),'ro');
		%apend
		plot(x(APs(i,featS.apEndPos)),APs(i,featS.apEndV),'kx');
		%AHP
		plot(APs(i,featS.ahpT),APs(i,featS.ahpV),'go');
		%ADP
		plot(APs(i,featS.adpT),APs(i,featS.adpV),'co');		
	end
	xlim([0 x(end)]);
	hold off;
	fprintf('3/4\n');
	%get the before rheobase sweep		
	rhe_1 = rheobase-1;
	rhe_1sw = Y(rhe_1,:);
	
	subplot(2,2,4)
	hold on;
	plot(x,rhe_1sw);
	plot(x(cell.taustart),rhe_1sw(cell.taustart),'ro');
	if isfield(cell,'hump') & ~isempty(cell.hump) & size(cell.hump,2)>0 & ~isempty(find(cell.hump(:,1)==rhe_1))
		sweepHump = cell.hump(find(cell.hump(:,1)==rhe_1),:);
		plot(x(sweepHump(3)),sweepHump(2),'go');
	end
	
	if size(cell.ramp,2)>0
		sweepRamp = cell.ramp(rhe_1,:);
		plot(x,sweepRamp(1)*x +sweepRamp(2),'r');
	end
	xlim([0 x(end)]);
	hold off;
	fprintf('4/4\n');
%	subplot(2,2,4);
%	hold on;
%	posSweep = find(iv.current>0);
%	for i=1:length(posSweep)
%		plot(x,Y(posSweep(i),:));
%		plot(x, cell.ramp(posSweep(i),1)*x + cell.ramp(posSweep(i),2),'r');
%	end
%	
%	hold off;
%	
%	xlim([0 x(end)]);
		
end
