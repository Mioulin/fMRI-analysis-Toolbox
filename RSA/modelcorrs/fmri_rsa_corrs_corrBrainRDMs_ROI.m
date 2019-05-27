function fmri_rsa_corrs_corrBrainRDMs_ROI(maskName,modelRDMs)
  %% fmri_rsa_corrs_corrBrainRDMs()
  %
  % correlates model RDMs with brain RDM (ROI approach)
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
  grpDir = [params.dir.inDir params.dir.subDir.GRP];

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
  numMods = length(modelRDMs);
  corrs = zeros(params.num.subjects,numMods);
  for subID = 1:params.num.subjects
    subStr = params.names.subjectDir(subID);
    subDir = [params.dir.inDir subStr '/' params.dir.subDir.RDM];
    cd(subDir);
    brainRDMs = load([subDir params.names.rdmSetIn maskName]);
    brainRDM = brainRDMs.subRDM.rdm;
    for modID = 1:numMods
        corrs(subID,modID) = compareRDMs(brainRDM,squeeze(modelRDMs(modID).rdms(subID,:,:)),params.corrs.method);
    end
    % if ~exist('params.dir.subDir.out','dir')
    %   mkdir(params.dir.subDir.out)
    % end
    % cd(params.dir.subDir.out);
    %
  end

  results = struct();
  results.corrs = corrs;
  results.params = params.corrs;

  cd(grpDir);
  save(['groupAvg_' params.names.corrsOut 'orth_' num2str(params.corrs.doOrth) '_set_' params.names.modelset '_' maskName],'results');

end

function r = compareRDMs(rdm1,rdm2,method)

  switch method
    case 'kendall'
      v1 = vectorizeRDM(rdm1);
      v2 = vectorizeRDM(rdm2);
      r = rankCorr_Kendall_taua(v1,v2);
    case 'spearman'
      v1 = vectorizeRDM(rdm1);
      v2 = vectorizeRDM(rdm2);
      r = corr(v1',v2','type','Spearman','rows','complete');
    case 'regression'
      v1 = zscore(vectorizeRDM(rdm1));
      v2 = zscore(vectorizeRDM(rdm2));
      r = regress(v1',v2');
    case 'pearson'
      v1 = zscore(vectorizeRDM(rdm1));
      v2 = zscore(vectorizeRDM(rdm2));
      r = corr(v1',v2','type','Pearson');
  end
end
