function [result] = RgbFusion(img1, img2, N)
%RGBFUSION Summary of this function goes here
%   Detailed explanation goes here

if N == 0
    N = 5;
end

redResult = PyrFusion(img1(:,:,1), img2(:,:,1), N);
greenResult = PyrFusion(img1(:,:,2), img2(:,:,2), N);
blueResult = PyrFusion(img1(:,:,3), img2(:,:,3), N);

for i=1:N-1
    result = cat(3, redResult{i}, greenResult{i}, blueResult{i});
    figure, imshow(result);
end

end

