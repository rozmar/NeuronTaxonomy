
for j = 1 : length(L)
    if size(L(j).F,1)==0
        continue
    end
    currentBest = L(j).F(1,:);
    break
end

for j = 1 : length(L)
   if size(L(j).F,1)==0
       continue
   end
   F = L(j).F;
   for i = 1 : size(F,1)
       
       equalsize=(size(currentBest,2)==size(F(i,:),2));
    if equalsize
        isequal=(mean(currentBest==F(i,:))==1);
        if isequal
            continue;
        end
    end
    better = 0;
    maybeBest = F(i,:);
    for k = 1 : iter
        better = better + moreDimensionIsBetter(SETS{1},currentBest,maybeBest,'mul','upward');
    end
    fprintf('In %.2f%% of the cases were best the %dth feature ( ', (better*100/iter), i);
    for combination = 1 : size(maybeBest,2)
        fprintf('%d ', maybeBest(combination));
    end
    fprintf(') than ');
    for combination = 1 : size(currentBest,2)
        fprintf('%d ', currentBest(combination));
    end
    fprintf('\n');
    if ( better/iter ) > 0.5 
        currentBest = maybeBest;
        fprintf('New best:');
        disp(currentBest);
    end
    drawnow('update');
    %fflush(stdout);
   end
    
end