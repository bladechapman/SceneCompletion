addpath getMask/
addpath localContext/

%% test mask generation
test_im = im2double(imread('./test_images/test_1.png'));
test_im_2 = im2double(imread('./test_images/test_2.jpg'));
% mask_include = getMask(test_im);
% mask_exclude = imcomplement(mask_include);
% bounded_inclusive_mask = getBoundedMask(mask_include);

%% test poisson blend

% context_mask = getContextMask(mask_include);
% calculate mask of area surrounding the hole (80px radius)
% context_mask = getContextMask(mask_include);
% context_mask = getBoundedMask(context_mask);
patch = placeContext(test_im, test_im_2, context_mask);

figure(2), imagesc(patch);