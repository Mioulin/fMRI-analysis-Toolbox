function fmri_rsa_corrs_genSigImages_Searchlight(p_thresh)
  %% fmri_rsa_corrs_genSigImages()
  %
  % exports group-level z-, p- and thresholded tau-maps as nifti files
  % with one 3D file per model
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford

  params = fmri_rsa_corrs_setParams();

  if ~exist('p_thresh')
    p_thresh = .05;
  end

  load('fmri_rsa_modelcorrs_orth_0_set_1_allsubs_masked_STATS.mat');
  load('fmri_rsa_modelcorrs_orth_0_set_1_allsubs_masked.mat');

  % compute group average of taus
  taus = squeeze(mean(taus,1));
  for modID = 1:size(results.p,1)
    % store p-image
    fname = fullfile(pwd,['modelcorrs_orth0_set1_p_mod' num2str(modID) '.nii']);
    fmri_io_mat2nifti(1-squeeze(results.p(modID,:,:,:)),fname,'1-p values for model correlations',16);
    % store z-image
    if strcmp(params.statinf.method,'signrank')
      fname = fullfile(pwd,['modelcorrs_orth0_set1_z_mod' num2str(modID) '.nii']);
      fmri_io_mat2nifti(squeeze(results.z(modID,:,:,:)),fname,'z values for model correlations',16);
    elseif strcmp(params.statinf.method,'ttest')
      fname = fullfile(pwd,['modelcorrs_orth0_set1_t_mod' num2str(modID) '.nii']);
      fmri_io_mat2nifti(squeeze(results.t(modID,:,:,:)),fname,'t values for model correlations',16);
    end
    % threshold taus and generate group tau image
    taus(modID,results.p(modID,:)>=p_thresh) = NaN;
    fname = fullfile(pwd,['modelcorrs_orth0_set1_taus_thresh_05_mod' num2str(modID) '.nii']);
    fmri_io_mat2nifti(squeeze(taus(modID,:,:,:)),fname,'thresholded taus for model correlations',16);

  end

end
