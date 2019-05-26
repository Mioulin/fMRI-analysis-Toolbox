function fmri_rsa_disp_showCorrs_MultipleROIs(fIDX,roiList,distMetric,doOrth)
%% fmri_rsa_disp_rdmReplicability(scores)
%
% calculates leave one subject out rdm correlations (spearman)
%
% Timo Flesch, 2019
params = fmri_rsa_corrs_setParams();

if ~exist('fIDX','var')
  fIDX = 1000;
end

if ~exist('roiList','var')
  roiList = {'r_mask_wfu_BA17', ...
  'r_mask_wfu_BA18','r_mask_wfu_BA19', ...
  'r_mask_wfu_IT','r_mask_wfu_ACC'};
end

if ~exist('distMetric','var')
  distMetric = 'MahalDist_roi';
end

if ~exist('doOrth','var')
  doOrth = 0;
end

% obtain model labels
load('fmri_rsa_modelRDMs.mat');
modLabels = {modelRDMs(params.corrs.modellist).name};

modCols = linspace(0.2,0.8,length(modLabels))';

% load data (correlations, noise ceilings)
allCorrs = [];
allUBs   = [];
allLBs   = [];


for ii = 1:length(roiList)
  % load corrs
  load(['groupAvg_modelCorrs_' distMetric '_orth_' num2str(doOrth) '_set_1_' roiList{ii}]);
  allCorrs(:,:,ii) = results.corrs;
  % load noise ceiling
  load(['noiseCeiling_modelCorrs_' distMetric  '_' roiList{ii}]);
  allUBs(:,ii) = noiseCeiling.ub;
  allLBs(:,ii) = noiseCeiling.lb;
end

if params.statinf.doFisher
  allCorrs = atanh(allCorrs);
  allUBs   = atanh(allUBs);
  allLBs   = atanh(allLBs);
end

sem = @(X,dim) std(X,0,dim)./sqrt(size(X,dim));
e = squeeze(sem(allCorrs,1))';
m  = squeeze(mean(allCorrs,1))';

figure(fIDX);set(gcf,'Color','w');
b = barwitherr(e,m);
hold on;
for ii = 1:length(b)
  % change colour
  b(ii).FaceColor = [1,1,1].*modCols(ii);
end

for ii = 1:length(roiList)
  % add noise ceiling
  bw = b(1).BarWidth/2;
  % g = fill([ii-bw,ii+bw,ii+bw,ii-bw,ii-bw]',[allLBs(ii),allLBs(ii),allUBs(ii),allUBs(ii),allLBs(ii)]',[.9 .9 .9],'EdgeColor',[1,1,1]);
  plot([ii-bw,ii+bw],[allLBs(ii),allLBs(ii)],'LineStyle','--','Color',[.55 .55 .55]);
  plot([ii-bw,ii+bw],[allUBs(ii),allUBs(ii)],'LineStyle','--','Color',[.55 .55 .55]);
end
distMetric = strrep(distMetric,'_roi','');
roiList = strrep(roiList,'r_mask_wfu_','');

set(gca,'XTickLabel',roiList);
set(gca,'XTickLabelRotation',45);
legend(modLabels,'Location','NorthEastOutside');
ylabel('spearman''s \rho');
title({'\bf RDM Model Correlations',['\rm' distMetric ' orth:' num2str(doOrth)]});
box off;
set(gcf,'Position',[293,   252,  1010,   438]);


end
