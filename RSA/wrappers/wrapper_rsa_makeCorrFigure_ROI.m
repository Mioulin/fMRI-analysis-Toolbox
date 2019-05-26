function wrapper_rsa_makeCorrFigure_ROI()
  %%
  %
  % computes ROI-based RDMs
  % using my own pipeline, and tdt for comparison
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford

  params = fmri_rsa_corrs_setParams();

  roiMasks = {'r_mask_wfu_IT','r_mask_wfu_BA17', ...
  'r_mask_wfu_BA18','r_mask_wfu_BA19', ...
  };



  % loop through masks
  modelRDMs = load(params.names.models);
  fns = fieldnames(modelRDMs);
  modelRDMs = modelRDMs.(fns{1});
  labels = {modelRDMs.name};
  labels = labels(params.corrs.modellist);

  for maskID = 1:length(roiMasks)
    mask = roiMasks{maskID};
    disp(['ROI CORRS figure with mask ' mask]);
    close all;
    fnameCorrs = ['groupAvg_' params.names.corrsOut 'orth_' num2str(params.corrs.doOrth) '_set_' params.names.modelset '_' mask];
    fnameStats = ['groupAvg_STATS_' params.names.corrsOut 'orth_' num2str(params.corrs.doOrth) '_set_' params.names.modelset '_' mask];
    fnameCeil  = ['noiseCeiling_' params.names.corrsOut mask];
    fnameFig = ['groupAvg_figure_' params.names.corrsOut 'orth_' num2str(params.corrs.doOrth) '_set_' params.names.modelset '_' mask];

    load(fnameCorrs);
    load(fnameStats);
    load(fnameCeil);
    fmri_rsa_disp_showCorrs_ROI(results.corrs,stats.p,[],[],labels,noiseCeiling,1);
    saveas(gcf,[fnameFig '.png']);
    saveas(gcf,fnameFig,'svg');
    disp(['...done']);
  end
