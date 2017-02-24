function printCircularStatistic(resultStructure)
  fprintf('Mean Vector Length:\t%.3f\n', abs(resultStructure.cumulativeMean));
  fprintf('Mean Vector Direction:\t%s\n', toDegreeString(angle(resultStructure.cumulativeMean)));
end

% function calcAndPrint(degrees, value, fileID)
%     phi = circ_mean(circ_ang2rad(degrees'),value');
%     rmean = circ_r(circ_ang2rad(degrees'),value');
%     circstd=circ_std(circ_ang2rad(degrees'),value');
%     circvar=circ_var(circ_ang2rad(degrees'),value');
%     [p,z] = circ_rtest(circ_ang2rad(degrees'),value');
% 
%     fprintf(fileID,'===============================\n');
%     fprintf(fileID,'Resultant vector length: %f\n', rmean);
%     fprintf(fileID,'Mean direction of a sample of circular data: %f (%f rad)\n', circ_rad2ang(phi), phi);
%     fprintf(fileID,'Dispersion around the mean direction: %f (%f rad)\n', circ_rad2ang(circstd), circstd );
%     fprintf(fileID,'Circular variance: %f\n', circvar);
%     fprintf(fileID,'Rayleigh Z-value: %f\nRayleigh test p-value: %.16f\n', z, p);
%     fprintf(fileID,'===============================\n');
% end