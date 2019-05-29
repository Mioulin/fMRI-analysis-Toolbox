function wrapper_rsa_corr_roi()
  %% wrapper_rsa_corr_roi()
  %
  % computes ROI-based RDMs
  % using my own pipeline, and tdt for comparison
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford

  roiMasks = {'r_mask_wfu_BA17', ...
  'r_mask_wfu_BA18','r_mask_wfu_BA19'};
  % loop through masks
  % compute rdms
  for maskID = 1:length(roiMasks)
    mask = roiMasks{maskID};
    disp(['ROI MODELCORRS with mask ' mask]);
    fmri_rsa_corrs_corrBrainRDMs_ROI(mask)
    disp(['...done']);
  end
