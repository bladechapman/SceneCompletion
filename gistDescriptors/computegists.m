function computegists
% given a large set of images, generates gist descriptors for each image in
% the set, saving that file to disk so that the computation only needs to
% be done once. cool? cool.
addpath images/

%file extension stuff so we can just chuck the images id into it
image_name_prefix =    './images/im';
image_name_extension = '.jpg';

%range of the image ids that you wanna work with
start = 7000;
finish = 13999;

%%%%%%% computation follows below %%%%%%%%

% GIST Parameters:
clear param
param.orientationsPerScale = [8 8 8 8]; % number of orientations per scale (from HF to LF)
param.numberBlocks = 4;
param.fc_prefilt = 4;

% Pre-allocate gist:
Nfeatures = sum(param.orientationsPerScale)*param.numberBlocks^2;
gist = zeros([(finish-start+1) Nfeatures]); 

% Load first image and compute gist:
img = imread(sprintf('%s%05d%s', image_name_prefix, start, image_name_extension));
[gist(1, :), param] = LMgist(img, '', param); % first call
% Loop:
tic
for i = (start+1):finish
   img = imread(sprintf('%s%05d%s', image_name_prefix, i, image_name_extension));
   gist(i - start + 1, :) = LMgist(img, '', param); % the next calls will be faster
   if mod(i,250)==0
       disp(i);
       save('gistvalues', 'gist');
       toc
       tic
   end
end
toc

save('gistvalues', 'gist');

end