function fmri_glm_contrast_1stLevel()
  % computes voxel-wise contrasts and t-value map at single subject level
  %
  % Timo Flesch, 2018,
  % Human Information Processing Lab,
  % Experimental Psychology Department
  % University of Oxford

  params = fmri_univar_setParamsGLM_0();


  for subIDX = 1:params.num.subjects
    subjectDirName = fmri_helper_set_fileName(subIDX);
    outDir_spec = [params.dir.glmDir subjectDirName '/' params.dir.dmatSubDir];
    outDir_est  = [params.dir.glmDir subjectDirName '/' params.dir.estSubDir];
    outDir_con  = [params.dir.glmDir subjectDirName '/' params.dir.tSubDir];
    % move to output directory
    cd(outDir_con);

    % generate contrast vectors
    c = fmri_glm_contrast_generate();

    % setup contrast batch
    for cIDX = 1:length(c.T.labels)
      matlabbatch{1}.spm.stats.con.consess{cIDX}.tcon.name    =    c.T.labels{cIDX};
      matlabbatch{1}.spm.stats.con.consess{cIDX}.tcon.convec  = c.T.vectors(cIDX,:);
      matlabbatch{1}.spm.stats.con.consess{cIDX}.tcon.sessrep =              'none';
    end

    matlabbatch{1}.spm.stats.con.delete = params.files.overwriteContrasts;
    matlabbatch{1}.spm.stats.con.spmmat = cellstr({[outDir_spec 'SPM.mat']});

    % save batch
    cd(outDir_con);
    save('batchFile_con.mat','matlabbatch');

    % if desired, review contrasts
    if params.monitor.reviewContrasts
      fmri_helper_dispContrastVectors(c,params);
    end
    disp(['Now computing contrasts for subject ' num2str(subIDX)]);
    spm_jobman('run','batchFile_con.mat');
    clear matlabbatch;
  end
end
