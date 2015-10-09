%Convert an input file to a more convenient format
function convertInput(name)
	
in = load(name).iv;	%load the initial file
new_in=struct();	%creates the new struct

fields=fieldnames(in);	%get the names of the cells

for fname = fields ;
	iv=in.(fname{1});	%get the actual cell
	new_iv=struct("vals",[]);	%create new cell struct

	for j = 1:iv.sweepnum ;	%loop through the sweeps
 		new_iv.vals=[new_iv.vals;iv.(["v",num2str(j)])'];	%put in a matrix the ivs
	endfor;
	
	%copy the unmodified fields
	new_iv.time=iv.time;
	new_iv.timertime=iv.timertime;
	new_iv.holding=iv.holding;
	new_iv.current=iv.current;
	new_iv.realcurrent=iv.realcurrent;
	new_iv.segment=iv.segment;
	new_in.(fname{1})=new_iv;
endfor;

dirname=substr(name,1,rindex (name, "/"));
filename=substr(name,rindex (name, "/")+1);
save([dirname,"new_",filename],"new_in")
