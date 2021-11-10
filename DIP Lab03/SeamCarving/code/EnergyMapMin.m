function [output] = EnergyMapMin(input_img)
%ENERGYMAP Summary of this function goes here
%   Detailed explanation goes here

img_gray = im2gray(input_img);
[energy_map, ~] = imgradient(img_gray,'prewitt');

[r, c] = size(energy_map);

for i=2:r
    for j=1:c
        if j == 1
            energy_map(i,1) = energy_map(i,j) + min(energy_map(i-1,1), energy_map(i-1,2));
        elseif j == c
            energy_map(i,c) = energy_map(i,j) + min(energy_map(i-1,c-1), energy_map(i-1,c));
        else
            energy_map(i,j) = energy_map(i,j) + min(energy_map(i-1,j-1), min(energy_map(i-1,j),energy_map(i-1,j+1)));
        end
    end
end

output = energy_map;

end
