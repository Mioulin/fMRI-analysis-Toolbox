function xy = fmri_rsa_tsne_rdmTo2D(rdm,perplexity)
  %% xy = fmri_rsa_tsne_rdmTo2D(rdm,perplexity)
  %
  % wrapper function that performs t-SNE on rdm
  %
  % Timo Flesch, 2019,
  % Human Information Processing Lab,
  % Experimental Psychology Department
  % University of Oxford

  if ~exist('perplexity')
    perplexity = 20;
  end

  xy = tsne(rdm,'Algorithm','exact','Standardize',true,'Perplexity',perplexity);
end
