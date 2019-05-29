function wrapper_rsa_computeRDMs_roi()
  %% wrapper_rsa_computeRDMs_roi()
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
    disp(['ROI RSA with mask ' mask]);
    fmri_rsa_compute_performRSA_ROI(mask);
    disp(['...done']);
  end
