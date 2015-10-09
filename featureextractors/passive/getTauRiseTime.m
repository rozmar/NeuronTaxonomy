%
%
%
function tau0_90risetime = getTauRiseTime(x,Y,taustart,tauend,sampleInterval,samplingRate)
	YY = Y;				%save original value

	%filter the IVs
	fNorm = 500 / (samplingRate/2);              	%# normalized cutoff frequency
	[b,a] = butter(6, fNorm, 'low');  		%# 10th order filter

	%filter the IVs
	for i=1:size(Y,1)
		Y(i,:) = filtfilt(b, a, Y(i,:));
	end
	
	
	
	xtau = x(taustart:tauend);
	Ytau = Y(:,taustart:tauend);
		
	dtau = abs(Ytau(:,1)-Ytau(:,end));
	
	dNinetyPercent = Ytau(:,1)-dtau*0.9;
	for i=1:size(Ytau,1)
		tnp = find(Ytau(i,:)<dNinetyPercent(i),1,'first');
		if size(tnp,2)==0
			tNinetyPercent(i) = 0;
		else
			tNinetyPercent(i) = find(Ytau(i,:)<dNinetyPercent(i),1,'first');
		end
	end
	
	if size(tNinetyPercent,2) == 0
		tau0_90risetime=0;
	else
		tau0_90risetime = sampleInterval.*tNinetyPercent;	
	end
		
end