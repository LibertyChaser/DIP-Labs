clc; clear;

img = imread('../image/sample.png');
% img = imread('../image/588*853.jpg');

watermarked = make_watermark('DIP', img);
S_C = display_watermark(watermarked);

blur_watermarked = blur(watermarked, 10);
S_C_blur = display_watermark(blur_watermarked);

resize1_1 = imresize(watermarked, 1.1);
S_C_1_1 = display_watermark(resize1_1);

resize0_9 = imresize(watermarked, 0.9);
S_C_0_9 = display_watermark(resize0_9);

rotate_img = imrotate(watermarked, 30);
S_C_rotate = display_watermark(rotate_img);

figure, imshow(rgb2gray(img)), title('Original Gray Image');
figure, imshow(watermarked), title('Watermarked Image');
% figure, imshow(log(S_C), [ ]), title('Display the watermark');
% figure, imshow(blur_watermarked), title('Blured watermarked image');
% figure, imshow(log(S_C_blur), [ ]), title('Display the watermark after blur');
% figure, imshow(resize1_1), title('resize 1.1');
% figure, imshow(log(S_C_1_1), [ ]), title('Display the watermark resized 1.1');
% figure, imshow(resize0_9), title('resize 0.9');
% figure, imshow(log(S_C_0_9), [ ]), title('Display the watermark resized 0.9');
% figure, imshow(rotate_img);
% figure, imshow(log(S_C_rotate), [ ]);