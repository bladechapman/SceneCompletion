addpath getMask/
addpath localContext/

%% test mask generation
test_im = im2double(imread('./test_images/test_3.jpg'));
test_im_2 = im2double(imread('./test_images/test_4.jpg'));
mask_include = getMask(test_im);
mask_exclude = imcomplement(mask_include);

%% test determine best patch placements test
context_mask = getContextMask(mask_include);
patch = placeContext(test_im, test_im_2, context_mask);
figure(2), imagesc(patch);
