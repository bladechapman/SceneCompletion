function [ best_patch ] = placeContext( source_image, replacement_image, context_mask )
%PLACECONTEXT Summary of this function goes here
%   Detailed explanation goes here

% assume source and replacement images are same dimensions

rgb_mask = repmat(context_mask, [1,1,3]);
bounded_mask = getBoundedMask(context_mask);
[mask_height, mask_width, ~] = size(bounded_mask);
template = getBoundedMask(source_image .* rgb_mask);

replacement_image_lab = rgb2lab(replacement_image(:,:,1), replacement_image(:,:,2), replacement_image(:,:,3));
template_lab = rgb2lab(template(:,:,1), template(:,:,2), template(:,:,3));

disp('beginning computation');
tic
ssd_L = imfilter(replacement_image_lab(:,:,1).^2, bounded_mask)...
    - 2*imfilter(replacement_image_lab(:, :, 1), template_lab(:, :, 1))...
    + sum(sum((template_lab(:, :, 1)).^2));

ssd_a = imfilter(replacement_image_lab(:,:,2).^2, bounded_mask)...
    - 2*imfilter(replacement_image_lab(:, :, 2), template_lab(:, :, 2))...
    + sum(sum((template_lab(:, :, 2)).^2));

ssd_b = imfilter(replacement_image_lab(:,:,3).^2, bounded_mask)...
    - 2*imfilter(replacement_image_lab(:, :, 3), template_lab(:, :, 3))...
    + sum(sum((template_lab(:, :, 3)).^2));

ssd = ssd_L + ssd_a + ssd_b;
ssd_vis = 1 - ssd.^(1/2);
disp('end computation');
disp(toc)

% find starting pixel with smallest ssd
[~, I] = max(ssd_vis(:));
[best_y, best_x] = ind2sub(size(ssd_vis), I);
best_patch = replacement_image(best_y-floor(mask_height/2):best_y + floor(mask_height/2),...
    best_x-floor(mask_width/2):best_x + floor(mask_width/2), :);
end

