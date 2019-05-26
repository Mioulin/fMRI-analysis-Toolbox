function fmri_rsa_disp_showRewardMDS(xyIn,fIDX,whichTask)
  %% fmri_rsa_disp_showRewardMDS(xy,fID,whichTask)
  %
  % plots coloured scatter plot in reward reference frame
  %
  % Timo Flesch, 2019
  % University of Oxford
  %

  if size(xyIn,2)==2
    xy = xyIn;
  elseif size(xyIn,2)==1
    xy = [xyIn,zeros(size(xyIn,1),1)];
  end

  if ~exist('fIDX','var')
    fIDX = 1000;
  end
  if ~exist('whichTask')
    whichTask = 'north';
  end
  colVals = [.7,0,0; 1,0,0; 0,0,1; 0,1,0; 0,.7,0];
  setIDs = [1:5:21];

  figure(fIDX);
  set(gcf,'Color','w');

  for ii = 1:5
    setStart = setIDs(ii);
    hb(ii) = scatter(xy(setStart:setStart+4,1),xy(setStart:setStart+4,2),[],colVals(ii,:),'filled');
    hold on;
  end
  legend([hb],{'-50','-25','0','+25','+50'},'Location','NorthEastOutside');
  title([whichTask ' task']);

  if size(xyIn,2)==2
    set(gcf,'Position',[675,699,364,269]);
  elseif size(xyIn,2)==1
    set(gcf,'Position',[675,810,364,158]);
  end



end
