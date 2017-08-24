% This function creates a random classification for 2 groups
function categoryVector = randomCategory(~, triggerVector, ~)

  % Constant category vector
  categoryVector = [ones(ceil(length(triggerVector)/2),1);ones(floor(length(triggerVector)/2),1).*2];
  categoryVector = categoryVector(randperm(length(triggerVector)));
end

