function [ bounded_mask ] = getBoundedMask( original_mask )
%GETMASKBOUNDINGBOX Summary of this function goes here
%   Detailed explanation goes here
%   Currently only works on inclusive masks
    [original_height, original_width] = size(original_mask);
    min_x = original_width + 1;
    min_y = original_height + 1;
    max_x = 0;
    max_y = 0;
    
    for y=1:original_height
        for x=1:original_width
            original_mask_value = original_mask(y, x);
            
            if (original_mask_value == 1)
                if x > max_x
                    max_x = x;
                end
                
                if y > max_y
                    max_y = y;
                end
                
                if x < min_x
                    min_x = x;
                end
                
                if y < min_y
                    min_y = y;
                end
            end
        end
    end
    
    bounded_mask = original_mask(min_y:max_y, min_x:max_x);
    
end

