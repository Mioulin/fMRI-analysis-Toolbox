function fmri_rsa_disp_rdmReplicabilityBehav(scores)
%% fmri_rsa_disp_rdmReplicability(scores)
%
% calculates leave one subject out rdm correlations (spearman)
%
% Timo Flesch, 2019

  if ~exist('scores','var')
    scores = fmri_rsa_helper_rdmReplicabilityBehav();
  end

  sem = @(X,dim) std(X,0,dim)./sqrt(size(X,dim));
  e = sem(scores.corrs,2);
  m  = mean(scores.corrs,2);
  barwitherr(e,m)
  set(gca,'XTickLabel',scores.labels)
  % legend(scores.labels,'Location','NorthEastOutside');
  ylabel('spearman''s \rho');
  title('Leave One Subject Out RDM Correlation');
  set(gcf,'Color','w');
  box off;
  set(gcf,'Position',[293,   252,  1010,   438]);

end
