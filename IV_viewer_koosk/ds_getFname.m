function fname = ds_getFname(dsElement)

fname = strsplit(dsElement.fname, '.');
fname = fname{1};

end

