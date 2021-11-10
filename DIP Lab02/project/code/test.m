
N = 4;

img1 = imread('../img/1.jpg');
img1 = im2double(img1);

img2 = imread('../img/2.jpg');
img2 = im2double(img2);

RgbFusion(img2, img1, N);

% grayRes = PryFusion(rgb2gray(img1), rgb2gray(img2), N);
% for i=1:N-1
%     figure, imshow(grayRes{i});
% end

% [g1, l1] = Pry(rgb2gray(img1), N);
% [g2, l2] = Pry(rgb2gray(img2), N);
% 
% resL = cell(1, N);
% 
% for i=1:N
%     resL{i} = g2{i} * 0.2 + l1{i} * 0.8;
%     figure, imshow(resL{i});
% end
