clc;clear;
img = imread('../img/3.png');
img = im2double(img);
img = rgb2gray(img);

% imshow(img);
cw = .375;
ker1d = [.25-cw/2 .25 cw .25 .25-cw/2]*1;
kernel = kron(ker1d,ker1d');

img_blur = imfilter(img, kernel, 'conv');

% img_blur = PryUp(PryDown(img));

% imshow(img);
% figure, imshow(img_blur);

subplot(1,2,1), imshow(img);
subplot(1,2,2), imshow(img_blur);
% title('Original Image VS Gaussion Blur')
