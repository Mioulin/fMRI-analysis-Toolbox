function wrapper_rsa_makeRDMfigure()
  %% wrapper_rsa_makeRDMfigure()
  %
  % generates figure of group level RDMs
  % saves images in various formats
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford
  params = fmri_rsa_compute_setParams();

  roiMasks = {'r_mask_wfu_BA17', ...
  'r_mask_wfu_BA18','r_mask_wfu_BA19'};

  distMeasures = {'CorrDist_',...
  'Crossnobis_roi_','EuclDist_','MahalDist_roi_',...
  'WhitenCorrDist_'};


  % loop through masks
  % compute rdms
  for dmID = 1:length(distMeasures)
    for maskID = 1:length(roiMasks)
      mask = roiMasks{maskID};
      disp(['ROI RDM figure with mask ' mask]);
      close all;
      load(['groupAvg_rdmSet_' distMeasures{dmID} mask]);
      fmri_rsa_disp_showRDM(groupRDM.rdm,1);
      set(gcf,'Position',[675, 36,1153, 935]);
      saveas(gcf,['groupAvg_RDM_rdmSet_' distMeasures{dmID} mask '.png']);
      saveas(gcf,['groupAvg_RDM_rdmSet_' distMeasures{dmID} mask],'svg');
      disp('...done');
    end
  end
