function [ texture_similarity_score ] = textureSimilarity( best_patch_region, orig_image_region )
%TEXTURESIMILARITY Summary of this function goes here
%   Detailed explanation goes here
    
[best_grad_mag, ~] = imgradient(rgb2gray(best_patch_region));
[orig_grad_mag, ~] = imgradient(rgb2gray(orig_image_region));

best_median = medfilt2(best_grad_mag, [5 5]);
orig_median = medfilt2(orig_grad_mag, [5 5]);

texture_similarity_score = sum(sum((best_median - orig_median).^2));

end

