function fmri_glm_designMatrix(allData)
  %% FMRI_UNIVAR_GENREGRESSORFILES(allData)
  %
  % generates files with multiple conditions for
  % each run and each subject to speed up
  % constructions of SPM design matrices
  %
  % Timo Flesch, 2018,

  params = fmri_glm_setParams();

  numSubs = length(allData.order);
  numRuns = length(unique(allData.expt_block(1,:)));
  for subID = 1:numSubs
    for runID = 1:numRuns
        names     = {};
        onsets    = {};
        durations = {};

        % %% stim onset
        t_stim = [allData.time_onset_stim(subID,allData.expt_block(subID,:)==runID) - allData.time_trigRun(subID,runID)];
        resp_stim = allData.resp_reactiontime(subID,allData.expt_block(subID,:)==runID);
        resp_stim(isnan(resp_stim)) = 1.5; % set duration for missed trials to length of stimulus interval
        % names{1}     = 'stim_onset';
        % onsets{1}    =  t_stim;
        % durations{1} =  0;

        %% button left
        t_resp = t_stim + allData.resp_reactiontime(subID,allData.expt_block(subID,:)==runID);
        names{1}     = 'leftButton';
        onsets{1}    =  t_resp(allData.resp_screen(subID,allData.expt_block(subID,:)==runID) == 1);
        durations{1} =  0;

        %% button right
        names{2}     = 'rightButton';
        onsets{2}    =  t_resp(allData.resp_screen(subID,allData.expt_block(subID,:)==runID) == 2);
        durations{2} =  0;


        save([params.dir.conditionDir 'conditions_' params.glmName '_sub' num2str(subID) '_run' num2str(runID)],'names','onsets','durations');

    end
  end



end
