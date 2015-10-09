

function [k,SS,IDX] = findBestK(X,maxK)
  symbols = ['r.';'b.';'g.';'k.';'c.';'m.';'rx';'bx';'gx';'bo'];
  SS = [];
  IDX = [];
  for k = 2 : maxK
    [idx,c] = kmeans(X,k,'emptyaction','singleton','Display','off');
    %plotKClusters2D(X,idx);
    SS(k)= scatterSeparability(X,idx);
    IDX = [ IDX ; idx'];
  end
end