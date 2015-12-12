function [ min_x, max_x, min_y, max_y ] = determineMaskBounds( source_mask )
%DETERMINE_MASK_BOUNDS Summary of this function goes here
%   Detailed explanation goes here
    % 1: Determine the bounds of the mask
    [mask_height, mask_width] = size(source_mask);    
    init_vals = {0, 0, intmax('int32'), intmax('int32')};
    [max_x, max_y, min_x, min_y] = init_vals{:};
    for y = 1:mask_height
        for x = 1:mask_width
            pixel_value = source_mask(y, x);
            if pixel_value > 0.0001
               if x < min_x
                   min_x = x;
               end
               
               if x > max_x
                   max_x = x;
               end
               
               if y < min_y
                    min_y = y;
                end

                if y > max_y
                    max_y = y;
                end
            end
        end
    end
end

