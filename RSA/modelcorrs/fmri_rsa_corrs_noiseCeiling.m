function [ub,lb] = fmri_rsa_corrs_noiseCeiling(maskName)
  %% [ub,lb] = fmri_rsa_corrs_noiseCeiling(maskName)
  %
  % adapted from ceilingAvgRDMCorr in rsatoolbox
  %
  % computes the lower and upper bounds of the noise ceiling
  % For pearson and spearman correlations, analytic solutions for the upper
  % bound exist:
  % pearson: corr with mean of z-scored RDMs
  % spearman: corr with mean of ranktransformed RDMs
  %
  % for Kendall's taua, only an approximate method is used:
  % taua: corr with mean of ranktransformed RDMs
  % This bound is not tight, but closer (numerical) approximations
  % take up too much compute time (ref ceilingAvgRDMCorr.m in rsatoolbox)
  %
  % The lower bound is estimated as leave-one-subject-out RDM correlation
  % irrespective of the chosen correlation method
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford

  params = fmri_rsa_corrs_setParams();
  grpDir = [params.dir.inDir params.dir.subDir.GRP];
  % load rdms into grplvl mat
  rdmSet = [];
  for subID = 1:params.num.subjects
    subStr = params.names.subjectDir(subID);
    subDir = [params.dir.inDir subStr '/' params.dir.subDir.RDM];
    cd(subDir);
    brainRDMs = load([subDir params.names.rdmSetIn maskName]);
    brainRDM = brainRDMs.subRDM.rdm;
    rdmSet(:,:,subID) = brainRDM;
  end
  rdmVect = vectorizeRDMs(rdmSet); % 1-x-dissims-x-subs
  [~, nDissims, nSubjects]=size(rdmVect);

  %% upper bound
  ub = [];
  switch params.corrs.method
  case 'pearson'

      rdmVect=rdmVect-repmat(nanmean(rdmVect,2),[1 nDissims 1]);
      rdmVect=rdmVect./repmat(std(rdmVect,[],2),[1 nDissims 1]);
      meanRDM=nanmean(rdmVect,3);

  case {'spearman','kendall'}

      rdmVect=reshape(tiedrank(reshape(rdmVect,[nDissims nSubjects])),[1 nDissims nSubjects]);
      meanRDM=nanmean(rdmVect,3);

  end

  ubCorrs = [];
  for subID = 1:params.num.subjects
    ubCorrs(subID) = compareDissims(meanRDM,rdmVect(1,:,subID),params.corrs.method);
  end

  ub = nanmean(ubCorrs);

  %% lower bound
  for subID = 1:params.num.subjects
    losoVect = rdmVect(1,:,:);
    losoVect(:,:,subID) = [];
    losoVect = nanmean(losoVect,3);
    lbCorrs(subID) = compareDissims(losoVect,rdmVect(1,:,subID),params.corrs.method);
  end
  lb = nanmean(lbCorrs);

  noiseCeiling = struct();
  noiseCeiling.lb = lb;
  noiseCeiling.ub = ub;
  cd(grpDir);
  save(['noiseCeiling_' params.names.corrsOut maskName],'noiseCeiling');
end

function r = compareDissims(dv1,dv2,method)

  switch method
    case 'kendall'
      v1 = dv1(:);
      v2 = dv2(:);
      r = rankCorr_Kendall_taua(v1,v2);
    case 'spearman'
      v1 = dv1(:);
      v2 = dv2(:);
      r = corr(v1,v2,'type','Spearman','rows','complete');
    case 'regression'
      v1 = zscore(dv1(:));
      v2 = zscore(dv2(:));
      r = regress(v1',v2');
    case 'pearson'
      v1 = zscore(dv1(:));
      v2 = zscore(dv2(:));
      r = corr(v1,v2,'type','Pearson');
  end
end
