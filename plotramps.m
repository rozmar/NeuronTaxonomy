

%14
%cell1 = load('D:\mdata\IV\IVs\A\data_iv_1209042rm_1209042rm.mat_g3_s1_c3.mat').cellStruct;
load('/media/borde/Data/mdata/IV/IVs/A/data_iv_1209042rm_1209042rm.mat_g3_s1_c3-mat.mat');
cell1 = cellStruct;
%76
%cell2 = load('D:\mdata\IV\IVs\B\data_iv_1311291rm_e2_1311291rm.mat_g2_s2_c3.mat').cellStruct;
load('/media/borde/Data/mdata/IV/IVs/B/data_iv_1311291rm_e2_1311291rm.mat_g2_s2_c3-mat.mat');
cell2 = cellStruct;
%iv1 = load('D:\mdata\data\IVs\1209042rm.mat').iv.g3_s1_c3;
load('/media/borde/Data/mdata/data/IVs/1209042rm-mat.mat');
iv1 = iv.g3_s1_c3;
%iv2 = load('D:\mdata\data\IVs\1311291rm.mat').iv.g2_s2_c3;
load('/media/borde/Data/mdata/data/IVs/1311291rm-mat.mat');
iv2 = iv.g2_s2_c3;

Y1 = sweepToMatrix(iv1);
Y2 = sweepToMatrix (iv2);

figure(1);
clf;
subplot(2,1,1);
title('rampx');
hold on;
plot(iv1.time,Y1(15,:),'r-');
plot(iv1.time,cell1.ramp(15,1)*iv1.time+cell1.ramp(15,2),'r-');
hold off;
subplot(2,1,2);
hold on;
plot(iv2.time,Y2(12,:),'b-');
plot(iv2.time,iv2.time*cell2.ramp(12,1)+cell2.ramp(12,2),'r-');
hold off;