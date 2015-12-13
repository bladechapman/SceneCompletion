addpath getMask/
addpath localContext/

%% test mask generation
test_im = im2double(imread('./test_images/test_5.jpg'));
test_im_2 = im2double(imread('./test_images/test_6.jpg'));
mask_include = getMask(test_im);
mask_exclude = imcomplement(mask_include);

%% test determine best patch placements test
context_mask = getContextMask(mask_include);
<<<<<<< HEAD
region_mask = context_mask + mask_include;
region_mask_exclude = imcomplement(region_mask);
[patch, ssd_score, texture_score] = placeContext(test_im, test_im_2, context_mask, region_mask);

figure(69), imshow(test_im .* repmat(region_mask_exclude, [1 1 3]) + ...
                    test_im_2 .* repmat(region_mask, [1 1 3]))

% figure(2), imagesc(patch);
=======
patch = placeContext(test_im, test_im_2, context_mask);
figure(2), imagesc(patch);
>>>>>>> aee30b42941c2907a71def4948f65b6e85e424f7
