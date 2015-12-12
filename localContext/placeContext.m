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

% slide this mask across the entire image and compute SSD at each pixel
% I = source image
% M = mask
% T = template

disp('beginning computation');
tic
ssd = imfilter(source_image.^2, context_mask);
    - 2*(imfilter(source_image, context_mask).*imfilter(replacement_image,context_mask))
    + imfilter(replacement_image.^2, context_mask);
disp('end computation');
disp(toc)
figure(10), imagesc(mat2gray(ssd));
pause;

% disp('begin old comp');
% for y = 1:(height - mask_height + 1)
%     disp(y);
%     for x = 1:(width - mask_width + 1)
%         
%         
%         source_image_rect = source_image(y:y+mask_height-1, x:x+mask_width-1, :);
%         
%         replacement_image_rect = replacement_image(y:y+mask_height-1, x:x+mask_width-1, :);
%         
%         
%         source_image_region = source_image_rect(:,:,:) .* rgb_mask;
%         replacement_image_region = replacement_image_rect(:,:,:) .* rgb_mask;
%         
%         ssd(y, x) = sum(sum(sum((replacement_image_region - source_image_region).^2)));
%     end
% end
% disp('end old comp')
% 
% imshow(mat2gray(ssd));
% pause;

% find starting pixel with smallest ssd
% [M, I] = min(ssd(:));
% [best_y, best_x] = ind2sub(size(ssd), I);
% best_patch = replacement_image(best_y:best_y + mask_height, best_x + mask_width);
best_patch = 0;
end

