


function drawVDiff(x,y1,y2)
	hold on;
	%plot([x x],[y1 y2],"k-","linewidth",7);
  plot([x x],[y1 y2],"k-","linewidth",1,"linestyle","--");
	hold off;	
end