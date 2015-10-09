function acs = plotFeatureCombinationsAccuracy(bestCombination, dimension, allFeatures, NX, y)
  if nargin < 4
    load('/media/borde/Data/mdata/datasum/procMatrix_posramp.mat');
    NX = procMatrix.NX;
    y = procMatrix.y;
  end
  if nargin < 3 
    allFeatures = load('/media/borde/Data/mdata/datasum/bestFeatures.mat').bestFeatures;
  end
  if nargin < 2 
    dimension = [1:1:size(allFeatures,2)]';
  end
  
  acs  = {};
  for i = 1 : size(dimension,1)
    accs = [];
    if dimension(i) > size(bestCombination,2)
      possibleFeatures = setdiff(allFeatures,bestCombination);
      PM = makePermutation(size(possibleFeatures,2),dimension(i)-size(bestCombination,2));
      for j = 1 : size(PM,1)
        f = union(bestCombination,possibleFeatures(PM(j,:)));
        F = NX(:,f);
        acc = 0;
        for k = 1 : 10
          idx = kmeans(F,2,'emptyaction','singleton');
          idx(idx==2)=0;
          if idx(1)==0
            idx = ones(size(idx)).-idx;
          end
          cfm = calcConfusionMatrixClustering(NX,idx(y<2),y(y<2));
          acc = acc + (sum(cfm([1,4]),2))*100/sum(cfm,2);
        end
        printf("With features ");
        disp(f);
        printf("Average accuracy: %f%%\n\n", (acc/10));
        accs = [ accs ; acc/10 ];
      end
      printf("With dimension: %d\n", dimension(i));
      printf("Average accuracy: %f%%\n\n", mean(accs));
      acs{dimension(i)} = accs;
    else
      PM = makePermutation(size(bestCombination,2),dimension(i));
      for j = 1 : size(PM,1)
        f = bestCombination(PM(j,:));
        F = NX(:,f);
        acc = 0;
        for k = 1 : 10
          idx = kmeans(F,2);
          idx(idx==2)=0;
          if idx(1)==0
            idx = ones(size(idx)).-idx;
          end
          cfm = calcConfusionMatrixClustering(NX,idx(y<2),y(y<2));
          acc = acc + (sum(cfm([1,4]),2))*100/sum(cfm,2);
        end
        printf("With features ");
        disp(f);
        printf("Average accuracy: %f%%\n\n", (acc/10));
        accs = [ accs ; acc/10 ];
      end
      printf("With dimension: %d\n", dimension(i));
      printf("Average accuracy: %f%%\n\n", mean(accs));
      acs{dimension(i)} = accs;
    end
  end
  
  boxplot(acs);
  
end