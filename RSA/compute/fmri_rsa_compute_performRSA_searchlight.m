function fmri_rsa_compute_performRSA_searchlight()
%% fmri_rsa_compute_performRSA_searchlight()
%
% computes rdms using a spherical searchlight approach
%
% Timo Flesch, 2019
% Human Information Processing Lab
% University of Oxford

params = fmri_rsa_compute_setParams();
% group-level whole brain mask
gmaskMat  = fmri_io_nifti2mat([params.names.groupMask '.nii'],params.dir.maskDir);
gmaskVect = gmaskMat(:);
gmaskIDsBrain = find(~isnan(gmaskVect));

grpDir = [params.dir.inDir params.dir.subDir.GRP];

for (subID = 1:params.num.subjects)
  % navigate to subject folder
  subStr = params.names.subjectDir(subID);
  subDir = [params.dir.inDir subStr '/'];

  disp(['Searchlight RSA - processing subject ' subStr]);
  spmDir = [params.dir.inDir subStr '/' params.dir.subDir.SPM];
  rsaDir = [params.dir.inDir subStr '/' params.dir.subDir.RDM];

  % load SPM.mat
  cd(spmDir);
  load(fullfile(pwd,['../' params.dir.subDir.SPM 'SPM.mat']));

  rdmSet = [];
  revStr = '';

  % import all betas and residuals
  bStruct = struct();
  [bStruct.b,bStruct.events] = fmri_rsa_helper_getBetas(SPM,params.num.runs,params.num.conditions,params.num.motionregs);
  bStruct.b = reshape(bStruct.b,[prod(size(gmaskMat)),size(bStruct.b,4)]);
  bStruct.b = reshape(bStruct.b,[size(bStruct.b,1),params.num.conditions,params.num.runs]);
  bStruct.events = reshape(bStruct.events,[params.num.conditions,params.num.runs]);

  % if mahalanobis, import residuals within sphere, whiten betas with residual covmat
  if strcmp(params.rsa.metric,'mahalanobis') || strcmp(params.rsa.metric,'crossnobis')
    cd(spmDir);
    r = fmri_rsa_helper_getResiduals(SPM);
    r = reshape(r,[size(r,1)/params.num.runs,params.num.runs,size(r,2)]);
    rStruct = struct();
    rStruct.r = r;
    clear r;
    cd(rsaDir);
  end


  for sphereID = 1:length(gmaskIDsBrain)
    % obtain coordinates of centroid
    [x,y,z] = ind2sub(size(gmaskMat),gmaskIDsBrain(sphereID));
    % create spherical mask
    [sphereIDs,sphericalMask] = fmri_mask_genSphericalMask([x,y,z],params.rsa.radius,gmaskMat);
    % keyboard

    % mask betas with sphere, only use masked values
    betas = squeeze(bStruct.b(sphereIDs,:,:));
    betas = permute(betas,[2,3,1]);
    % if mahal/crossnobis, mask resids and whiten masked betas
    if strcmp(params.rsa.metric,'mahalanobis') || strcmp(params.rsa.metric,'crossnobis')
      resids = squeeze(rStruct.r(:,:,sphereIDs));
      betas = fmri_rsa_helper_whiten(betas,resids);
    end
    switch params.rsa.whichruns
    case 'avg'
      rdmSet(sphereID,:,:) = fmri_rsa_compute_rdmSet_avg(betas,params.rsa.metric);
    case 'cval'
      rdmSet(sphereID,:,:) = fmri_rsa_compute_rdmSet_cval(betas,params.rsa.metric);
    end
    revStr = plot_progbar_cli(sphereID,length(gmaskIDsBrain),revStr);
  end
  cd(rsaDir);

  % save results
  subRDM = struct();
  subRDM.rdms = rdmSet;
  subRDM.events   = bStruct.events(:,1);
  subRDM.subID    = subID;
  subRDM.indices  = gmaskIDsBrain;
  save([params.names.rdmSetOut '_searchlight'],'subRDM');

end

end
