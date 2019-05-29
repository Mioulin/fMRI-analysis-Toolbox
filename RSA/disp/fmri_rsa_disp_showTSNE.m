function fmri_rsa_disp_showTSNE(xy,fIDX,images)
  %% fmri_rsa_disp_showTSNE(xy,fIDX,images)
  %
  % displays tsne results
  % based on script by Andrej Karpathy (stanford cnn course)
  % actually redundant, just calls the shoMDS script
  %
  % Timo Flesch, 2018,
  % Human Information Processing Lab,
  % Experimental Psychology Department
  % University of Oxford

  if ~exist('images','var')
    images = load('thumbnails.mat');
    images = images.imgMat;
  end
  if ~exist('fIDX','var')
      fIDX = 1000;
  end
  fmri_rsa_disp_showMDS(xy,fIDX,images)
