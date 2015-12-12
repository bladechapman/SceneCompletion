function [ best_patch ] = placeContext( source_image, replacement_image, context_mask )
%PLACECONTEXT Summary of this function goes here
%   Detailed explanation goes here

% assume source and replacement images are same dimensions
ssd = zeros(size(replacement_image));
ssd(:,:,:) = intmax;
[height, width, c] = size(replacement_image);
[mask_height, mask_width, m_c] = size(context_mask);

% slide this mask across the entire image and compute SSD at each pixel
for y = 1:height-mask_height+1
    for x = 1:width-mask_width+1
        disp([y x]);
        source_image_rect = source_image(y:y+mask_height-1, x:x+mask_width-1, :);
        replacement_image_rect = replacement_image(y:y+mask_height-1, x:x+mask_width-1, :);
        source_image_region = source_image_rect(:,:,:) .* repmat(context_mask, [1,1,3]);
        replacement_image_region = replacement_image_rect(:,:,:) .* repmat(context_mask, [1,1,3]);
        
        ssd(y, x) = sum(sum(sum((replacement_image_region - source_image_region).^2)));
        
    end
end

% ssd(1:height-mask_height+1, 1:width-mask_width+1) = sum(sum(sum((...
%     replacement_image(...
%         (1:height-mask_height):(1:height-mask_height+1)+mask_height-1,...
%         (1:width-mask_width):(1:width-mask_width+1)+mask_width-1,...
%         :).* repmat(context_mask, [1,1,3]) - ...
%     source_image(...
%         (1:height-mask_height):(1:height-mask_height+1)+mask_height-1,...
%         (1:width-mask_width):(1:width-mask_width+1)+mask_width-1,...
%         :).* repmat(context_mask, [1,1,3])).^2)));

% find starting pixel with smallest ssd
[M, I] = min(ssd(:));
[best_y, best_x] = ind2sub(size(ssd), I);
best_patch = replacement_image(best_y:best_y + mask_height, best_x + mask_width);
end

