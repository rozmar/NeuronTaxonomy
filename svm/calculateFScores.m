

function Fscores = calculateFScores(X,y)
	Fscores = [];
	for i=1:size(X,2)
		Fs = calculateFscore(X(:,i),y);
		Fscores = [ Fscores ; double(i) Fs ];
	end
	[~,idx] = sort(Fscores(:,2),'descend');
	Fscores = Fscores(idx,:);
end