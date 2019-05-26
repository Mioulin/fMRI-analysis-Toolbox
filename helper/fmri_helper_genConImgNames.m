function cNames = fmri_helper_genConImgNames(n)
%% CNAMES = HELPER_GENCONIMGNAMES(N)
%
% generates cell array with file names
%
% Timo Flesch, 2018
cNames = cell(n,1);
for (ii = 1:n)
  cNames{ii} = sprintf('con_%03d',num2str(ii));  
end

end
