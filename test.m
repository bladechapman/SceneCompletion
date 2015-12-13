addpath getMask/
addpath localContext/
addpath poissonBlend/
addpath graphCut/

%% test mask generation

test_im = im2double(imread('./test_images/test_5.jpg'));
test_im_2 = im2double(imread('./test_images/test_6.jpg'));
mask_include = getMask(test_im);
mask_exclude = imcomplement(mask_include);

%% test determine best patch placements test
context_mask = getContextMask(mask_include);
region_mask = context_mask + mask_include;
region_mask_exclude = imcomplement(region_mask);
[patch, ssd_score, texture_score] = placeContext(test_im, test_im_2, context_mask, region_mask);

figure(69), imshow(test_im .* repmat(region_mask_exclude, [1 1 3]) + ...
                    test_im_2 .* repmat(region_mask, [1 1 3]))

% figure(2), imagesc(patch);
figure(2), imagesc(patch);

test_im = im2double(imread('./test_images/test_1.png'));
test_im2 = im2double(imread('./test_images/test_2.png'));
mask_include = getMask(test_im);
mask_exclude = imcomplement(mask_include);
bounded_inclusive_mask = getBoundedMask(mask_include);

%% test determine best patch placements test
context_mask = getContextMask(mask_include);
% patch = placeContext(test_im, test_im2, context_mask);
% figure(2), imagesc(patch);

%% test retrieve graph cut
cut_mask = retrieveCut(test_im, test_im2, context_mask, mask_include);

figure(1), imshow(test_im);
figure(2), imshow(test_im2);
figure(3), imshow(cut_mask);

%% test poisson blend
% param 1 = foreground
% param 2 = foreground mask
% param 3 = background
% im_blend = poissonBlend(test_im2, mask_include, test_im);
