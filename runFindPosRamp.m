function runFindPosRamp()

load('/home/sborde/mdata/datasum/Glia/procMatrix_nonapramp.mat');

fileList = procMatrix.fileList;
y = procMatrix.y;

findposramp

save('/home/sborde/rheoramp.mat','rheoramp');

end
