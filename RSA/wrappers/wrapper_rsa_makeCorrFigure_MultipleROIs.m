function wrapper_rsa_makeCorrFigure_MultipleROIs()
  %%
  %
  % computes ROI-based RDMs
  % using my own pipeline, and tdt for comparison
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford

  params = fmri_rsa_corrs_setParams();

  roiMasks = {'r_mask_wfu_BA17', ...
  'r_mask_wfu_BA18','r_mask_wfu_BA19'};

  doOrth = [0,1];
  distMeasures = {'EuclDist','MahalDist_roi','Crossnobis_roi','CorrDist','WhitenCorrDist'};
  % loop through masks


  for ii_dm = 1:length(distMeasures)
    for ii_or = 1:length(doOrth)

    close all;

    fnameFig = ['groupAvg_figure_MultipleROIs_' distMeasures{ii_dm}  '_orth_' num2str(doOrth(ii_or))];

    fmri_rsa_disp_showCorrs_MultipleROIs(1,roiMasks,distMeasures{ii_dm},doOrth(ii_or));
    saveas(gcf,[fnameFig '.png']);
    saveas(gcf,fnameFig,'svg');
  end
  end
