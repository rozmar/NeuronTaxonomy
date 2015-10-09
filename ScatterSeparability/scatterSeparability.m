function SS = scatterSeparability(X,y,PI)
  S_w = withinClassScatter(X,y,PI);
  S_b = betweenClassScatter(X,y,PI);
  if isnan(S_w)
      SS = NaN;
      return;
  end
  SS = (trace(pinv(S_w)*S_b));
end