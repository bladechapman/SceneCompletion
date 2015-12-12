function [ output_args ] = poissonBlend( source, source_mask, background )
%POISSONBLEND Summary of this function goes here
%   Detailed explanation goes here
    
    %% apply blur to mask
    blurred_mask = source_mask;  % gaussian_filter(source_mask, 2);
    [min_x, max_x, min_y, max_y] = determineMaskBounds(blurred_mask);
    
    %% solve for constraints
    blended_region_r = solveConstraintsForChannel( source, blurred_mask, background, 1 );
    blended_region_g = solveConstraintsForChannel( source, blurred_mask, background, 2 );
    blended_region_b = solveConstraintsForChannel( source, blurred_mask, background, 3 );
    
    
    %% copy the solved values into the target image
    output_args = background;
    for y = min_y:max_y
        for x = min_x:max_x
            adjusted_y = y - min_y + 1;
            adjusted_x = x - min_x + 1;
            mask_val = blurred_mask(y, x);
            
            output_args(y, x, 1) = blended_region_r(adjusted_y, adjusted_x) * mask_val + background(y, x, 1) * (1 - mask_val);
            output_args(y, x, 2) = blended_region_g(adjusted_y, adjusted_x) * mask_val + background(y, x, 2) * (1 - mask_val);
            output_args(y, x, 3) = blended_region_b(adjusted_y, adjusted_x) * mask_val + background(y, x, 3) * (1 - mask_val);
        end
    end
end