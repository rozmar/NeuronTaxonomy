function plotData(X, y,visibility)
%PLOTDATA Plots the data points X and y into a new figure 
%   PLOTDATA(x,y) plots the data points with + for the positive examples
%   and o for the negative examples. X is assumed to be a Mx2 matrix.

if nargin==2
	visibility="off";
end

% Create New Figure
figure("visible",visibility);
clf; 
hold on; 

% ====================== YOUR CODE HERE ======================
% Instructions: Plot the positive and negative examples on a
%               2D plot, using the option 'k+' for the positive
%               examples and 'ko' for the negative examples.
%

% Find Indices of Positive and Negative Examples
pos = find(y==1);
neg = find(y == 0);

% Plot Examples
plot(X(pos, 1), X(pos, 2), 'ro','MarkerFaceColor', 'r', 'MarkerSize', 7);
plot(X(neg, 1), X(neg, 2), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 7);

cl2= find(y==2);
cl3= find(y==3);
cl4= find(y==4);


if size(cl2,2)~=0
  plot(X(cl2, 1), X(cl2, 2), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 7);
  plot(X(cl3, 1), X(cl3, 2), 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 7);
  plot(X(cl4, 1), X(cl4, 2), 'yo', 'MarkerFaceColor', 'y', 'MarkerSize', 7);
end

%xlim([-6,6]);
%ylim([-6,6]);




% =========================================================================



hold off;

end
