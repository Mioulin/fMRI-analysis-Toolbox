function xy = fmri_rsa_mds_rdmToND(rdm,dims,criterion)
%% fmri_rsa_mds_rdmToND(rdm)
%
% projects RDM into n-dimensional space
% preprocesses RDM to ensure that it's symmetric, real and
% has a main diagonal of zero
%
% Timo Flesch, 2019,
% Human Information Processing Lab,
% Experimental Psychology Department
% University of Oxford

  if ~exist('dims')
    dims = 2;
  end
  if ~exist('criterion')
    criterion = 'sstress'; %non-metric mds
  end

  %% preprocessing
  % rescaling
  rdm = scale01(rankTransform_equalsStayEqual(rdm));
  % symmetry
  rdm = squareform(vectorizeRDM(rdm));
  % diag(rdm) = 0
  rdm(1:length(rdm)+1:end) = 0;

  %% perform mds
  xy = mdscale(rdm,dims,'Criterion',criterion);

end
