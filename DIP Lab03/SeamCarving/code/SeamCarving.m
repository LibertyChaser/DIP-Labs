function [output] = SeamCarving(path, aim_row, aim_col)
%PROCESSING Summary of this function goes here
%   Detailed explanation goes here

img = imread(path);
img = im2double(img);
pro_img = img;

figure, imshow(pro_img);
title('Original Image');
img_gray = im2gray(pro_img); % if not, r and c will 3 times gray image
[r, c] = size(img_gray);

if aim_col < c
    for j=1:c - aim_col
        energy_map = EnergyMapMin(pro_img);
        pro_img = DeletingSeam(pro_img, energy_map);
    end
else
    for j=1:aim_col - c
        energy_map = EnergyMapMin(pro_img);
        pro_img = InsertingSeam(pro_img, energy_map);
    end
end
% figure, imshow(pro_img);

pro_img = permute(pro_img, [2 1 3]);
if aim_row < r
    for i=1:r - aim_row
        energy_map = EnergyMapMin(pro_img);
        pro_img = DeletingSeam(pro_img, energy_map);
    end
else
    for i=1:aim_row - r
        energy_map = EnergyMapMin(pro_img);
        pro_img = InsertingSeam(pro_img, energy_map);
    end
end
pro_img = permute(pro_img, [2 1 3]);

figure, imshow(pro_img);
title('Image After Seam Carving');

output = pro_img;

end
