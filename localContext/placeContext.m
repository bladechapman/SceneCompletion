function [ best_patch, ssd_score, texture_score ] = placeContext( source_image, replacement_image, context_mask, region_mask )
%PLACECONTEXT Summary of this function goes here
%   Detailed explanation goes here


% figure(1), imshow(source_image);
% figure(2), imshow(replacement_image);
% figure(3), imshow(context_mask);
% pause;

ssd = zeros(size(replacement_image));
ssd(:,:,:) = intmax;


rgb_mask = repmat(context_mask, [1,1,3]);
[bounded_mask, bounded_min_x, bounded_min_y] = getBoundedMask(context_mask);
[mask_height, mask_width, ~] = size(bounded_mask);
[template, ~, ~] = getBoundedMask(source_image .* rgb_mask);

replacement_image_lab = rgb2lab(replacement_image(:,:,1), replacement_image(:,:,2), replacement_image(:,:,3));
template_lab = rgb2lab(template(:,:,1), template(:,:,2), template(:,:,3));


% figure(1), imagesc(replacement_image_lab(:,:,1));
% figure(3), imagesc(template_lab(:,:,1));

% ssd = imfilter(I.^2, M) -2*imfilter(I, M.*T) + sum(sum((M.*T).^2))
disp('beginning computation');
tic
ssd_L = imfilter(replacement_image_lab(:,:,1).^2, bounded_mask)...
    - 2*imfilter(replacement_image_lab(:, :, 1), bounded_mask.*...
    template_lab(:, :, 1)) + sum(sum((bounded_mask.*template_lab(:, :, 1)).^2));

ssd_a = imfilter(replacement_image_lab(:,:,2).^2, bounded_mask)...
    - 2*imfilter(replacement_image_lab(:, :, 2), bounded_mask.*...
    template_lab(:, :, 2)) + sum(sum((bounded_mask.*template_lab(:, :, 2)).^2));

ssd_b = imfilter(replacement_image_lab(:,:,3).^2, bounded_mask)...
    - 2*imfilter(replacement_image_lab(:, :, 3), bounded_mask.*...
    template_lab(:, :, 3)) + sum(sum((bounded_mask.*template_lab(:, :, 3)).^2));

ssd = ssd_L + ssd_a + ssd_b;
ssd_vis = 1 - ssd.^(1/2);
disp('end computation');
disp(toc)
% figure(10), imshow(mat2gray(ssd_vis));

% find starting pixel with smallest ssd
half_mask_height = ceil(mask_height / 2.0);
half_mask_width = ceil(mask_width / 2.0);
[height, width] = size(ssd_vis);
iterable_area = ssd_vis(...
                    1+half_mask_height:height - (mask_height - half_mask_height)+1,...
                    1+half_mask_width:width - (mask_width - half_mask_width)+1);
[ssd_score, I] = max(iterable_area(:));
[best_y, best_x] = ind2sub(size(iterable_area), I);
best_y = best_y + half_mask_height;
best_x = best_x + half_mask_width;

[bounded_region_mask, ~, ~] = getBoundedMask(region_mask);

small_best_patch = replacement_image(...
    best_y-half_mask_height:best_y + (mask_height - half_mask_height) - 1,...
    best_x-half_mask_width:best_x + (mask_width - half_mask_width) - 1, :);
[patch_height, patch_width, ~] = size(small_best_patch);
best_patch = zeros(size(source_image));
best_patch(bounded_min_y:bounded_min_y+patch_height-1, bounded_min_x:bounded_min_x+patch_width-1, :) = ...
    small_best_patch .* repmat(bounded_region_mask, [1 1 3]);

% compute texture score
orig_patch_region = source_image .* repmat(region_mask, [1 1 3]);
[orig_patch_region, ~, ~] = getBoundedMask(orig_patch_region);
best_patch_region = small_best_patch .* repmat(bounded_region_mask, [1 1 3]);
texture_score = textureSimilarity(orig_patch_region, best_patch_region);

% figure(4), imshow(best_patch);
end

