addpath poissonBlend/
addpath localContext/
addpath gistDescriptors/
addpath graphCut/
addpath getMask/

source_im = im2double(imread('./crosslake.jpg'));
N=10;

%% compute mask
mask_include = getMask(source_im);
% mask_exclude = imcomplement(mask_include);
context_mask = getContextMask(mask_include);
region_mask = context_mask + mask_include;

%% generate gist descriptors for all images

% if gists do not exist:
% computegists;
% else
%   read in gists

%% ssd all gist descriptors with gist of source image
 % to get top X best matches
 
[top_indices, gist_ssds] = comparegists(source_im, N);

%% compute mask, computer score for each top X images
 

% region_mask_exclude = imcomplement(region_mask);
[rows, cols, colors] = size(source_im);

ssd_scores = zeros(N,1);
texture_scores = zeros(N,1);
all_patches = zeros(N, rows, cols, colors);

for i=1:10
    tic
    % read in image at current index
    test_im_2 = im2double(imread(sprintf('./gistDescriptors/1000beaches_renamed/im%05d.jpg',top_indices(i))));
    [best_patch, ssd_score, texture_score] = ...
        placeContext(source_im, test_im_2, context_mask, region_mask);
    % append
    ssd_scores(i) = ssd_score;
    texture_scores(i) = texture_score;
    all_patches(i, :,:,:) = best_patch;
    toc
end


% compile all gist ssd, image ssd, and texture scores in arrays

% scale each equally - normalize
ssd_scores_norm     = normalize(ssd_scores);
gist_ssds_norm      = normalize(gist_ssds);
texture_scores_norm = normalize(texture_scores);
% compute scores sum
scores = ssd_scores_norm + gist_ssds_norm + texture_scores_norm;
% find best score

%% computer best patch

[best_score, best_ind] = min(scores);
best_patch = all_patches(best_ind, :, :, :);
best_patch = reshape(best_patch,[350,500,3]);

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



