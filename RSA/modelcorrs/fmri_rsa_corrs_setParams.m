function params = fmri_rsa_corrs_setParams()
  %% params = fmri_rsa_corrs_setParams()
  %
  % sets parameters for correlation between estimated brain and model RDMs
  %
  % Timo Flesch, 2019

  params = struct();

  %% directories
  % directory for behavioural data
  params.dir.behavDir = '';
  % directory for dissimilarity ratings
  params.dir.dissimDir = '';
  % directory for tree images
  params.dir.imageDir  = '';
  params.dir.bgDir     = '';
  % imaging directories
  params.dir.inDir    = '';
  params.dir.outDir   =  '';
  params.dir.maskDir  = '';
  params.dir.subDir.SPM     = '';
  params.dir.subDir.RDM     = '';
  params.dir.subDir.out   = '';
  params.dir.subDir.GRP     = '';



  %% file names
  params.names.subjectDir  = @(subID)sprintf('SUB%03d',subID);
  params.names.groupMask   = '';
  params.names.rdmSetIn    = '';
  params.names.rdmSetOut   = '';
  params.names.corrsOut    = '';
  params.names.models      = '';
  params.names.modelset    = '1';


  %% model correlations
  params.corrs.modelset  = str2num(params.names.modelset);
  params.corrs.modellist = [1,2,3,8]; % list of models to include (modelRDMs is a n-D struct)
  params.corrs.doOrth    =  0; % apply Gram-Schmidt orthogonalisation (y/n)
  params.corrs.method    = 'spearman'; % kendall, regression (instead of correlations), spearmann


  %% numbers
  params.num.subjects   = 14; % number of subjects (o rly)
  params.num.runs       =  6; % number of runs
  params.num.conditions = 50; % number of conditions
  params.num.motionregs =  6; % number of motion regressors


  %% statistical inference
  params.statinf.doFisher  = 1; % fisher transformation (if method==spearman and test == t-test)
  params.statinf.threshVal = .05;
  params.statinf.threshStr = char(replace(num2str(params.statinf.threshVal),'.','')); % for file names
  params.statinf.method    = 'ttest'; % signrank or t-test
  params.statinf.tail       = 'right';   % right or both makes sense for modelcorrelations
