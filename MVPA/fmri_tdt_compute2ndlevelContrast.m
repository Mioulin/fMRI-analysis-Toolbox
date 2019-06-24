% computes voxel-wise t-tests at group level.
%
% Timo Flesch, 2018,
% Human Information Processing Lab,
% Experimental Psychology Department
% University of Oxford

% parameters and file names
params =                fmri_tdt_setParamsMVPA();

% directories
outDir_group = [params.dir.glmDir params.dir.groupSubDir];
cd(params.dir.glmDir);
if ~exist('params.dir.groupSubDir','dir')
  mkdir(params.dir.groupSubDir);
  cd(params.dir.groupSubDir);
else
  cd(outDir_group);
end

% stats
  cd(outDir_group);
  if ~exist(['mvpaCon/'],'dir')
    mkdir(['mvpaCon/']);
    cd(['mvpaCon/']);
  else
    cd(['mvpaCon/']);
  end
  outDir_group_con = [outDir_group 'mvpaCon/'];

  matlabbatch = {};
  for subIDX = 1:params.num.subjects
    subjectDirName = set_fileName(subIDX);
    outDir_decResults  = [params.dir.decDir subjectDirName '/' params.dir.decSubDir];
    % move to directory that contains all contrast images
    cd(outDir_decResults);
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans{subIDX,1} = [outDir_decResults params.resultName];
  end
  cd(outDir_group_con);

  matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none     =   [];
  % matlabbatch{1}.spm.stats.factorial_design.masking.im             =    0;
  % matlabbatch{1}.spm.stats.factorial_design.masking.em             = {[]};
  matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit         =   [];
  matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no =   [];
  matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm        =    1;
  matlabbatch{1}.spm.stats.factorial_design.dir          = {outDir_group_con};



  % save batch
  save('batchFile_specMVPA2nd.mat','matlabbatch');

  % specify model
  disp(['Now specifying 2nd-level model for mvpa contrast']);
  spm_jobman('run','batchFile_specMVPA2nd.mat');
  clear matlabbatch;

  % if desired (highly recommended!), review design matrix before estimation begins
  if params.monitor.reviewDMAT
    cd(outDir_group_con);
    load('SPM.mat');
    spm_DesRep('DesMtx',SPM.xX);
  end

  % estimate parameters ("beta" image)
  cd(outDir_group_con);
  matlabbatch = {};
  matlabbatch{1}.spm.stats{1}.fmri_est.spmmat = {[outDir_group_con 'SPM.mat']};
  save('batchFile_estMVPA2nd.mat','matlabbatch');
  disp(['Now estimating 2nd-level model for mvpa contrast']);
  spm_jobman('run','batchFile_estMVPA2nd.mat');
  clear matlabbatch;

  % specify contrasts (2nd level rfx)
  matlabbatch = {};
  matlabbatch{1}.spm.stats.con.spmmat    = {[outDir_group_con 'SPM.mat']};
  matlabbatch{1}.spm.stats.con.consess{1}.tcon.name     = params.glmName;
  matlabbatch{1}.spm.stats.con.consess{1}.tcon.convec   =              [1];
  matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep  =           'none';
  matlabbatch{1}.spm.stats.con.delete                   = params.files.overwriteContrasts;

  save('batchFile_conMVPA2nd.mat','matlabbatch');
  disp(['2nd level test for mvpa contrast']);
  spm_jobman('run','batchFile_conMVPA2nd.mat');
  clear matlabbatch;
