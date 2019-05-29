function wrapper_rsa_sigtest_roi()
  %% wrapper_rsa_sigtest_roi()
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
    disp(['ROI STATINF ON CORRS with mask ' mask]);
    fmri_rsa_corrs_sigtest_ROI(mask);
    disp(['...done']);
  end
