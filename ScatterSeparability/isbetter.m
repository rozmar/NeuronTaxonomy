
SETS={NX_sub};
setname = {'NX'};

for k = 1 : size(featureMatrix,1)
  another = featureMatrix(k,:);
  for j = 1 : length(SETS)
    better = 0;
    for i = 1 : 1000
      better = better + moreDimensionIsBetter(SETS{j},b,another,'mul','upward');
    end
    fprintf('With set %s\n', setname{j});
    disp(another);
    fprintf('Better: %d/%d\n', better, 1000);
  end
  %fflush(stdout);
  drawnow('update');
end
