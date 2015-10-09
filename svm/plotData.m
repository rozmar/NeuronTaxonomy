function plotData(X, y, label, color)

	figure(randi(100));
	clf;
	hold on;

	if size(X,2)==1
		X = [ X repmat(0,size(X,1),1) ];
	end

	if nargin==2
		
		pos = find(y == 1);
		neg = find(y == 2);

		% Plot Examples
		plot(X(pos, 1), X(pos, 2), 'ro','MarkerSize', 7,'MarkerFaceColor','r');
		plot(X(neg, 1), X(neg, 2), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 7);
	else
		toplot = find(y == label);
		plot(X(toplot, 1), X(toplot, 2), [color,'o'], 'MarkerFaceColor', color, 'MarkerSize', 7);
	end
	hold off;
end
