function params = fmri_tdt_setParamsMVPA()
%% fmri_tdt_setParamsGLM
%
% set parameters for MVPA
%
% Timo Flesch, 2019,
% Human Information Processing Lab,
% Experimental Psychology Department
% University of Oxford

  params = struct();

  params.resultName = 'swres_accuracy_minus_chance.nii';
  params.glmName =  'glm_mvpa';
  % directories
  params.dir.glmSubDir   = [params.glmName '/'];
  params.dir.resultsDir  = '';
  params.dir.glmDir      = [params.dir.resultsDir params.dir.glmSubDir];
  params.dir.decDir        = ['' params.glmName '/'];
  params.dir.designSubDir   = [''];
  params.dir.betaSubDir     = [''];
  params.dir.decSubDir  = 'mvpa/';
  params.dir.outSubDir   = ['mvpa/'];
  params.dir.groupSubDir = 'groupLevel/';

  % files
  params.files.overwrite = 1; % overwrite existing files
   params.files.overwriteContrasts = 1;
  % searchlight
  params.searchlight.radius = 4;
  params.searchlight.units  = 'voxels';


  % model
  params.model.specification = '-s 0 -t 0 -c 1 -b 0 -q'; % linear classification
  params.model.method =  'classification_kernel';
  params.model.software =  'libsvm';

  % labels
  params.labels.classA = ['leftButton'];
  params.labels.classB = ['rightButton'];

  % regular expressions for filenames
  params.regex.functional   = '^swauf.*\.nii$'; % functional images
  params.regex.motionregs   = '^rp.*\.txt$';    % txt file with motion regressors (from realignment preproc step)
  params.regex.contrasts    = '^con.*\.nii$';   % contrast images

  % monitoring params
  params.monitor.plotSearchlight = 0; % show searchlight during decoding
  params.monitor.plotDesign      = 1; % show design prior to decoding
  params.monitor.reviewDMAT      = 1; % review 2nd level design matrix

  % numbers
  params.num.subjects   = 14; % number of subjects (o rly)
  params.num.runs       =  6; % number of runs

end
