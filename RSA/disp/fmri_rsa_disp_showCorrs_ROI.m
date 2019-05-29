function fmri_rsa_disp_showCorrs_ROI(corrs,stats,colBar,colDots,labels,noiseCeiling,fIDX)
%% fmri_rsa_disp_showCorrs_ROI(corrs,stats,colBar,colDots,labels,noiseCeiling,fIDX)
%
% displays model correlations within ROI
%
% Timo Flesch, 2018,
% Human Information Processing Lab,
% Experimental Psychology Department
% University of Oxford
params = fmri_rsa_corrs_setParams();

if ~exist('fIDX','var')
    fIDX = 1000;
end

sem = @(X,dim) std(X,0,dim)./sqrt(size(X,dim));

figure(fIDX);

colvals = linspace(0.4,0.6,size(corrs,2));

if params.statinf.doFisher
 corrs = atanh(corrs);
 noiseCeiling.ub = atanh(noiseCeiling.ub);
 noiseCeiling.lb = atanh(noiseCeiling.lb);
end

figure(fIDX);set(gcf,'Color','w');
lims = [0,size(corrs,2)+1];
g = fill([lims(1),lims(2),lims(2),lims(1),lims(1)]',[noiseCeiling.lb,noiseCeiling.lb,noiseCeiling.ub,noiseCeiling.ub,noiseCeiling.lb]',[.9 .9 .9],'EdgeColor',[1,1,1]);
hold on;
for ii = 1:size(corrs,2)
  b = bar(ii,mean(squeeze(corrs(:,ii))));
  b.FaceColor = [1,1,1].*colvals(ii);
  hold on;
  plotSpread_hack(squeeze(corrs(:,ii)),'distributionMarkers','o','xValues',ii)
  eb = errorbar(ii,mean(squeeze(corrs(:,ii))),sem(squeeze(corrs(:,ii)),1),'LineWidth',2.5);
  eb.Color = [0,0,0];
  % sigstar_single(ii,max(mean(corrs,1))*1.2,stats(ii));
  sigstar_single(ii,noiseCeiling.ub*0.8,stats(ii));
end
set(gca,'XTick',1:size(corrs,2));
set(gca,'XTickLabel',labels);
set(gca,'XTickLabelRotation',30);
ylabel('fisher-transformed spearman''s \rho');
box  off;
set(gca,'YGrid','on');

set(gcf,'Color','w');


end
