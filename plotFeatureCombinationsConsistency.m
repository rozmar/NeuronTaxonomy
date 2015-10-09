function [css,prob] = plotFeatureCombinationsConsistency(bestCombination, dimension, allFeatures, NX, y)
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
  
  css  = {};
  prob = {};
  for i = 1 : size(dimension,1)
    if dimension(i) > size(bestCombination,2)
      possibleFeatures = setdiff(allFeatures,bestCombination);
      PM = makePermutation(size(possibleFeatures,2),dimension(i)-size(bestCombination,2));
      MIDX = [];
      mprob = [];
      for j = 1 : size(PM,1)
        f = union(bestCombination,possibleFeatures(PM(j,:)));
        F = NX(:,f);
        IDX = [];
        for k = 1 : 100
          idx = kmeans(F,2,'emptyaction','singleton');
          idx(idx==2)=0;
          if idx(1)==0
            idx = ones(size(idx)).-idx;
          end
          IDX = [ IDX ; idx' ];
        end
        midx = mode(IDX);
        MatchMatrix = (IDX == repmat(midx,100,1));       
        mprob = [ mprob ; mean(MatchMatrix) ];
        MIDX = [ MIDX ; midx ];
      end
      css{dimension(i)} = MIDX;
      prob{dimension(i)} = mprob;
    else
      PM = makePermutation(size(bestCombination,2),dimension(i));
      MIDX = [];
      mprob = [];
      for j = 1 : size(PM,1)
        f = bestCombination(PM(j,:));
        F = NX(:,f);
        acc = 0;
        IDX = [];
        for k = 1 : 100
          idx = kmeans(F,2,'emptyaction','singleton');
          idx(idx==2)=0;
          if idx(1)==0
            idx = ones(size(idx)).-idx;
          end
          IDX = [ IDX ; idx' ];
        end
        midx = mode(IDX);
        MatchMatrix = (IDX == repmat(midx,100,1));
        mprob = [ mprob ; mean(MatchMatrix) ];
        MIDX = [ MIDX ; midx ];
      end
      css{dimension(i)} = MIDX;
      prob{dimension(i)} = mprob;
    end
  end
    
end