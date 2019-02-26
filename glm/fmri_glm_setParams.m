function params = fmri_glm_setParams()
%% FMRI_SET_GLMPARAMS()
%
% set parameters for glm estimation
%
% Timo Flesch, 2018,
% Human Information Processing Lab,
% Experimental Psychology Department
% University of Oxford

  params = struct();

  params.glmName =  'GLM_Buttons';
  % directories
  params.dir.imDir        = '/home/timo/Documents/Work/Projects/BLA/data/data_fmri/final/';
  params.dir.conditionDir = '/home/timo/Documents/Work/Projects/BLA/data/data_behav/final/fmri_identifiers/scan/conditions/';
  params.dir.glmSubDir    = [params.glmName '/'];
  params.dir.glmDir       = ['/home/timo/Documents/Work/Projects/BLA/results/' params.dir.glmSubDir];
  params.dir.epiSubDir    = 'functional/run_';
  params.dir.dmatSubDir   = 'dmats/';
  params.dir.estSubDir    = 'estimates/';
  params.dir.tSubDir      = 'dmats/';%'tContrasts/';
  params.dir.groupSubDir  = 'groupLevel/';
  params.dir.losoSubDir   = 'losoROI/';

  % file handling
  params.files.overwriteContrasts = 1; % delete already estimated contrasts;

  % design matrix
  params.dmat.units           = 'secs'; % units for design (scans or seconds)
  params.dmat.microtime_res   =     32; % number of time bins per scan used for regression. if st corrected: change to numSlices
  params.dmat.microtime_onset =     16; % reference slice
  params.dmat.TR              =      2; % inter scan interval (s)

  % various other parameters
  params.misc.highpass        =     128; % get rid of very low frequency oscillations
  params.misc.basisfuncts     =   [0 0]; % model HRF derivates (e.g. time and dispersion derivatives)
  params.misc.volterra        =       1; % order of convolution for model interaction (volterra). [1,2]
  params.misc.global_norm     =  'none'; % no global normalisation of values
  params.misc.mask            =      ''; % explicit mask (for ROI based analyis, or use segmentation of structural to speed up analyses
  params.misc.serialcorr      = 'AR(1)'; % autoregressive model to account for temporal correlation of signal
  params.misc.mthresh         =     0.8; % masking threshold, defined as proportion of globals


  % regular expressions for filenames
  params.regex.functional   = '^swauf.*\.nii$'; % functional images
  params.regex.motionregs   = '^rp.*\.txt$';    % txt file with motion regressors (from realignment preproc step)
  params.regex.contrasts    = '^con.*\.nii$';   % contrast images


  % numbers
  params.num.subjects   = 14; % number of subjects (o rly)
  params.num.runs       =  6; % number of runs
  params.num.conditions =  2; % number of conditions
  params.num.motionregs =  6; % number of motion regressors

  % monitoring params
  params.monitor.reviewDMAT      = 0;
  params.monitor.reviewContrasts = 0;


end
