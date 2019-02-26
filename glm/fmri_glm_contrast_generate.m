function contrasts = fmri_glm_contrast_generate()
%% fmri_glm_contrast_generate()
%
% specifies 1st level contrast vectors
%
% Timo Flesch, 2018
% Human Information Processing Lab
% Experimental Psychology Department
% University of Oxford

  if ~exist('monitor','var')
    monitor = 0;
  end

  params = fmri_glm_setParams();
  contrasts = struct();

  % give the contrasts sensible names
  contrasts.T.labels = {'Left > Right', 'Right > Left'};
    % define the contrast vectors ( [repmat([CONDITIONS, MOTIONREGS],1,numRuns), RUNIDS] )
  contrasts.T.vectors(1,:) = helper_genContrastVector(2,1,2,params);
  contrasts.T.vectors(2,:) = helper_genContrastVector(2,2,1,params);

end
