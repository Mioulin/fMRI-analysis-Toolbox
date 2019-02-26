function fmri_preproc_smooth()
  %% fmri_preproc_smooth
  %
  % smoothes EPIs with gaussian kernel
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford

  params = fmri_preproc_setParams();

  disp(['Smoothing normalised EPIs']);
  for subID = 1:params.num.subjects
    subjectDirName = set_fileName(subID);
    disp(['... job specification for subject : ', num2str(subID)]);

    % cd so that .mat and .ps files are written in functional dir
    cd([params.dir.imDir subjectDirName '/' params.dir.epiSubDir]);

    allEPIfiles = [];
    % collect all EPIs (of all sessions)
    for runID = 1:params.num.runs
        funcDir = [params.dir.imDir subjectDirName '/' params.dir.epiSubDir  params.dir.runSubDir num2str(runID) '/'];
        % select unwarped and st-corrected images (with which structural is coregistered)
        fileNames   = spm_select('List', funcDir, [params.norm.write.prefix params.regex.epiCoregImages]); % wauf
        runFiles = cellstr([repmat(funcDir,size(fileNames,1),1) fileNames]);
        allEPIfiles = [allEPIfiles; runFiles];  % add files of all sessions
        fileNames = [];
        runFiles  = [];
    end
    % set parameters
    matlabbatch{1}.spm.spatial.smooth = params.smth;

    % add images to smooth
    matlabbatch{1}.spm.spatial.smooth.data = allEPIfiles;

    % save and run job
    save('batchFile_smoothEPI.mat','matlabbatch');

    disp(['... smoothing EPIs for subject ' num2str(subID)])
    spm_jobman('run','batchFile_smoothEPI.mat');
    clear matlabbatch
  end
