function [X,y] = generateSyntheticData(MUS,SIGMAS,elements)
  classes = size(MUS,1);
  dim = size(MUS,2);
  X = [];
  y = [];
  for c = 1 : classes
      x = [];
      for d = 1 : dim
          x = [ x , normrnd(MUS(c,d),SIGMAS(c,d),[elements(c),1]) ];
      end
      X = [ X ; x ];
      y = [ y ; ones(elements(c),1)*c ];
  end
end