% This function creates a random classification for 2 groups
function categoryVector = weightedRandomCategory(~, triggerVector, parameters)

  retainRatio = parameters.retainRatio;
  retainNumber = round(length(triggerVector)*retainRatio);
  discardNumber = length(triggerVector)-retainNumber;

  % Constant category vector
  categoryVector = [ones(retainNumber,1);ones(discardNumber,1).*2];
  categoryVector = categoryVector(randperm(length(triggerVector)));
end