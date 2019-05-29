function fmri_rsa_disp_rdmReplicability(scores)
%% fmri_rsa_disp_rdmReplicability(scores)
%
% displays rdm replicability results (brain)
%
% Timo Flesch, 2019,
% Human Information Processing Lab,
% Experimental Psychology Department
% University of Oxford

  if ~exist('scores','var')
    scores = fmri_rsa_helper_rdmReplicability();
  end

  sem = @(X,dim) std(X,0,dim)./sqrt(size(X,dim));
  e = sem(scores.corrs,3);
  m  = mean(scores.corrs,3);
  barwitherr(e,m)
  set(gca,'XTickLabel',scores.rois)
  legend(scores.metrics,'Location','NorthEastOutside');
  ylabel('spearman''s \rho');
  title('Leave One Subject Out RDM Correlation');
  set(gcf,'Color','w');
  box off;
  set(gcf,'Position',[293,   252,  1010,   438]);

end
