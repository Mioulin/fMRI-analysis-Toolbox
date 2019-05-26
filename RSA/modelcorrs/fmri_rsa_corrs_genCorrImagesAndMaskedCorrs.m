function fmri_rsa_corrs_genCorrImagesAndMaskedCorrs()
  %% fmri_rsa_corrs_genCorrImagesAndMaskedCorrs
  %
  % generates grouplevel-masked volumes of correlation coefficients
  % (to include only voxels that have values for all participants)
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford

  params = fmri_rsa_corrs_setParams();
  % load grouplevel mask
  gmaskMat  = fmri_io_nifti2mat('groupMask_rsaSearchlight.nii',params.dir.maskDir);
  gmaskVect = gmaskMat(:);

  allTaus = [];
  % generate images
  params = fmri_rsa_corrs_setParams();
  for subID = 1:params.num.subjects
    % load mask indices
    subStr = sprintf('SUB%03d',subID);
    maskIDs = load([params.dir.inDir subStr '/' params.dir.subDir.RDM params.names.rdmSetIn]);

    maskIDs = maskIDs.subRDM.indices;

    % load correlation coefficients
    corrDir = [params.dir.inDir subStr '/' params.dir.subDir.RDM  params.dir.subDir.out ];
    load([corrDir params.names.corrsOut 'orth_' num2str(params.corrs.doOrth) '_set_' params.names.modelset '_sub_' num2str(subID)]);
    taus = results.corrs;
    % loop through models
    for modID = 1:size(taus,1)
      % get mask indices of single subject taus
      [x,y,z] = ind2sub(size(gmaskMat),maskIDs);
      XYZ = [x y z]';
      % generate volume from indices and tau values
      volMat = fmri_volume_genVolume(size(gmaskMat),XYZ,taus(modID,:));
      % apply group-level mask
      volMat(isnan(gmaskVect)) = NaN;
      % add to big matrix
      allTaus(subID,modID,:,:,:) = volMat;

      % write volume
      fName = fullfile(params.dir.outDir,['taus_searchlight_orth_0_set1_mod' num2str(modID) '_sub' num2str(subID) '.nii']);
      fmri_io_mat2nifti(volMat,fName,'rdm model correlations (spearman on non-orthogonalised models',16);
    end
  end

  % average big matrix and save group-level tau volumes
  for modID = 1:size(taus,1)
    grpTaus = squeeze(mean(allTaus(:,modID,:,:,:),1));
    fName = fullfile(params.dir.outDir,['taus_searchlight_orth_0_set1_mod' num2str(modID) 'groupAvg.nii']);
    fmri_io_mat2nifti(grpTaus,fName,'rdm model correlations (spearman on non-orthogonalised models',16);
  end

  % bonus: store computed tau matrix
  taus = allTaus;
  fName = fullfile(params.dir.outDir,'fmri_rsa_modelcorrs_orth_0_set_1_allsubs_masked');
  save(fName,'taus');
end
