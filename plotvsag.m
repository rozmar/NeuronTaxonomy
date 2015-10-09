
Y11 = Y1;
Y22 = Y2;

if filtr>0
  fNorm = filtr / (cell1.samplingRate/2);               %# normalized cutoff frequency
	[b,a] = butter(6, fNorm, 'low');  %# 10th order filter
	for i=1:size(Y11,1)
		Y11(i,:) = filtfilt(b, a, Y11(i,:));	
	end
  fNorm = filtr / (cell2.samplingRate/2);               %# normalized cutoff frequency
	[b,a] = butter(6, fNorm, 'low');  %# 10th order filter  
  for i=1:size(Y22,1)
		Y22(i,:) = filtfilt(b, a, Y22(i,:));	
	end
end


figure(randi(100));
clf;
subplot(2,1,1);
ylim([-0.088,-0.065]);
title('vsagvreboundDiff');
hold on;
plot(iv1.time,Y11(SW(1),:),'r-','linewidth',1);
plot([1 1],[cell1.vsag(SW(1)) Y11(SW(1),int16(cell1.trebound(SW(1))*cell1.samplingRate))],'k-','linewidth',7);%cell1.vrebound(SW(1))],'k-','linewidth',7);
plot([iv1.time(cell1.tauend(SW(1))) 1],[cell1.vsag(SW(1)) cell1.vsag(SW(1))],'k--','linewidth',1);
plot([cell1.trebound(SW(1)) 1],[Y11(SW(1),int16(cell1.trebound(SW(1))*cell1.samplingRate)) Y11(SW(1),int16(cell1.trebound(SW(1))*cell1.samplingRate))],'k--','linewidth',1);
hold off;
subplot(2,1,2);
ylim([-0.088,-0.065]);
hold on;
plot(iv2.time,Y22(SW(2),:),'b-','linewidth',1);
plot([1 1],[cell2.vsag(SW(2)) cell2.vrebound(SW(2))],'k-','linewidth',7);
plot([iv2.time(cell2.tauend(SW(2))) 1],[cell2.vsag(SW(2)) cell2.vsag(SW(2))],'k--','linewidth',1);
plot([cell2.trebound(SW(2)) 1],[cell2.vrebound(SW(2)) cell2.vrebound(SW(2))],'k--','linewidth',1);
hold off;