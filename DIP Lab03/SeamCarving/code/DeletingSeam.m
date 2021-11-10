function [output] = DeletingSeam(input_img, energy_map)
%DELETINGSEAM Summary of this function goes here
%   Detailed explanation goes here

img_gray = im2gray(input_img);
[r,c] = size(img_gray);

new_img_red = zeros(r, c-1);
new_img_green = zeros(r, c-1);
new_img_blue = zeros(r, c-1);

max_val = max(max(energy_map));
new_col = max_val * ones(r, 1);
energy_map = [new_col, energy_map, new_col];

min_val = min(energy_map(r,:));
[~, min_col] = find(energy_map(r,:) == min_val);

new_img_red(r,:) = [input_img(r,1:min_col-2,1), input_img(r,min_col:c,1)];
new_img_green(r,:) = [input_img(r,1:min_col-2,2), input_img(r,min_col:c,2)];
new_img_blue(r,:) = [input_img(r,1:min_col-2,3), input_img(r,min_col:c,3)];

for i=r-1:-1:1
    min_val = min(energy_map(i, min_col-1), energy_map(i, min_col));
    min_val = min(min_val, energy_map(i, min_col+1));
    if min_val == energy_map(i, min_col-1)
        min_col = min_col - 1;
    elseif min_val == energy_map(i, min_col+1)
        min_col = min_col + 1;
    end
    new_img_red(i,:) = [input_img(i,1:min_col-2,1), input_img(i,min_col:c,1)];
    new_img_green(i,:) = [input_img(i,1:min_col-2,2), input_img(i,min_col:c,2)];
    new_img_blue(i,:) = [input_img(i,1:min_col-2,3), input_img(i,min_col:c,3)];
end

output = cat(3, new_img_red, new_img_green, new_img_blue);

end

