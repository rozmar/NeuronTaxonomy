%Shuffles the rows of a matrix.
%
function shfld = shuffleMatrix(matrix)
	shfld = matrix(randperm(size(matrix,1)),:);
end