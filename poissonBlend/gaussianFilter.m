function [img_gauss] = gaussianFilter(img, sigma) 
    fftsize = 2048; %order of 2 for speed, include padding
    hs = 30; % filter half-size(?)    

    img_fft = fft2(img, fftsize, fftsize); % fft of im1 with padding
    fil1 = fspecial('gaussian', hs*2 + 1, sigma);
    fil_fft1 = fft2(fil1, fftsize, fftsize); % fft fil, pad to the same size as image(?)
    img_fil_fft = img_fft .* fil_fft1; % multiply fft images(?)
    img_fil = ifft2(img_fil_fft); % inverse fft2
    img_fil = img_fil(1+hs:size(img,1)+hs, 1+hs:size(img, 2)+hs); % 5) remove padding
    
    img_gauss = img_fil;
end