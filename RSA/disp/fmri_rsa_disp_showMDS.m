function fmri_rsa_disp_showMDS(xy,fIDX,images)
  %% fmri_rsa_disp_showMDS(xy,fIDX,images)
  %
  % displays MDS results
  % based on script by Andrej Karpathy (stanford cnn course)
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




  % center the coordinates
  xy = bsxfun(@minus, xy, min(xy));
  xy = bsxfun(@rdivide, xy, max(xy));

  %% MAIN
  S = 600; % size of full embedding image
  G = ones(S, S, 3, 'uint8').*150;
  s = 50; % size of every single image

  Ntake = size(xy,1);
  for i=1:Ntake

      if mod(i, 100)==0
          fprintf('%d/%d...\n', i, Ntake);
      end

      % location
      a = ceil(xy(i, 1) * (S-s)+1);
      b = ceil(xy(i, 2) * (S-s)+1);
      a = a-mod(a-1,s)+1;
      b = b-mod(b-1,s)+1;

      if  G(a,b,1) ~= 150
          continue % spot already filled
      end

      I = squeeze(images(i,:,:,:));
      if size(I,3)==1, I = cat(3,I,I,I); end
      I = imresize(I, [s, s]);

      G(a:a+s-1, b:b+s-1, :) = I;

  end

  figure(fIDX);
  imshow(G);
end
