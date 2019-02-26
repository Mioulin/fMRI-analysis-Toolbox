function fmri_preproc_realignUnwarp()
  %% fmri_preproc_realignUnwarp
  %
  % realigns and unwarps functional EPIs
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford

  params = fmri_preproc_setParams();

  disp(['Realignment and Unwarping of functional EPIs']);
  for subID = 1:params.num.subjects
    subjectDirName = set_fileName(subID);

    disp(['... job specification for subject : ', num2str(subID)]);

    % cd so that .mat and .ps files are written in functional dir
    cd([params.dir.imDir subjectDirName '/' params.dir.epiSubDir]);

    allEPIfiles = [];
    % collect all EPIs (of all sessions)
    for runID = 1:params.num.runs
      funcDir = [params.dir.imDir subjectDirName '/' params.dir.epiSubDir  params.dir.runSubDir num2str(runID) '/'];
        % select raw EPI images
        fileNames   = spm_select('List', funcDir,'^f.*\.nii$');
        runFiles = cellstr([repmat(funcDir,size(fileNames,1),1) fileNames]);

        matlabbatch{1}.spm.spatial.realignunwarp.data(runID).scans = runFiles;
        matlabbatch{1}.spm.spatial.realignunwarp.data(runID).pmscan = '';
        fileNames = [];
        runFiles  = [];
    end

    % populate batch fields with options from params file:
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions   = params.reuw.estimate;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions = params.reuw.unwarpest;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions = params.reuw.unwarpresl;

    % save job description
    save('batchFile_reuwEPI.mat','matlabbatch');

    % run job
    disp(['... realigning and unwarping EPIs for subject ' num2str(subID)])
    spm_jobman('run','batchFile_reuwEPI.mat');
    clear matlabbatch
  end
