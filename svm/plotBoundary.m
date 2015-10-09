


function plotBoundary(model,xlim,margin)
	w = model.SVs' * model.sv_coef;
	b = -model.rho;
	if model.Label(1) == -1
	  w = -w;
	  b = -b;
	end
	if length(w)==2
		a = -w(1)/w(2);
		b = -b/w(2);
		x = linspace(xlim(1),xlim(2));
		y = a*x .+ b;
		plot(x,y,'-k','LineWidth',4);
		if nargin==3 && margin==1
			ydown = a*x + b + ( 1 / w(2) ) ;
			plot(x,ydown,'--k');
			yup = a*x + b - ( 1 / w(2) ) ;
			plot(x,yup,'--k');
		end
	else
		x = [ -b/w(1) -b/w(1) ];
		y = [ 1 -1 ];
		plot(x,y,'-k','LineWidth',4);
	end
end