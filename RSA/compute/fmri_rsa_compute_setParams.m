function params = fmri_rsa_compute_setParams()
  %% fmri_rsa_compute_setParams()
  %
  % sets parameters for rdm computation
  %
  % Timo Flesch, 2019

  params = struct();

  %% directories
  % directory for behavioural data
  params.dir.behavDir = '';
  % directory for dissimilarity ratings
  params.dir.dissimDir = '';
  % directory for stim images
  params.dir.imageDir  = '';
  params.dir.bgDir     = '';
  % imaging directories
  params.dir.inDir    = '';
  params.dir.outDir   =  '';
  params.dir.maskDir  = '';
  params.dir.subDir.SPM     = '';
  params.dir.subDir.RDM     = '';
  params.dir.subDir.GRP     = '';


  %% file names
  params.names.subjectDir   = @(subID)sprintf('SUB%03d',subID);
  params.names.groupMask    =  '';
  params.names.roiMask      =  '';
  params.names.rdmSetIn     =  '';
  params.names.rdmSetOut    =  '';
  params.names.corrsOut     =  '';
  params.names.models       =  '';
  params.names.modelset     =  '';


  %% numbers
  params.num.subjects   = 14; % number of subjects (o rly)
  params.num.runs       =  6; % number of runs
  params.num.conditions = 50; % number of conditions
  params.num.motionregs =  6; % number of motion regressors


  %% rsa
  params.rsa.method    =         'roi'; % 'roi', 'searchlight'
  params.rsa.whichruns =        'cval'; % 'avg', 'crossval'. avg is mean RDM across runs. If crossval is selected, creates nRunsxnRuns RDM (brain and models), where within run dissims are NaN
  params.rsa.metric    =  'correlation'; % distance metric
  params.rsa.whiten    =             0; % whiten betas (irrespective of dist measure)
  params.rsa.radius    =             3; % radius of searchlight sphere
  %% hpc
  params.hpc.parallelise = 0;
  params.hpc.numWorkers  = 0;
