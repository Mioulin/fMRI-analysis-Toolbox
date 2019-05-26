function wrapper_rsa_makeSingleSubsRDMFigures()
%% wrapper_rsa_makeSingleSubsRDMFigure()
%
% generates subplots of individual RDMs for selected ROI and method

params = fmri_rsa_compute_setParams();

roiMasks = {'r_mask_wfu_BA17', ...
'r_mask_wfu_BA18','r_mask_wfu_BA19'};

distMeasures = {'MahalDist_roi_'};
grpDir = [params.dir.inDir params.dir.subDir.GRP];

% import RDMs
for dmID = 1:length(distMeasures)
  for maskID = 1:length(roiMasks)
    mask = roiMasks{maskID};
    % import subject data
    for subID = 1:params.num.subjects
        subStr = params.names.subjectDir(subID);
        subDir = [params.dir.inDir subStr '/' params.dir.subDir.RDM];
        cd(subDir);
        brainRDMs = load([subDir 'rdmSet_' distMeasures{dmID} mask]);
        rdmSet(subID,:,:) = brainRDMs.subRDM.rdm;
    end

    % generate subplots
    fmri_rsa_disp_showRDMs(rdmSet,4,4)
    set(gcf,'Position',[ 675, 8, 1191, 963]);

    % save subplots
    cd(grpDir);
    saveas(gcf,['groupSubplots_RDM_rdmSet_' distMeasures{dmID} mask '.png']);
    saveas(gcf,['groupSubplots_RDM_rdmSet_' distMeasures{dmID} mask],'svg');
    disp('...done');

    close all;
  end
end



end
