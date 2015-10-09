function index = findById(array, id)
  index = -1;
  for i = 1 : length(array)
    if strcmp(array(i){1},id)==1
      index = i;
      return;
    end
  end
  
end