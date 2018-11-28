% Function finds the RS Jump in the IV.
%
% Parameters:
%  x - time
%  Y - V values of all of the sweep
%  currents - the current injected by this sweep
%  sampleInterval - difference between two time point
%  hundredMicsStep - number of points in 100 micsec
% Returns
%  taustart - index of the RS jump
%  vrs - value of the RS jump by sweep
function [taustart vrs] = findRSJump(x,Y,currents,sampleInterval,hundredMicsStep,segments)
	startPos = find(abs(x-segments(1)/1000)==min(abs(x-segments(1)/1000)),1,'first')+1;
	maxLength=round(.0006/sampleInterval);
	leftEnd = max([0,startPos-maxLength]);
	rightEnd = min([length(x),startPos+maxLength]);
	x = x(leftEnd:rightEnd);
    %%
	%select the positive and negative sweeps
	negSweeps = Y(find(currents<0),:);	
	posSweeps = Y(find(currents>0),:);
	


	%create filter window
	h = fspecial('gaussian', [1 hundredMicsStep*3],hundredMicsStep/5);

    

	
    	%filter the x value
% 	x = imfilter(x,h);

    
    %detecting outlying sweeps
    dprenegSweeps=diff(imfilter(negSweeps(:,leftEnd:rightEnd),h,'replicate'),1,2);
    dpreposSweeps=diff(imfilter(posSweeps(:,leftEnd:rightEnd),h,'replicate'),1,2);
    [~,negidx]=min(dprenegSweeps,[],2);
    [~,posidx]=max(dpreposSweeps,[],2);
    medianidx=median([negidx;posidx]);
    needednegidx=negidx>medianidx-hundredMicsStep & negidx<medianidx+hundredMicsStep;
    neededposidx=posidx>medianidx-hundredMicsStep & posidx<medianidx+hundredMicsStep;
    

  %averaging the positive and negative sweeps
  if sum(needednegidx)==1 %size(negSweeps,1)==1
      meanNeg = negSweeps(needednegidx,leftEnd:rightEnd);
  elseif sum(needednegidx)==0 %max(meanNeg)>0
      meanNeg=NaN(1,rightEnd-leftEnd+1);
  else
      negSweeps = (negSweeps(needednegidx,leftEnd:rightEnd));
      meanNeg = mean(negSweeps);
      %         if length(meanNeg)==1
      %           meanNeg=NaN(size(negSweeps(1,:)));
      %       end
  end
  meanNegf = imfilter(meanNeg,h,'replicate');
  if  sum(neededposidx)==1 %size(posSweeps,1)==1
      meanPos = posSweeps(neededposidx,leftEnd:rightEnd);
  elseif sum(neededposidx)==0 %max(meanPos)>0
      meanPos=NaN(1,rightEnd-leftEnd+1);
  else
      posSweeps = (posSweeps(neededposidx,leftEnd:rightEnd));
      meanPos = mean(posSweeps);
      %       if length(meanPos)==1
      %           meanPos=NaN(size(posSweeps(1,:)));
      %       end
  end
	meanPosf = imfilter(meanPos,h,'replicate');
	
% Plot all IV
%	figure;
%	clf;	
%	plot(x,Y);
	
% Plot filtered and original IV.
%	figure;
%	clf;
%	subplot(1,2,1);
%	plot(x,meanNeg,'r-',x,meanNegf,'b-');
%	subplot(1,2,2);
%	plot(x,meanPos,'r-',x,meanPosf,'b-');	

% Plot original and average IV		
%	figure;
%	clf;
%	subplot(1,2,1);
%	plot(x,negSweeps(:,leftEnd:rightEnd),'b-',x,meanNeg,'r-')
%	subplot(1,2,2);
%	plot(x,posSweeps,'b-',x,meanPos,'r-')

%Plot average IV
%	figure;
%	clf;
%	subplot(1,2,1);
%	plot(x,meanNeg,'r-')
%	subplot(1,2,2);
%	plot(x,meanPos,'r-')
	
	%calculate the derivatives of the mean IV-s
	%negDeriv = calcDerivativeInPoint(meanNegf,(1/(x(2)-x(1))));
	negDeriv = diff(meanNegf)./diff(x');
	%posDeriv = calcDerivativeInPoint(meanPosf,(1/(x(2)-x(1))));
	posDeriv = diff(meanPosf)./diff(x');
	
	%find the min. derivative in the negative IVs then look for the end of
	%the RS artefact
	[minNegD,minNegDPos]=nanmin(negDeriv);
% 	minNegDPos=find(negDeriv==minNegD,1,'first');
%%
    if isnan(minNegD)
        minNegDPos=NaN;
    else
        while minNegD<negDeriv(minNegDPos+1) & minNegDPos<length(negDeriv)-1
            minNegDPos=minNegDPos+1;
            minNegD=negDeriv(minNegDPos);
        end
    end
%%
	%find the max. derivative in the positive IVs then look for the end of
	%the RS artefact
	[maxPosD,maxPosDPos]=nanmax(posDeriv);
    if isnan(maxPosD)
        maxPosDPos=NaN;
    else
        while maxPosD>posDeriv(maxPosDPos+1) & maxPosDPos<length(posDeriv)-1
            maxPosDPos=maxPosDPos+1;
            maxPosD=posDeriv(maxPosDPos);
        end
    end
% 	maxPosDPos=find(posDeriv==maxPosD,1,'first');
			
	%find taustart in negative and positive IVs
	taustartNeg = minNegDPos;%+1;%+floor(hundredMicsStep);
	taustartPos = maxPosDPos;%+1;%+floor(hundredMicsStep);
	
% Plot average IV and the min. derivative
% close all
% 	figure;
% 	clf;
% 	subplot(1,1,1);
% 	plot(x,meanNegf,'r-',x(minNegDPos),meanNegf(minNegDPos),'bo',x(taustartNeg),meanNegf(taustartNeg),'go');
% 	hold on
% 	subplot(1,1,1);
% 	plot(x,meanPosf,'r-',x(maxPosDPos),meanPosf(maxPosDPos),'bo',x(taustartPos),meanPosf(taustartPos),'go');
% 	hold off
	
	%taustart will be the mean of the positive and negative taustart
	taustart = round(nanmean([taustartNeg,taustartPos])) + leftEnd;

% 	figure;
% 	clf;
% 	hold on;
% 	plot(x,negSweeps(:,leftEnd:rightEnd),'b-');
% 	plot([x(taustart) x(taustart)],[-0.07 -0.08],'r-');
% 	hold off;
    
	vrs = Y(:,taustart);
    if isempty(taustart) | isnan(taustart) | taustart==0
        pause
    end
	
end