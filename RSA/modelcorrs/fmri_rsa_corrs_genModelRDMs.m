function modelRDMs = fmri_rsa_corrs_genModelRDMs()
  %% generates model RDMs for all subjects
  %
  % models:
  % - pixel space (using the images seen by subjects)
  % - dissimilarity ratings (as provided by subjects)
  % - contexts x dimension 1D (e.g. choices: branchy5 in ctxA == leafy5 in ctxB)
  % - contexts x dimension 2D (e.g. orthogonal vectors in 2d Euclidean space)
  % - categorical contexts x leafiness x branchiness 1D
  % - categorical contexts x leafiness x branchiness 2D
  % - categorical linear model (diagonal boundary) 1D
  % - categorical linear model (diagonal boundary) 2D
  % - context (north vs south): main effect of context
  %
  % returns a subject x model matrix as well as a cell struct with model labels
  % Timo Flesch, 2019

  % notes:
  % - ctx1: north, ctx2: south.
  % leafiness: ctx1
  % branchinessL ctx2

  %% set params and data structures
  params = fmri_rsa_corrs_setParams();
  modelRDMs = struct();

  %% import data
  % load behavioural data
  rsData = load([params.dir.behavDir 'rsData_day_2_scan_granada.mat']);
  fns = fieldnames(rsData);
  rsData = rsData.(fns{1});

  % load dissimilarity ratings
  dissimData = load([params.dir.dissimDir 'dissimData_exp1_granada_final.mat']);
  fns = fieldnames(dissimData);
  dissimData = dissimData.(fns{1});

  % load choie matrices
  cMats = load([params.dir.behavDir 'choicematsAndRTs_day_2_scan_granada.mat']);
  fns = fieldnames(cMats);
  cMats = cMats.(fns{1}).choicemat.orig;

  %% generate models
  rdmSet = [];
  for subID = 1:params.num.subjects
    % - pixel space (using the images seen by subjects, averaged over exemplar RDMs)
    % obtain image labels, sort them
    for runID = 1:params.num.runs
      % extract trees for both contexts
      treesNorth = sort(rsData(subID).treeIDs(rsData(subID).data(:,1)==runID & rsData(subID).data(:,3)==1));
      treesSouth = sort(rsData(subID).treeIDs(rsData(subID).data(:,1)==runID & rsData(subID).data(:,3)==2));

      % group into 1x25,1x25 (for each context)
      % iterate through exemplar sets (should be two)
      for exmplID = 1:2
        treeSet(exmplID,:) = [treesNorth(exmplID:2:length(treesNorth)), treesSouth(exmplID:2:length(treesSouth))];
      end

      % load images and add background as well as contextual frame (same colour as during exp)
      % and reconstruct composite images (context + tree)
      northBG = imread([params.dir.bgDir 'north_garden.png']);
      southBG = imread([params.dir.bgDir 'south_garden.png']);
      northBG(northBG==178) = 150;
      southBG(southBG==178) = 150;
      for exmplID = 1:2
        respMat = [];
        % north garden
        for treeID = 1:50
          % load appropriate context
          if treeID <= 25
            img = northBG;
          else
            img = southBG;
          end
          % load tree
          tree = imread([params.dir.imageDir treeSet{exmplID,treeID} '.png']);
          tree(tree==0) = 150;
          % resize tree
          tree = imresize(tree,.3);
          % paste tree
          img(ceil(size(img,1)/2-size(tree,1)/2):floor(size(img,1)/2+size(tree,1)/2),ceil(size(img,2)/2-size(tree,2)/2):floor(size(img,2)/2+size(tree,2)/2),:) = tree;
          % vectorize tree and put in resp mat
          respMat(treeID,:) = img(:);
        end
        % for later RDM visualisation, save set of tree ctx composite images
        if (subID==1 & runID==1 & exmplID==1)
          treeMat = reshape(respMat,[50,242,250,3]);
          treeMat = cast(treeMat,'uint8');
          save('treeThumbnails.mat','treeMat');
        end
        respMat = cast(respMat,'uint8');
        rdmSet(subID,runID,exmplID,:,:) = squareform(pdist(respMat));
      end
    end
  end
  save('pixelRDMs_all.mat','rdmSet');
  rdms = squeeze(mean(mean(rdmSet,3),2));
  modelRDMs(1).rdms = rdms;
  modelRDMs(1).name = 'pixel values';

  % - dissimilarity ratings (irrespective of context, obviously)
  rdmSet = [];
  for subID = 1:params.num.subjects
    for trialID = 1:max(dissimData(1).data(:,1))
      coords = dissimData(subID).data(dissimData(subID).data(:,1)==trialID,6:7);
      % expand for two contexts:
      coords = [coords;coords];
      dists = pdist(coords);
      dists = dists./max(dists);
      rdm   = squareform(dists);
      rdmSet(subID,trialID,:,:) = rdm;
    end
  end
  rdms = squeeze(mean(rdmSet,2));
  modelRDMs(2).rdms = rdms;
  modelRDMs(2).name = 'dissimilarity ratings';

  % - factorised model - contexts x feature - 2D
  [b,l] = meshgrid([-2:2],[-2:2]);
  b = b(:);
  l = l(:);
  % respVect = [b,zeros(length(b),1);zeros(length(l),1),l];
  c1 = [cos(deg2rad(0));sin(deg2rad(0))];
  c2 = [cos(deg2rad(90));sin(deg2rad(90))];
  respVect = [[l,b]*c1*c1';[l,b]*c2*c2']; %l=north,b=south
  rdm = squareform(pdist(respVect));
  for subID = 1:params.num.subjects
    rdms(subID,:,:) = rdm;
  end
  modelRDMs(3).rdms = rdms;
  modelRDMs(3).name = 'ctx x continuous feature (2D to 1D)';

  % - linear model - 2D
  for subID=1:params.num.subjects
    boundID = rsData(subID).code(end);
    switch boundID
      case 1
        phi = 45;
      case 2
        phi = 225;
      case 3
        phi = 315;
      case 4
        phi = 135;
    end
    c = [cos(deg2rad(phi));sin(deg2rad(phi))];
    respVect = [[l,b]*c*c';[l,b]*c*c'];
    rdms(subID,:,:) = squareform(pdist(respVect));
  end
  modelRDMs(4).rdms = rdms;
  modelRDMs(4).name = 'linear model (2D to 1D)';

  % - factorised model - CHOICE -  contexts x feature
  for subID = 1:params.num.subjects
    boundID = rsData(subID).code(end);
    switch boundID
      case 1
        bv = [0 0 .5 1 1]-.5;
        lv = [0 0 .5 1 1]-.5;
      case 2
        bv = fliplr([0 0 .5 1 1]-.5);
        lv = fliplr([0 0 .5 1 1]-.5);
      case 3
        bv = [0 0 .5 1 1]-.5;
        lv = fliplr([0 0 .5 1 1]-.5);
      case 4
        bv = fliplr([0 0 .5 1 1]-.5);
        lv = [0 0 .5 1 1]-.5;
    end
    [b,l] = meshgrid(bv,lv);
    b = b(:);
    l = l(:);
    respVect = [l;b];
    rdm = squareform(pdist(respVect));
    rdms(subID,:,:) = rdm;
  end
  modelRDMs(5).rdms = rdms;
  modelRDMs(5).name = 'ctx x categorical feature (choice)';

  % - linear model - CHOICE - 1D
  bv = [0 0 .5 1 1]-.5;
  lv = [0 0 .5 1 1]-.5;
  [b,l] = meshgrid(bv,lv);
  b = b(:);
  l = l(:);
  for subID=1:params.num.subjects
    boundID = rsData(subID).code(end);
    switch boundID
      case 1
        phi = 45;
      case 2
        phi = 225;
      case 3
        phi = 315;
      case 4
        phi = 135;
    end
    c = [cos(deg2rad(phi));sin(deg2rad(phi))];
    respVect = [[l,b]*c;[l,b]*c];
    rdms(subID,:,:) = squareform(pdist(respVect));
  end
  modelRDMs(6).rdms = rdms;
  modelRDMs(6).name = 'linear model (choice)';

  % simple context encoding (A vs B)
  ctxNorth = zeros(25,1);
  ctxSouth = ones(25,1);
  respVect = [ctxNorth;ctxSouth];
  rdm = squareform(pdist(respVect));
  for subID=1:params.num.subjects
    rdms(subID,:,:) = rdm; % same division for all
  end
  modelRDMs(7).rdms = rdms;
  modelRDMs(7).name = 'context encoding model';

  % participant's choices
  for subID = 1:params.num.subjects
    rn = squeeze(cMats.north(subID,:,:));
    rs = squeeze(cMats.south(subID,:,:));
    respVect = [rn(:);rs(:)];
    rdms(subID,:,:) = squareform(pdist(respVect));
  end
  modelRDMs(8).rdms = rdms;
  modelRDMs(8).name = 'empirical choice patterns';

end
