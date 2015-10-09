% Plots cells features and its IVs.
%
% Expects in parameter the raw IV, the cells features, 
% the name of cells and the name of file.
function plotIVV0Vhyp(iv,cell,cellname,fname,filtr)

	load("featureextractors/apFeatures.mat","featS");

	figure(2,"visible","off");
	clf;

	%get raw data
	x=iv.time;
	x=x(1:find(x>iv.segment(1)/1000,1,'first'));
	Y=sweepToMatrix(iv);
	Y = Y(:,(1:find(x>iv.segment(1)/1000,1,'first')));
	
	if filtr>0
		fNorm = filtr / (cell.samplingRate/2);               %# normalized cutoff frequency
		[b,a] = butter(6, fNorm, 'low');  %# 10th order filter
		for i=1:size(Y,1)
			Y(i,:) = filtfilt(b, a, Y(i,:));	
		end
	end
	
	%get the last negative current sweep
	lpi = find(iv.current<0,1,'last');
	lp=Y(lpi,:);
			
	subplot(2,2,1);
	hold on; 
	plot(x,lp,'b-');			%plot the last negative sweep
	plot(x,Y(1,:),'b-');			%plot the first sweep
	plot([x(1) x(end)],[cell.v0(1) cell.v0(1)],'r-');
	plot([x(1) x(end)],[cell.v0(lpi) cell.v0(lpi)],'r-');
	xlim([0 x(end)]);
	hold off;

	rheobase = cell.rheobase;	%get the rheobase sweep
	rbs = Y(rheobase,:);		
		
	%plot the rheobase sweep and the taustart on it
	subplot(2,2,3);
	hold on;
	plot(x,rbs,'b-');
	plot([x(1) x(end)],[cell.v0(rheobase) cell.v0(rheobase)],'r-');
	
	xlim([0 x(end)]);
	hold off;

	%get steady sweep 
	subplot(2,2,2)
	hold on;
	ste = cell.steady;
	stes = Y(ste,:);
	plot(x,stes);
	plot([x(1) x(end)],[cell.v0(ste) cell.v0(ste)],'r-');
	xlim([0 x(end)]);
	hold off;
	
	%get the before rheobase sweep		
	rhe_1 = rheobase-1;
	rhe_1sw = Y(rhe_1,:);
	
	subplot(2,2,4)
	hold on;
	plot(x,rhe_1sw);
	plot([x(1) x(end)],[cell.v0(rhe_1) cell.v0(rhe_1)],'r-');
	xlim([0 x(end)]);
	hold off;
			
end
