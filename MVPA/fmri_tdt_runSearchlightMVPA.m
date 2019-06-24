function [results,cfg] = fmri_tdt_runSearchlightMVPA()
  %% tdtMVPA_glm_dec_0()
  %
  % fits a linear SVM with leave-one-run-out crossvalidation to
  % betas estimated with glm_decoding_0 ( left vs right motor response)
  %
  % Script based on "decoding_example" template in the decoding toolbox (tdt)
  %
  % Timo Flesch, 2019

  params = fmri_tdt_setParamsMVPA;

  for subID = 1:params.num.subjects
    disp(['MVPA, subject ' num2str(subID)]);

    subjectDirName = set_fileName(subID);
    betaDir = [params.dir.glmDir subjectDirName '/' params.dir.betaSubDir];
    designDir = [params.dir.glmDir subjectDirName '/' params.dir.designSubDir];
    outDir = [params.dir.glmDir subjectDirName '/' params.dir.outSubDir];

    cfg = [];
    cfg = decoding_defaults(cfg);

    cfg.testmode = 0;
    cfg.analysis = 'searchlight';

    cfg.decoding.method = params.model.method;
    cfg.decoding.software = params.model.software;
    cfg.decoding.train.classification.model_parameters = params.model.specification;
    try
        cfg.software = spm('ver');
    catch % else try out spm8
        cfg.software = 'SPM8';
    end

    if ~exist(outDir,'dir')
      mkdir(outDir);
    end
    cfg.results.dir = outDir;
    cfg.results.overwrite = params.files.overwrite;

    cfg.searchlight.radius = params.searchlight.radius;
    cfg.searchlight.unit = params.searchlight.units; %'voxels';

    fname = dir(fullfile(betaDir,'beta_*.nii'));
    [fp,fn,ext] = fileparts(fname(1).name); %#ok<ASGLU>

    % Use mask in beta dir (e.g. SPM mask) as brain mask
    cfg.files.mask = fullfile(betaDir,['mask' ext]);

    if params.monitor.plotSearchlight
     cfg.plot_selected_voxels = 100; % activate to plot searchlights
    end

    % get regressor names
    regressor_names = design_from_spm(designDir);

    % extract regressors with labelname1 and labelname2, including run number
    % make sure that labels 1 and 2 are uniquely assigned
    cfg = decoding_describe_data(cfg,{params.labels.classA params.labels.classB},[-1 1],regressor_names,betaDir);

    % assign these values to the standard matrix and create the matrix
    cfg.design = make_design_cv(cfg);

    if params.monitor.plotDesign
      display_design(cfg);
    end

    % cfg.results.output = {'AUC_minus_chance'}; % activate for alternative output

    % run results = decoding(cfg)
    [results, cfg] = decoding(cfg);
  end
end
