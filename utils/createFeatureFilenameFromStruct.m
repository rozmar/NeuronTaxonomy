function featureFileName = createFeatureFilenameFromStruct(nameStructure)
  featureFileName = strcat('data_iv_', nameStructure.id, '_');
  featureFileName = strcat(featureFileName, nameStructure.fname, '_');
  featureFileName = strcat(featureFileName, nameStructure.post, '.mat');
end