function wrapper_rsa_makeMDSfigure()
  %%
  %
  % projects group-level ROI RDM into 2D and
  % displays as figure.
  % saves images in various formats
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford
  params = fmri_rsa_compute_setParams();

  roiMasks = {'r_mask_wfu_BA17', ...
  'r_mask_wfu_BA18','r_mask_wfu_BA19'};

  % loop through masks
  % compute rdms
  for maskID = 1:length(roiMasks)
    mask = roiMasks{maskID};
    disp(['ROI MDS figure with mask ' mask]);
    close all;
    load(['groupAvg_' params.names.rdmSetOut mask]);
    xy = fmri_rsa_mds_rdmToND(groupRDM.rdm,2,'sstress');
    fmri_rsa_disp_showMDS(xy,1);
    saveas(gcf,['groupAvg_MDS_' params.names.rdmSetOut mask '.png']);
    saveas(gcf,['groupAvg_MDS_' params.names.rdmSetOut mask],'svg');
    disp('...done');
  end
