addpath getMask/
addpath localContext/
addpath poissonBlend/

%% test mask generation
test_im = im2double(imread('./test_images/test_1.png'));
test_im2 = im2double(imread('./test_images/test_2.png'));
mask_include = getMask(test_im);
mask_exclude = imcomplement(mask_include);
bounded_inclusive_mask = getBoundedMask(mask_include);

%% test determine best patch placements test
context_mask = getContextMask(mask_include);
% patch = placeContext(test_im, test_im_2, context_mask);
% figure(2), imagesc(patch);

%% test poisson blend
% param 1 = foreground
% param 2 = foreground mask
% param 3 = background
% im_blend = poissonBlend(test_im2, mask_include, test_im);