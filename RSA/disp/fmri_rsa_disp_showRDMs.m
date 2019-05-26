function fmri_rsa_disp_showRDMs(rdmSet,nX,nY,spTitles,fIDX)
  %% fmri_rsa_disp_showRDMs
  %
  % plots several RDMs as subplots
  % useful for quick and dirty comparison
  % of individual subjects or ROIs
  % or distance metrics
  %
  % Timo Flesch, 2019
  % Human Information Processing Lab
  % University of Oxford

  if ~exist('fIDX','var')
    fIDX = 10000;
  end
  if ~exist('spTitles','var')
    spTitles = {};
    for ii = 1:size(rdmSet,1)
      spTitles{ii} = ['rdm ' num2str(ii)];
    end
  end

  set(gcf,'Color','w');

  % todo:
  for ii = 1:size(rdmSet,1)
    figure(fIDX);
    subplot(nX,nY,ii);
    fmri_rsa_disp_showRDM(squeeze(rdmSet(ii,:,:)),fIDX,'all','none');
    title(spTitles{ii});
  end

end
