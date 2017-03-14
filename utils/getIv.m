function sweepVector = getIv(iv, sweepNumber)
  sweepVector = iv.(strcat('v', num2str(sweepNumber)));
end