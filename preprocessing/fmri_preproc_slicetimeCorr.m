function fmri_preproc_slicetimeCorr()
  %% fmri_preproc_slicetimeCorr
  %
  % performs slice time correction on EPIs
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford

  params = fmri_preproc_setParams();

  disp(['Slice Time Correction of EPIs']);
  for subID = 1:params.num.subjects
    subjectDirName = set_fileName(subID);

    disp(['... job specification for subject : ', num2str(subID)]);

    % cd so that .mat and .ps files are written in functional dir
    cd([params.dir.imDir subjectDirName '/' params.dir.epiSubDir]);

    % collect all EPIs (of all sessions)
    for runID = 1:params.num.runs
        funcDir = [params.dir.imDir subjectDirName '/' params.dir.epiSubDir  params.dir.runSubDir num2str(runID) '/'];
        % select realigned and unwarped EPI images
        fileNames   = spm_select('List', funcDir,['^' params.reuw.unwarpresl.prefix  'f.*\.nii$']);
        runFiles = cellstr([repmat(funcDir,size(fileNames,1),1) fileNames]);

        matlabbatch{1}.spm.temporal.st.scans(runID).scans = runFiles;
        fileNames = [];
        runFiles  = [];
    end

    % populate batch fields with options from params file:
    matlabbatch{1}.spm.temporal.st = params.st;

    % save job description
    save('batchFile_stEPI.mat','matlabbatch');

    % run job
    disp(['... slice-time correct EPIs for subject ' num2str(subID)])
    spm_jobman('run','batchFile_stEPI.mat');
    clear matlabbatch
  end
