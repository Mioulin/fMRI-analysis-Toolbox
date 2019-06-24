function params = fmri_tdt_setParamsSmoothing()
%% fmri_tdt_setParamsSmoothing
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
  params.regex.decImage    = '^wres_accuracy_minus_chance.nii'; % decoding results
  params.regex.structCoregImages = '^rs.*\.nii$'; % structural images (coregistered)

  % EPI image options
  params.epi.voxelSize = [3.5 3.5 3.5];

  % smoothing
  params.smooth.fwhm  = [8 8 8];% smoothing window size
  params.smooth.dtype = 0; % same
  params.smooth.im    = 0; % no implicit masking
  params.smooth.prefix = 's';
  % numbers
  params.num.subjects   = 14; % number of subjects (o rly)
  params.num.runs       =  6; % number of runs
  params.num.conditions =  8; % number of conditions
