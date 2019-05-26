function xy = fmri_rsa_tsne_rdmTo2D(rdm,perplexity)

  if ~exist('perplexity')
    perplexity = 20;
  end

  xy = tsne(rdm,'Algorithm','exact','Standardize',true,'Perplexity',perplexity);
end
