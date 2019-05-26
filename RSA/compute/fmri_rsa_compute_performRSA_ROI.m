function rdmCollection = fmri_rsa_compute_performRSA_ROI(roiName)
  %% fmri_rsa_compute_performRSA_ROI(roiName)
  %
  % computes rdms for each subject, saves results
  % at subject and group-average level
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford


  params = fmri_rsa_compute_setParams();

  if exist('roiName','var') % if user has specified roi, overwrite params
    params.names.roiMask = roiName;
  end

  % load group level mask (wholebrain OR structural ROI)
  % switch params.rsa.method
  % case 'searchlight'
  %   gmaskMat  = fmri_io_nifti2mat([params.names.groupMask '.nii'],params.dir.maskDir);
  % case 'roi'
  gmaskMat  = fmri_io_nifti2mat([params.names.roiMask '.nii'],params.dir.maskDir);
  % end
  gmaskVect = gmaskMat(:);
  gmaskIDsBrain = find(~isnan(gmaskVect));
  grpDir = [params.dir.inDir params.dir.subDir.GRP];

  for subID = 1:params.num.subjects
    % navigate to subject folder
    subStr = params.names.subjectDir(subID);
    subDir = [params.dir.inDir subStr '/'];

    disp(['processing subject ' subStr]);
    spmDir = [params.dir.inDir subStr '/' params.dir.subDir.SPM];
    rsaDir = [params.dir.inDir subStr '/' params.dir.subDir.RDM];

    % load SPM.mat
    cd(spmDir);
    load(fullfile(pwd,['../' params.dir.subDir.SPM 'SPM.mat']));


    % import betas, mask them appropriately
    disp('....importing betas');
    bStruct = struct();
    [bStruct.b,bStruct.events] = fmri_rsa_helper_getBetas(SPM,params.num.runs,params.num.conditions,params.num.motionregs,gmaskIDsBrain);
    bStruct.b = reshape(bStruct.b,[size(bStruct.b,1)/params.num.runs,params.num.runs,size(bStruct.b,2)]);
    bStruct.events = reshape(bStruct.events,[params.num.conditions,params.num.runs]);
    bStruct.idces = gmaskIDsBrain;

    % if mahalanobis, import residuals, whiten betas
    if strcmp(params.rsa.metric,'mahalanobis') || strcmp(params.rsa.metric,'crossnobis') || params.rsa.whiten==1
      disp('....importing residuals')
      cd(spmDir);
      r = fmri_rsa_helper_getResiduals(SPM,gmaskIDsBrain,0);
      r = reshape(r,[size(r,1)/params.num.runs,params.num.runs,size(r,2)]);
      rStruct = struct();
      rStruct.r = r;
      rStruct.idces = gmaskIDsBrain;
      disp(' .....  whitening the parameter estimates');
      bStruct.b = fmri_rsa_helper_whiten(bStruct.b,rStruct.r);
      cd(rsaDir);
    end
    % compute rdms
    switch params.rsa.whichruns
    case 'avg'
      rdmCollection(subID,:,:) = fmri_rsa_compute_rdmSet_avg(bStruct.b,params.rsa.metric);
    case 'cval'
      rdmCollection(subID,:,:) = fmri_rsa_compute_rdmSet_cval(bStruct.b,params.rsa.metric);
    end

    % navigate to output subfolder
    cd(rsaDir);

    % save results (with condition labels)
    subRDM = struct();
    subRDM.rdm = squeeze(rdmCollection(subID,:,:));
    subRDM.roiName = params.names.roiMask;
    subRDM.roiIDCES = gmaskIDsBrain;
    subRDM.events   = bStruct.events(:,1);
    subRDM.subID    = subID;
    save([params.names.rdmSetOut params.names.roiMask],'subRDM');
  end
  % navige to group level folder
  cd(grpDir);

  % ..and store group average (for visualisation)
  groupRDM          = struct();
  groupRDM.rdm      = squeeze(mean(rdmCollection,1));
  groupRDM.roiName  = params.names.roiMask;
  groupRDM.roiIDCES = gmaskIDsBrain;
  groupRDM.events   = bStruct.events(:,1);
  % groupRDM.subID    = subID;
  save(['groupAvg_' params.names.rdmSetOut params.names.roiMask],'groupRDM');

end
