function plotiv(fname, iv, data, add, filter) %add==1: plussz pontok az IV-ken!!
iv=iv.(fname);
%datasum=datasum.(fname);
%data=data.(fname);
samplingrate=data.samplingRate;
figure(3333)
set(3333,'units','normalized','outerposition',[0 0 1 1]);hold on;
clf;
v1=iv.v1;
v2sweep=find(iv.current<0,1,'last');
eval(['v2=iv.v',num2str(v2sweep),';']); 
%v2=iv.v5 ;
eval(['v3=iv.v',num2str(datasum.reobasesweep),';']); 
eval(['v4=iv.v',num2str(datasum.steadysweep),';']); %iv.sweepnum
eval(['v5=iv.v',num2str(datasum.reobasesweep-1),';']); 
subplot(2,2,3);hold on;

if filter>0
    fNorm = filter / (samplingrate/2);               %# normalized cutoff frequency
    [b,a] = butter(6, fNorm, 'low');  %# 10th order filter
    v1 = filtfilt(b, a, v1);
    v2 = filtfilt(b, a, v2);
    v5 = filtfilt(b, a, v5);
end


plot(iv.time, v1*1000)
if add==1
    plot(iv.time(data.taustart),v1(data.taustart)*1000,'ro');
    plot(data.tauend(1),data.vsag(1)*1000,'go');
    plot(data.trebound(1),data.vrebound(1)*1000,'go');
end
plot(iv.time, v2*1000)
if add==1
    plot(iv.time(data.taustart),v2(data.taustart)*1000,'ro');
    if length(data.tauend)>=5
        plot(data.tauend(v2sweep),data.vsag(v2sweep)*1000,'go');
        plot(data.trebound(v2sweep),data.vrebound(v2sweep)*1000,'go');
    else
        plot(data.tauend(length(data.pass.tauend)),data.vsag(length(data.tauend))*1000,'go');
    plot(data.trebound(length(data.tauend)),data.vrebound(length(data.tauend))*1000,'go');
end
plot(iv.time, v3*1000)
if add==1
    plot(iv.time(data.taustart),v3(data.taustart)*1000,'ro');
    sweep=datasum.rheobase;
%    for i=1:datasum.apnum(sweep)
%        plot(data.HH.(['sweep',num2str(sweep)]).dvmaxt(i),data.HH.(['sweep',num2str(sweep)]).dvmaxv(i)*1000,'g^');
%        plot(data.HH.(['sweep',num2str(sweep)]).dvmint(i),data.HH.(['sweep',num2str(sweep)]).dvminv(i)*1000,'rv');      
%        plot(data.HH.(['sweep',num2str(sweep)]).apmaxtime(i),data.HH.(['sweep',num2str(sweep)]).apmax(i)*1000,'ro');
%        plot(data.HH.(['sweep',num2str(sweep)]).oldtreshtime(i),data.HH.(['sweep',num2str(sweep)]).oldtresh(i)*1000,'go');
%        plot(data.HH.(['sweep',num2str(sweep)]).treshtime(i),data.HH.(['sweep',num2str(sweep)]).tresh(i)*1000,'gx');
%        plot(data.HH.(['sweep',num2str(sweep)]).aphwstart(i),data.HH.(['sweep',num2str(sweep)]).aphwsv(i)*1000,'r.');
%        plot(data.HH.(['sweep',num2str(sweep)]).aphwstop(i),data.HH.(['sweep',num2str(sweep)]).aphwsv(i)*1000,'r.');
%        plot(data.HH.(['sweep',num2str(sweep)]).oldapendtime(i),data.HH.(['sweep',num2str(sweep)]).oldapend(i)*1000,'ko');
%        plot(data.HH.(['sweep',num2str(sweep)]).apendtime(i),data.HH.(['sweep',num2str(sweep)]).apend(i)*1000,'kx');
%        plot( data.HH.(['sweep',num2str(sweep)]).ahptime(i),  data.HH.(['sweep',num2str(sweep)]).ahpv(i)*1000, 'go');
%        plot( data.HH.(['sweep',num2str(sweep)]).ahptimeslow(i),  data.HH.(['sweep',num2str(sweep)]).ahpvslow(i)*1000, 'ro');
%        plot( data.HH.(['sweep',num2str(sweep)]).adptime(i),  data.HH.(['sweep',num2str(sweep)]).adpv(i)*1000, 'g*');
%        plot( data.HH.(['sweep',num2str(sweep)]).adptimeslow(i),  data.HH.(['sweep',num2str(sweep)]).adpvslow(i)*1000, 'r*');
%    end
%    if datasum.burstspikes(sweep) >0
%        plot(data.HH.(['sweep',num2str(sweep)]).apmaxtime(1:datasum.burstspikes(sweep)),data.HH.(['sweep',num2str(sweep)]).apmax(1:datasum.burstspikes(sweep))*1000,'kx');
%    end
    if isfield(data, 'ramp') && size(data.ramp,1)>sweep-1
       plot(iv.time,(data.ramp(sweep,1)*iv.time +data.ramp(sweep,2))*1000,'r')
    end
end
xlim([0 iv.time(end)])
%title(['injected currents: ',num2str(iv.current(1)),' pA, ',num2str(iv.current(v2sweep)),' pA, ',num2str(iv.current(data.rheobase)),' pA, ',num2str(iv.current(datasum.steadysweep)),' pA']);
fname(fname=='_')='-';
xlabel('Time (s)');
ylabel('Vm (mV)');
subplot(2,2,1);
plot(iv.time, v4*1000)
hold on
if add==1;
    plot(iv.time(data.pass.taustart),v4(data.pass.taustart)*1000,'ro');
    sweep=datasum.steadysweep;
    for i=1:datasum.apnum(sweep)
        plot(data.HH.(['sweep',num2str(sweep)]).dvmaxt(i),data.HH.(['sweep',num2str(sweep)]).dvmaxv(i)*1000,'g^');
        plot(data.HH.(['sweep',num2str(sweep)]).dvmint(i),data.HH.(['sweep',num2str(sweep)]).dvminv(i)*1000,'rv');       
         
        plot(data.HH.(['sweep',num2str(sweep)]).apmaxtime(i),data.HH.(['sweep',num2str(sweep)]).apmax(i)*1000,'ro');
        
        plot(data.HH.(['sweep',num2str(sweep)]).oldtreshtime(i),data.HH.(['sweep',num2str(sweep)]).oldtresh(i)*1000,'go');
        plot(data.HH.(['sweep',num2str(sweep)]).treshtime(i),data.HH.(['sweep',num2str(sweep)]).tresh(i)*1000,'gx');
        
        plot(data.HH.(['sweep',num2str(sweep)]).aphwstart(i),data.HH.(['sweep',num2str(sweep)]).aphwsv(i)*1000,'r.');
        plot(data.HH.(['sweep',num2str(sweep)]).aphwstop(i),data.HH.(['sweep',num2str(sweep)]).aphwsv(i)*1000,'r.');
        
        plot(data.HH.(['sweep',num2str(sweep)]).oldapendtime(i),data.HH.(['sweep',num2str(sweep)]).oldapend(i)*1000,'ko');
        plot(data.HH.(['sweep',num2str(sweep)]).apendtime(i),data.HH.(['sweep',num2str(sweep)]).apend(i)*1000,'kx');
        
        plot( data.HH.(['sweep',num2str(sweep)]).ahptime(i),  data.HH.(['sweep',num2str(sweep)]).ahpv(i)*1000, 'go');
        plot( data.HH.(['sweep',num2str(sweep)]).ahptimeslow(i),  data.HH.(['sweep',num2str(sweep)]).ahpvslow(i)*1000, 'ro');
        
        plot( data.HH.(['sweep',num2str(sweep)]).adptime(i),  data.HH.(['sweep',num2str(sweep)]).adpv(i)*1000, 'g*');
        plot( data.HH.(['sweep',num2str(sweep)]).adptimeslow(i),  data.HH.(['sweep',num2str(sweep)]).adpvslow(i)*1000, 'r*');
    end
    if datasum.burstspikes(sweep) >0
        plot(data.HH.(['sweep',num2str(sweep)]).apmaxtime(1:datasum.burstspikes(sweep)),data.HH.(['sweep',num2str(sweep)]).apmax(1:datasum.burstspikes(sweep))*1000,'kx');
    end
end
plot(iv.time, v5*1000)
if add==1
    plot(iv.time(data.pass.taustart),v5(data.pass.taustart)*1000,'ro');
    if isfield(data.HH, 'vhump')
        plot(data.HH.thump(datasum.reobasesweep-1),data.HH.vhump(datasum.reobasesweep-1)*1000,'go');
        plot(iv.time,(data.HH.ramp(datasum.reobasesweep-1,1)*iv.time +data.HH.ramp(datasum.reobasesweep-1,2))*1000,'r')
    end
   
end
xlim([0 iv.time(end)])
title([fname(6:end),' segments:',num2str(iv.segment),' RS:',num2str(datasum.RS)]);
xlabel('Time (s)');
ylabel('Vm (mV)');


sweep=datasum.steadysweep;
for i=1:data.HH.apnum(sweep)

    oldtime=data.HH.meanspike.(['sweep',num2str(sweep)]).time;
    time=(data.HH.meanspike.(['sweep',num2str(sweep)]).(['t',num2str(i)]));
    voltage=(data.HH.meanspike.(['sweep',num2str(sweep)]).(['v',num2str(i)])+data.pass.dvrs(sweep))*1000;
    
    voltage2=mean([voltage(2:end)';voltage(1:end-1)'])';
    
    dvoltage=diff(voltage)./diff(time(1:length(voltage)))';
    dvoltage=mean([0,dvoltage';dvoltage',0])';
    
    a=diff(time);
    dtime2=[a,a(1,end)];
    a=diff(voltage);
    dvoltage2=[a;0];
    dvoltage2=dvoltage2./dtime2(1:length(dvoltage2))';
    
    subplot(2,2,4);
    plot(time(1:length(voltage)), voltage,'-');
    hold on;
    %plot(oldtime, voltage,'r-');
    xlim([min(time) max(time)]);
    xlabel('Time (ms)');
    ylabel('Vm (mV)');
    hold on;
    subplot(2,2,2);
%      plot(voltage, dvoltage);
    hold on;
%      plot(voltage, dvoltage2,'r');
    plot(voltage2, dvoltage2(1:end-1),'k');
    if add==1;
    plot((data.HH.(['sweep',num2str(sweep)]).dvmaxv_corrected)*1000,data.HH.(['sweep',num2str(sweep)]).dvmax,'g^')
    plot((data.HH.(['sweep',num2str(sweep)]).dvminv_corrected)*1000,data.HH.(['sweep',num2str(sweep)]).dvmin,'rv')
    plot(mean(data.HH.(['sweep',num2str(sweep)]).dvmaxv_corrected)*1000,mean(data.HH.(['sweep',num2str(sweep)]).dvmax),'go')
    plot(mean(data.HH.(['sweep',num2str(sweep)]).dvminv_corrected)*1000,mean(data.HH.(['sweep',num2str(sweep)]).dvmin),'ro')   
    end
    xlabel('Vm (mV)');
    ylabel('dVm/dt (mV/ms)');
    hold on;

end

end