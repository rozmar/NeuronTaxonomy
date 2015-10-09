function [data]=offsetvoltage(data, iv)
for i=1:iv.sweepnum
    if data.HH.apnum(i)>0
        data.HH.(['sweep',num2str(i)]).apmax_corrected=data.HH.(['sweep',num2str(i)]).apmax + data.pass.dvrs(i);
        data.HH.(['sweep',num2str(i)]).tresh_corrected=data.HH.(['sweep',num2str(i)]).tresh + data.pass.dvrs(i);
        
        data.HH.(['sweep',num2str(i)]).dvmaxv_corrected=data.HH.(['sweep',num2str(i)]).dvmaxv + data.pass.dvrs(i);
        data.HH.(['sweep',num2str(i)]).dvminv_corrected=data.HH.(['sweep',num2str(i)]).dvminv + data.pass.dvrs(i);
    end
    if iv.current(i)>0 && data.HH.apnum(i)==0 %hump-ot szamolunk
        dvhump=data.pass.vrs(i)-data.HH.vhump(i);
        data.HH.rhump(i)=-dvhump/(iv.current(i))*1000000;
    end
end
end