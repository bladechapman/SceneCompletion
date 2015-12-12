function [ best_patch ] = placeContext( source_image, replacement_image, context_mask )
%PLACECONTEXT Summary of this function goes here
%   Detailed explanation goes here

% figure(1), imshow(source_image);
% figure(2), imshow(replacement_image);
% figure(3), imshow(context_mask);
% pause;

% assume source and replacement images are same dimensions
ssd = zeros(size(replacement_image));
ssd(:,:,:) = intmax;
[height, width, ~] = size(replacement_image);
[mask_height, mask_width, ~] = size(context_mask);

rgb_mask = repmat(context_mask, [1,1,3]);
bounded_mask = getBoundedMask(context_mask);
bounded_rgb_mask = repmat(bounded_mask, [1,1,3]);
template = getBoundedMask(source_image .* rgb_mask);

figure(1), imshow(replacement_image);
figure(2), imshow(bounded_rgb_mask);
figure(3), imshow(template);
pause

% ssd = imfilter(I.^2, M) -2*imfilter(I, M.*T) + sum(sum((M.*T).^2))
disp('beginning computation');
tic
ssd = imfilter(replacement_image(:, :, 1).^2, bounded_mask)...
    - 2*imfilter(replacement_image(:, :, 1), template(:, :, 1))...
    + sum(sum((template(:, :, 1)).^2));
disp('end computation');
disp(toc)
figure(10), imagesc(mat2gray(ssd));
pause;

% find starting pixel with smallest ssd
% [M, I] = min(ssd(:));
% [best_y, best_x] = ind2sub(size(ssd), I);
% best_patch = replacement_image(best_y:best_y + mask_height, best_x + mask_width);
best_patch = 0;
end

