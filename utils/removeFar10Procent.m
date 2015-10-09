function X = removeFar10Procent(X)
  [~,idx] = sort(abs(X),'descend');
  ix = idx ( 1:round(size(X,1)*0.05) , : );
  X(ix,:) = [];
end