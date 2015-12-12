addpath getMask/
addpath localContext/
addpath poissonBlend/

%% test mask generation
test_im = im2double(imread('./test_images/test_1.png'));
test_im2 = im2double(imread('./test_images/test_2.png'));
mask_include = getMask(test_im);
mask_exclude = imcomplement(mask_include);
bounded_inclusive_mask = getBoundedMask(mask_include);

%% test local context matching
% context_mask = getContextMask(mask_include);

%% test poisson blend
im_blend = poissonBlend(test_im2, mask_include, test_im);
