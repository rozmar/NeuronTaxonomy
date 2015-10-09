
AccurateLeaves = {};

for i = 1 : length(L)
    AccurateLeaves(i).F = [];
end

for j = 1 : length(L)
   if size(Leaves(j).F,1)==0
       continue
   end
   F = L(j).F;
   for i = 1 : size(F,1)
    testingCombination = F(i,:);
    IDX = [];
    P = [];
    for k = 1 : iter
        W_f = W(:,testingCombination);
        idx = kmeans(W_f,2,'emptyaction','singleton','Display','off');
        if idx(1)==2
           idx = ones(size(idx,1),1)*3 - idx;
        end
        idx(idx==2)=0;
        if size(IDX,1)>0
            MemberVector = ismember(IDX,idx','rows');
        else
            MemberVector = 0;
        end
        if sum(MemberVector)==1
           P(MemberVector) = P(MemberVector) + 1;
        else
           IDX = [ IDX ; idx' ];
           P = [ P ; 1 ];
        end
    end
    fprintf('For the combination ');
    for combination = 1 : size(testingCombination,2)
       fprintf('%d ', testingCombination(combination)); 
    end
    fprintf(' there was %d combination with occurences ', size(P,1));
    for combination = 1 : size(P,1)
       fprintf('%.2f%% ', P(combination)*100/iter); 
    end
    fprintf('\n');
    %fflush(stdout);
    drawnow('update');
    
    idx = IDX(find(P==max(P),1),:)';
    cfm = calcConfusionMatrixClustering(W,idx,actualY);
    
    fprintf('For the combination ');
    for combination = 1 : size(testingCombination,2)
       fprintf('%d ', testingCombination(combination)); 
    end
    
    precision = cfm(1) / (cfm(1)+cfm(2));
    recall = cfm(1) / (cfm(1)+cfm(3));
    F1 = ((2*precision*recall)/(precision+recall));
        
    fprintf('%d was the missed elements, F1-score %.2f\n', sum(cfm(2:3)), ((2*precision*recall)/(precision+recall)));
    
    if F1>0.99
        AccurateLeaves(j).F = [ AccurateLeaves(j).F ; testingCombination ];
    end
    
   end
end