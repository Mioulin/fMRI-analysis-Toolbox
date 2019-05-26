function stats = fmri_rsa_corrs_sigtest_ROI(maskName)
  %% fmri_rsa_corrs_sigtest()
  %
  % performs statistical inference on
  % correlation coefficients within ROIs
  %
  % Timo Flesch, 2018,
  % Human Information Processing Lab,
  % Experimental Psychology Department
  % University of Oxford

  params = fmri_rsa_corrs_setParams();
  % load correlations
  load(['groupAvg_' params.names.corrsOut 'orth_' num2str(params.corrs.doOrth) '_set_' params.names.modelset '_' maskName]);

  for modID = 1:length(results.params.modellist)
      switch params.statinf.method
      case 'signrank'
        [p,~,s] = signrank(results.corrs(:,modID),0,'method','approximate','tail',params.statinf.tail);
        stats.p(modID) = p;
        stats.z(modID) = s.zval;
      case 'ttest'
        if params.statinf.doFisher
          results.corrs(:,modID) = atanh(results.corrs(:,modID));
        end
        [~,p,~,s] = ttest(results.corrs(:,modID),0,'tail',params.statinf.tail);
        stats.p(modID) = p;
        stats.t(modID) = s.tstat;
      end
  end
  stats.params = params.statinf;
  save(['groupAvg_STATS_' params.names.corrsOut 'orth_' num2str(params.corrs.doOrth) '_set_' params.names.modelset '_' maskName],'stats');

end
