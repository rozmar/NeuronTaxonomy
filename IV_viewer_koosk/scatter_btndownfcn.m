function scatter_btndownfcn(object, event, chosenIdx, datasum)

selectedX = event.IntersectionPoint(1);
nnzIndices = find(chosenIdx);
datasumIdx = nnzIndices(selectedX);
datasumEntry = datasum(datasumIdx);
IVGui(datasumEntry, selectedX, datasumIdx);

end

