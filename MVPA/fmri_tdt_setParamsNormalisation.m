function params = fmri_tdt_setParamsNormalisation()
%% fmri_preproc_setParams
%
% sets all parameters for preprocessing of fmri data
%
% Timo Flesch, 2019

  params = struct();

  params.glmName = 'glm_mvpa';

  params.dir.spmDir = '';
  params.dir.imDir        = '';
  params.dir.decDir        = ['' params.glmName '/'];
  params.dir.runSubDir  = 'run_';
  params.dir.decSubDir  = 'mvpa/';
  params.dir.structSubDir = 'structural/';

  % regular expressions for filenames
  params.regex.decImage    = '^res_accuracy_minus_chance.nii'; % decoding results
  params.regex.structCoregImages = '^rs.*\.nii$'; % structural images (coregistered)

  % EPI image options
  params.epi.voxelSize = [3.5 3.5 3.5];
  % numbers
  params.num.subjects   = 14; % number of subjects (o rly)
  params.num.runs       =  6; % number of runs
  params.num.conditions =  8; % number of conditions
