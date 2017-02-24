% plotCustomPolar creates a custom polar plot with the given outer circle
% size. On the new plot there will be 3 radials (maximal, half of the
% maximal and quarter of the maximal value) and spokes in each 45 degrees.
%
% Parameters
%  circleLimit - value of the outermost circle
function plotCustomPolar(circleLimit)

  textOffset = circleLimit/20;
  spokeScale = circleLimit*[0.25,0.5,1];
  
  % Create initial circular plot
  h = polar(0,circleLimit);
  hold on;
    
  % Clear lines from circular
  clearCircular(h);
    
  % Create new spokes
  createSpokes(textOffset, spokeScale);
    
  % Create new radials
  createRadials(textOffset, spokeScale);
end

% Creates radials and labels for it
function createRadials(textOffset, spokeScale)
    
  rx = circ_ang2rad(linspace(0,360,720));
  for i = 1 : length(spokeScale)  
    thisRadial = spokeScale(i) * exp(1i * rx);
    if i==length(spokeScale)
      plot(real(thisRadial),imag(thisRadial),'k-','LineWidth',2);
    else
      plot(real(thisRadial),imag(thisRadial),'k:','LineWidth',0.5);
    end
  end
  
  fontSizes  = [12,13,14]; 
  for i = 1 : length(spokeScale)
       
    if hasFraction(spokeScale(i))
      spokeDirection = 52.5;
    else
      spokeDirection = 45;
    end
    
    spokeDirection = circ_ang2rad(spokeDirection);
    
    labelText = num2str(spokeScale(i));
    labelPosition = (spokeScale(i)+textOffset) * exp(1i * spokeDirection);
              
    text(real(labelPosition), imag(labelPosition), labelText, 'FontSize', fontSizes(i), 'FontName', 'Arial');
  end  
    
    
end

% This function create 3 new spokes at the outermost circle and at its half
% and quarter value. The value of the spoke will be shown there.
function createSpokes(textOffset, spokeScale)
  
  spokeDirections = circ_ang2rad(0:30:330);
  spokeLength     = max(spokeScale);
  
  % Draw and label new spokes
  for i = 1 : length(spokeDirections)
      
    spokeEndpoint = spokeLength * exp(1i * spokeDirections(i));
    
    plot([0,real(spokeEndpoint)], [0,imag(spokeEndpoint)], 'k:');

    if (5/6*pi)<=spokeDirections(i)&&spokeDirections(i)<=(7/6*pi)
      labelPosition = (spokeLength+4*textOffset) * exp(1i*spokeDirections(i));
    elseif (3/6*pi)<=spokeDirections(i)&&spokeDirections(i)<=(9/6*pi)
      labelPosition = (spokeLength+3*textOffset) * exp(1i*spokeDirections(i));  
    else
      labelPosition = (spokeLength+textOffset) * exp(1i*spokeDirections(i));  
    end
    
    labelText     = [num2str(circ_rad2ang(spokeDirections(i))),'\circ'];
    text(real(labelPosition), imag(labelPosition), labelText, 'FontSize', 13, 'FontName', 'Arial');
  end
end

% This function clear everything from the circular plot.
function clearCircular(h)
    %Delete initial radials and spokes
    children = findall(gcf, 'type', 'line');
    children(children==h)=[];
    delete(children);
    
    % Delete labels
    ph = findall(gca,'type','text');    
    ps = get(ph, 'string');
    for i = 1 : length(ps)
        ps{i} = '';
    end
    set(ph,{'string'},ps);
end

% Decide if the given number has fractional value
function result = hasFraction(number)
  result = (number~=round(number));
end