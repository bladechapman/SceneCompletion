function [ mask ] = getContextMask( mask_include )
%GETCONTEXTMASK Summary of this function goes here
%   Detailed explanation goes here

    %% build the 80px border around the mask
    [rows, cols] = size(mask_include);

    %% Get a random sampling of points
    [rs, cs] = find(mask_include==1);
    tmp_dims = size(rs);
    num_pts = tmp_dims(1);
    NUM_SAMPLES = 3000;
    indices = datasample(1:num_pts, NUM_SAMPLES, 'Replace', false);

    rs_a = rs(indices);
    cs_a = cs(indices);

    mask = zeros(rows, cols);
    for ind = 1:NUM_SAMPLES
        disp(sprintf('Computing border mask: %4d/%4d', ind, NUM_SAMPLES));
        [x, y] = meshgrid(1:rows,1:cols);

        x = x - cs_a(ind);
        y = y - rs_a(ind);


        cur_mask = (x.^2+y.^2 < 80^2);

        mask = or(mask, cur_mask);
    end
    mask = mask - mask_include;
end

