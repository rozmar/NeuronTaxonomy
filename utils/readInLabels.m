

function l = readInLabels(listpath,listName)
	[l i n g s c] = textread([listpath,"/",listName],"%d %s %s %d %d %d");	
end