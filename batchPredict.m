function batchPredict(fpath, ivlist )
	[cls name ivname] = readInFileList(fpath,ivlist);
	for j=1:length(cls)
		ivs(j) = loadIV("../mdata/IV",name(j,:),ivname(j,:));
	end
	
	correct = 0;
	incorrect = 0;
	predict = 0;
	cls(cls==5)=0;
	length(cls)	
	for j=1:length(cls)
		printf("%d/%d\n", predict, length(cls));
		printf("Try to predict %s %s iv. ", name(j,:), ivname(j,:));
		p = predictSingleIV(ivs(j),"../Database",cls(j), ".", "optimal_theta.mat");
		%printf("%s file and %s iv predicted as %d, really %d.\n",name(j), ivname(j),p,cls(j));
		
		if cls(j)==0 || cls(j)==1
			printf("This file was predicted %s");
			if p==cls(j) 
				printf("correctly");
				correct++;
			else
				printf("incorrectly");
				incorrect++;
			end
			printf("\n");
		else 
			printf("IV was predicted as %d\n", p);	
		end
		
		predict++;
	end
	
	printf("From %d file %d was predicted correctly. Accuracy: %.2f%%\n", predict, correct, (correct/predict)*100);
	
end