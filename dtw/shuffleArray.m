function shuffledSet = shuffleArray(inputArray)
  shuffledSet = {};
  order = randperm(length(inputArray), length(inputArray));
  
  for i = 1 : length(order)

    shuffledSet{i} = inputArray{order(i)};  	
  end
end