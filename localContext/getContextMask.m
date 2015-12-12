function [ mask ] = getContextMask( mask_include )
%GETCONTEXTMASK Summary of this function goes here
%   Detailed explanation goes here
    filter = fspecial('gaussian', 100, 800);
    mask = imfilter(mask_include, filter, 'replicate');
    mask = mask - mask_include;
end

