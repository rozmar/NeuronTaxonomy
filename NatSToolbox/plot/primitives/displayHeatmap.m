% This function displays a heatmap defined by its parameters.
function displayHeatmap(x,y,heatMap)
  pcolor(x,y,heatMap);
  shading interp;
  colormap jet;
end