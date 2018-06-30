%Calculate v0 by the sweep from the IV.
%
% In parameter, expects the IVs, the taustart and step number in 100 micsec
% Returns the v0 values by sweep.
function [v0 dvrs] = calculateV0BySweep(x,Y,taustart,hundredMicsStep,vrs,current)
	%relevantY = Y(:,(taustart-5*hundredMicsStep:taustart-3*hundredMicsStep));
	relevantY = Y(:,(1:taustart-10*hundredMicsStep));
	relevantx = x(1:taustart-10*hundredMicsStep);

%	figure(1,"visible","on");
%	clf;
%	hold on;
%	plot(relevantx,relevantY,'b-');
%	plot(x(1:taustart),Y(:,1:taustart),'b-');
%	plot(x(taustart),vrs(:),'ro');
%	hold off;

	v0 = mean(relevantY')';
			
	dvrs = v0-vrs;
    
    RS=(-dvrs./current);
    RS(abs(current)<30)=[];
    RS=median(RS);
    
    if isempty(RS)
        RS=median((-dvrs./current));
    end
    if RS<10^-6
        disp('hm')
    end
    dvrs=-RS*(current);
end