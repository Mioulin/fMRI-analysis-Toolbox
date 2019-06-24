function fmri_tdt_normalisation()
  %% fmri_preproc_normalisation
  %
  % normalises decoding results from native to MNI space
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford

  params = fmri_tdt_setParamsNormalisation();

  disp(['Normalising decoding results to mni space']);
  for subID = 1:params.num.subjects

    subjectDirName = set_fileName(subID);

      disp(['Normalization job specification for subject : ', num2str(subID)]);

      structDir = [params.dir.imDir subjectDirName '/' params.dir.structSubDir];
      decDir    = [params.dir.decDir subjectDirName '/' params.dir.decSubDir];

      cd(decDir);


      structFile   = spm_select('List', structDir, params.regex.structCoregImages);
      decFile      = spm_select('List', decDir, params.regex.decImage);
      matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {[structDir structFile]};
      matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = {[decDir decFile]};
      matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
      matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
      matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {[params.dir.spmDir 'tpm/TPM.nii']};
      matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
      matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 1e-03 0.5 0.05 0.2];
      matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
      matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
      matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb       = [-78 -112 -70; 78 76 85]; % bounding box of volume
      matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox      = params.epi.voxelSize;
      matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp   = 4;
      % matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';
      % save and run job
      save('batchFile_normDEC.mat','matlabbatch');


      disp(['NORMALISING MVPA results for subject ' num2str(subID)])
      spm_jobman('run','batchFile_normDEC.mat');
      clear matlabbatch
  end
