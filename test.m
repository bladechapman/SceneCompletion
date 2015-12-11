addpath getMask/

%% test mask generation
test_im = im2double(imread('./test_images/test_1.png'));
mask_include = getMask(test_im);
mask_exclude = imcomplement(mask_include);