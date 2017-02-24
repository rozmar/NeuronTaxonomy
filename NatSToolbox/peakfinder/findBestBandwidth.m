% findBestBandwidth searches for the h bandwidth value for the Kernel
% density estimation which estimates the data (evaluated in datax) with
% alpha significance level. Test for goodness-of-fit with
% Kolmogorov-Smirnov test. Returns in h the bandwidth which estimates the
% distribution with alpha significance level.
%
% Parameters
%  - dataVector - nx1 vector, events which distribution have to be
%    estimated
%  - xValue - mx1 vector, points where the estimation has to be performed
%  - alpha - scalar, the significance level for KS-test.
% Return values
%  - h - the bandwidth which estimates the given data over the given
%  interval with at least alpha significance level for KS test
function h = findBestBandwidth(dataVector, xValue, parameters)

  %--------------------------------
  % Getting parameters
  %--------------------------------
  if ~isfield(parameters, 'alpha')
    alpha = 1-eps;
  else
    alpha = parameters.alpha;
  end
    
  if ~isfield(parameters, 'printMode')
    PRINT_MODE = 1;
  else
    PRINT_MODE = parameters.printMode;
  end
  %--------------------------------

  %--------------------------------
  % Initialization
  %--------------------------------
  h      = 20.0;    
  lastH  = 0;
  upper  = h;
  lower  = 0;
  tol    = 1e-16;
  %--------------------------------
           
  %--------------------------------
  % Search optimum with binary search
  %--------------------------------
  while true
        
    %--------------------------------
    % Estimate PDF with KDE, and 
    % perform K-S test
    %--------------------------------
    [CDF, Xi] = ksdensity(dataVector,xValue,'bandwidth',h,'function','cdf');
    [H, P] = kstest(dataVector,[Xi,CDF],alpha);
    %--------------------------------
        
    %--------------------------------
    % Print current status, if needed
    %--------------------------------
    if PRINT_MODE==2
      fprintf('BandWidth = %f\n', h);
      fprintf('P = %f, ', P);
      if H==1
        fprintf('rejected\n');
      else
        fprintf('accepted\n');
      end
    end
    %--------------------------------

    lastH = h;
        
    %--------------------------------
    % If the P value is above the 
    % threshold (alpha) raise the
    % bandwidth else  lower the 
    % bandwidth.
    %--------------------------------
    if P>alpha
      h = mean([h,upper]);
      lower = lastH; 
    else
      h = mean([h,lower]);
      upper = lastH;
    end
    %--------------------------------
       
    %--------------------------------
    % Check tolerance: if the difference
    % between the current and desired 
    % P value, or the difference between
    % the current and last bandwidth meets
    % a threshold, stop the search.
    %--------------------------------
    if abs(P-alpha)<tol
        
      if PRINT_MODE==2
        fprintf('Difference between P and alpha below the tolerance level.\n');
      end
      
      break;
    end
    
    if abs(h-lastH)<tol
        
      if PRINT_MODE==2
        fprintf('Difference between h and lasth below the tolerance level.\n');
      end
      
      break;
    end
    %--------------------------------
        
  end
  
  h = lastH;
  
end