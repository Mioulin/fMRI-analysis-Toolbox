function fmri_tdt_smooth()
  %% fmri_tdt_smooth
  %
  % smoothes normalised decoding results
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford

  params = fmri_tdt_setParamsSmoothing();

  disp(['smoothing normalised decoding results for all subjects']);
  for subID = 1:params.num.subjects

    subjectDirName = set_fileName(subID);

      disp(['Smoothing job specification for subject : ', num2str(subID)]);

      decDir    = [params.dir.decDir subjectDirName '/' params.dir.decSubDir];

      cd(decDir);
      decFile      = spm_select('List', decDir, params.regex.decImage);

      matlabbatch{1}.spm.spatial.smooth.data = {[decDir decFile]};
      matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8];
      matlabbatch{1}.spm.spatial.smooth.dtype = 0;
      matlabbatch{1}.spm.spatial.smooth.im = 0;
      matlabbatch{1}.spm.spatial.smooth.prefix = 's';

      % save and run job
      save('batchFile_smoothDEC.mat','matlabbatch');


      disp(['SMOOTHING MVPA results for subject ' num2str(subID)])
      spm_jobman('run','batchFile_smoothDEC.mat');
      clear matlabbatch
  end
