function [ top_indices, gist_ssds ] = comparegists( input_image, N )
% given an input image, calculate the distance of the gist of the image to 
% each image in our database. once that's done, get and return the indices
% of the N closest pictures

%%%%%%% computation below %%%%%%%

% calculate gist of input image
clear param
param.orientationsPerScale = [8 8 8 8]; % number of orientations per scale (from HF to LF)
param.numberBlocks = 4;
param.fc_prefilt = 4;

input_gist = LMgist(input_image, '', param);

%read in precalculated gists
load('gistvalues.mat');

s = size(gist);
gist_dists = zeros(s(1), 2);

for i = 1:s(1)
    dist = sum((gist(i, :) - input_gist).^2);
    gist_dists(i, :) = [i, dist];
end

sorted_distances = sortrows(gist_dists, 2);

top_indices = sorted_distances(1:N, 1);
gist_ssds = sorted_distances(1:N, 2);

end

