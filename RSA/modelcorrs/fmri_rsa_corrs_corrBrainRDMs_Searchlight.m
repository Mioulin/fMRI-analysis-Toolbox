function fmri_rsa_corrs_corrBrainRDMs_Searchlight(modelRDMs)
  %% fmri_rsa_corrs_corrBrainRDMs_Searchlight(modelRDMs)
  %
  % correlates model RDMs with brain RDMs (searchlight approach)
  % if desired, individual model RDMs are orthogonalised
  %
  % Timo Flesch, 2018,
  % Human Information Processing Lab,
  % Experimental Psychology Department
  % University of Oxford

  params = fmri_rsa_corrs_setParams();

  % load pre-computed model RDMs
  if ~exist('modelRDMs','var')
    modelRDMs = load(params.names.models);
    fns = fieldnames(modelRDMs);
    modelRDMs = modelRDMs.(fns{1});
  end

  % only include selection of models
  modelRDMs = modelRDMs(params.corrs.modellist);

  % orthogonalise model RDMs if desired
  if params.corrs.doOrth
    for subID = 1:params.num.subjects
      rdms = [];
      for mID = 1:length(modelRDMs)
        rdms(mID,:,:) = squeeze(modelRDMs(mID).rdms(subID,:,:));
      end
      rdms_orth = fmri_helper_orthogonaliseModelRDMs(rdms);
      for mID = 1:length(modelRDMs)
        modelRDMs(mID).rdms(subID,:,:) = squeeze(rdms_orth(mID,:,:));
      end
    end
  end

  %% do it
  for subID = 1:params.num.subjects
    disp(['processing subject ' num2str(subID)]);
    subStr = params.names.subjectDir(subID);
    subDir = [params.dir.inDir subStr '/' params.dir.subDir.RDM];
    cd(subDir);
    brainRDMs = load([subDir params.names.rdmSetIn]);
    brainRDMs = brainRDMs.subRDM.rdms;
    numRDMs = size(brainRDMs,1);
    numMods = length(modelRDMs);
    corrs = zeros(numMods,numRDMs);
    for modID = 1:numMods
      revStr = '';
      for voxID = 1:numRDMs
        revStr = plot_progbar_cli(voxID,numRDMs,revStr);
        corrs(modID,voxID) = compareRDMs(squeeze(brainRDMs(voxID,:,:)),squeeze(modelRDMs(modID).rdms(subID,:,:)),params.corrs.method);
      end
    end
    results = struct();
    results.corrs = corrs;
    results.params = params.corrs;

    if ~exist('params.dir.subDir.out','dir')
      mkdir(params.dir.subDir.out)
    end
    cd(params.dir.subDir.out);
    save([params.names.corrsOut 'orth_' num2str(params.corrs.doOrth) '_set_' params.names.modelset '_sub_' num2str(subID)],'results');
  end


end

function r = compareRDMs(rdm1,rdm2,method)

  v1 = zscore(vectorizeRDM(rdm1));
  v2 = zscore(vectorizeRDM(rdm2));
  switch method
    case 'kendall'
      r = rankCorr_Kendall_taua(v1,v2);
    case 'spearman'
      r = corr(v1',v2','type','Spearman','rows','complete');
    case 'regression'
      r = regress(v1',v2');
  end
end
