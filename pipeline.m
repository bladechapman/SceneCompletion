addpath poissonBlend/
addpath localContext/
addpath gistDescriptors/
addpath getMask/

source_im = im2double(imread('./test_images/test_5.jpg'));

%% generate gist descriptors for all images

% if gists do not exist:
% computegists;
% else
%   read in gists

%% ssd all gist descriptors with gist of source image
 % to get top X best matches
 
%  [top_indices, gist_ssds] = comparegists(source_im);

%% compute mask, computer score for each top X images
 
mask_include = getMask(source_im);
% mask_exclude = imcomplement(mask_include);
context_mask = getContextMask(mask_include);
region_mask = context_mask + mask_include;
% region_mask_exclude = imcomplement(region_mask);

% ssd_scores = [];
% texture_scores = [];

% for...
% read in image at current index
test_im_2 = im2double(imread('./test_images/test_6.jpg'));
[best_patch, ssd_score, texture_score] = ...
    placeContext(source_im, test_im_2, context_mask, region_mask);

% append
% ssd_scores = [ssd_scores ssd_score];
% texture_scores = [texture_scores texture_score];
% end for


% compile all gist ssd, image ssd, and texture scores in arrays

% scale each equally
% compute scores
% find best score

%% computer best patch

% [best_score, best_ind] = max(scores);

%% graph cut

% compute cut
cut = retrieveCut(source_im, best_patch, context_mask, mask_include);

%% poisson blend

final_im = poissonBlend(best_patch, cut, source_im);
imshow(final_im);
% final_im = poissonBlend(cut_im, mask, source_im);

%% output image

% imshow(final_im);

%% ???
%% profit



