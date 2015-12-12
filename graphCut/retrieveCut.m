function [ cut_mask ] = retrieveCut(im1, im2, boundary_mask) 
    cost_image = generateCostImage(im1, im2, boundary_mask);
end

function [ cost_image ] = generateCostImage( im1, im2, boundary_mask )
%RETRIEVE_CUT Summary of this function goes here
%   Detailed explanation goes here
    cost_image = imcomplement(boundary_mask) * 5;
    rgb_boundary_mask = repmat(boundary_mask, [1, 1, 3]);
    im1_masked = rgb_boundary_mask .* im1;
    im2_masked = rgb_boundary_mask .* im2;
    
    ssd = sum((im1_masked - im2_masked).^2, 3);
    cost_image = cost_image + ssd;
end

