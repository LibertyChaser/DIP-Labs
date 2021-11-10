# DIP Exp03 Report

---

[toc]

Author: Songqing Zhao, Minzu University of China

Written at Oct 16^th^, 2021

>[Seam Carving for Content-Aware Image Resizing PDF](https://perso.crans.org/frenoy/matlab2012/seamcarving.pdf)
>
>[Seam Carving for Content-Aware Image Resizing](https://faculty.idc.ac.il/arik/SCWeb/imret/index.html)
>
>[Seam carving From Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Seam_carving)
>
>[Prewitt operator From Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Prewitt_operator)

---

## Exp Purpose 

1. Explain how the Seam carving works
2. Use seam carving to reduce a gray image size, and show the result
3. Use seam carving to reduce an RGB image size, and show the result
4. Extand an image by inserting seams

## Exp Principle

### Seam Carving

**Seam carving** (or **liquid rescaling**) is an algorithm for content-aware [image resizing](https://en.wikipedia.org/wiki/Image_scaling), developed by [Shai Avidan](https://en.wikipedia.org/w/index.php?title=Shai_Avidan&action=edit&redlink=1), of [Mitsubishi Electric Research Laboratories](https://en.wikipedia.org/wiki/Mitsubishi_Electric_Research_Laboratories) (MERL), and [Ariel Shamir](https://en.wikipedia.org/wiki/Ariel_Shamir), of the [Interdisciplinary Center](https://en.wikipedia.org/wiki/Interdisciplinary_Center) and MERL. It functions by establishing a number of *seams* (paths of least importance) in an image and automatically removes seams to reduce image size or inserts seams to extend it. Seam carving also allows manually defining areas in which pixels may not be modified, and features the ability to remove whole objects from photographs.

#### Seams

A seam is an op- timal 8-connected path of pixels on a *single* image from top to bot- tom, or left to right, where optimality is defined by an image energy function.

#### Process

1. Start with an image.
2. Calculate the weight/density/energy of each pixel. This can be done by various algorithms: gradient magnitude, entropy, visual saliency, eye-gaze movement.[[1]](https://en.wikipedia.org/wiki/Seam_carving#cite_note-ACM1276390-1)Here we use gradient magnitude.
3. From the energy, make a list of seams. Seams are ranked by energy, with low energy seams being of least importance to the content of the image. Seams can be calculated via the dynamic programming approach below.
4.  Remove low-energy seams as needed.
5. Final image.

### Computing seams

[Dynamic programming](https://en.wikipedia.org/wiki/Dynamic_programming) is a programming method that stores the results of sub-calculations in order to simplify calculating a more complex result. Dynamic programming can be used to compute seams. If attempting to compute a vertical seam (path) of lowest energy, for each pixel in a row we compute the energy of the current pixel plus the energy of one of the three possible pixels above it.

The images below depict a DP process to compute one optimal seam.[[2]](https://en.wikipedia.org/wiki/Seam_carving#cite_note-ACM1276390-1) Each square represents a pixel, with the top-left value in red representing the energy value of that said pixel. The value in black represents the cumulative sum of energies leading up to and including that pixel.

The energy calculation is trivially parallelized for simple functions. The calculation of the DP array can also be parallelized with some interprocess communication. However, the problem of making multiple seams at the same time is harder for two reasons: the energy needs to be regenerated for each removal for correctness and simply tracing back multiple seams can form overlaps. Avidan 2007 computes all seams by removing each seam iteratively and storing an "index map" to record all the seams generated. The map holds a "nth seam" number for each pixel on the image, and can be used later for size adjustment.[[3]](https://en.wikipedia.org/wiki/Seam_carving#cite_note-ACM1276390-1)

If one ignores both issues however, a greedy approximation for parallel seam carving is possible. To do so, one starts with the minimum-energy pixel at one end, and keep choosing the minimum energy path to the other end. The used pixels are marked so that they are not picked again.[[4]](https://en.wikipedia.org/wiki/Seam_carving#cite_note-3) Local seams can also be computed for smaller parts of the image in parallel for a good approximation. [[5]](https://en.wikipedia.org/wiki/Seam_carving#cite_note-jnd-4)

### Prewitt operator

The **Prewitt operator** is used in [image processing](https://en.wikipedia.org/wiki/Image_processing), particularly within [edge detection](https://en.wikipedia.org/wiki/Edge_detection) algorithms. Technically, it is a [discrete differentiation operator](https://en.wikipedia.org/wiki/Difference_operator), computing an approximation of the [gradient](https://en.wikipedia.org/wiki/Image_gradient) of the image intensity function. At each point in the image, the result of the Prewitt operator is either the corresponding gradient vector or the norm of this vector. The Prewitt operator is based on convolving the image with a small, separable, and integer valued filter in horizontal and vertical directions and is therefore relatively inexpensive in terms of computations like [Sobel](https://en.wikipedia.org/wiki/Sobel_operator) and Kayyali[[6]](https://en.wikipedia.org/wiki/Prewitt_operator#cite_note-1) operators. On the other hand, the gradient approximation which it produces is relatively crude, in particular for high frequency variations in the image. The Prewitt operator was developed by [Judith M. S. Prewitt](https://en.wikipedia.org/w/index.php?title=Judith_Prewitt&action=edit&redlink=1).[[7]](https://en.wikipedia.org/wiki/Prewitt_operator#cite_note-2)

## Exp Procedure

### Generate an Energy Map

```matlab
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

```

### Deleting Seams

```matlab
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

```

### Inserting Seams

This algorithm is not good, and can’t meet the expectations. That really a pity. The Exp result is at the last part of this report.

```matlab
function [output] = InsertingSeam(input_img, energy_map)
%INSERTINGSEAM Summary of this function goes here
%   Detailed explanation goes here

img_gray = im2gray(input_img);
[r,c] = size(img_gray);

new_img_red = zeros(r, c+1);
new_img_green = zeros(r, c+1);
new_img_blue = zeros(r, c+1);

max_val = max(max(energy_map));
n = 1;
new_col = max_val * ones(r, n);
energy_map = [new_col, energy_map, new_col];

min_val = min(energy_map(r,:));
[~, min_col] = find(energy_map(r,:) == min_val, 1);

if min_col-n-1 < 1
    min_col = n + 2;
elseif min_col-n+1 > c
    min_col = c + n - 1;
end
new_img_red(r,:)   = [input_img(r,1:min_col-n-1,1), max(input_img(r,min_col-n-1:min_col-n+1,1)), input_img(r,min_col-n:c,1)];
new_img_green(r,:) = [input_img(r,1:min_col-n-1,2), max(input_img(r,min_col-n-1:min_col-n+1,2)), input_img(r,min_col-n:c,2)];
new_img_blue(r,:)  = [input_img(r,1:min_col-n-1,3), max(input_img(r,min_col-n-1:min_col-n+1,3)), input_img(r,min_col-n:c,3)];

for i=r-1:-1:1
    min_val = min(energy_map(i, min_col-1), energy_map(i, min_col));
    min_val = min(min_val, energy_map(i, min_col+1));
    if min_val == energy_map(i, min_col-1)
        min_col = min_col - 1;
    elseif min_val == energy_map(i, min_col+1)
        min_col = min_col + 1;
    end
    if min_col-n-1 < 1
        min_col = n + 2;
    elseif min_col-n+1 > c
        min_col = c + n - 1;
    end
%     new_img_red(i,:)   = [input_img(i,1:min_col-n-1,1), max(input_img(i,min_col-n-1,1), max(input_img(i,min_col-n,1), input_img(i,min_col-n+1,1))), input_img(i,min_col-n:c,1)];
%     new_img_green(i,:) = [input_img(i,1:min_col-n-1,2), max(input_img(i,min_col-n-1,2), max(input_img(i,min_col-n,2), input_img(i,min_col-n+1,2))), input_img(i,min_col-n:c,2)];
%     new_img_blue(i,:)  = [input_img(i,1:min_col-n-1,3), max(input_img(i,min_col-n-1,3), max(input_img(i,min_col-n,3), input_img(i,min_col-n+1,3))), input_img(i,min_col-n:c,3)];
    new_img_red(i,:)   = [input_img(i,1:min_col-n-1,1), max(input_img(r,min_col-n-1:min_col-n+1,1)), input_img(i,min_col-n:c,1)];
    new_img_green(i,:) = [input_img(i,1:min_col-n-1,2), max(input_img(r,min_col-n-1:min_col-n+1,2)), input_img(i,min_col-n:c,2)];
    new_img_blue(i,:)  = [input_img(i,1:min_col-n-1,3), max(input_img(r,min_col-n-1:min_col-n+1,3)), input_img(i,min_col-n:c,3)];

end

output = cat(3, new_img_red, new_img_green, new_img_blue);

end

```

### Seam Carving 

```matlab
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

```

### Test

```matlab
clc;clear;

SeamCarving('../image/300*358.png', 300, 500);

```

## Exp Result

### Good result

Convert 588*853 jpg to 600\*600 jpg.

![Screen Shot 2021-10-16 at 17.29.49](DIP Exp03 Report.assets/Screen Shot 2021-10-16 at 17.29.49.png)

### Problems

Still remain problem to solve.

Convert 300\*358 png to 350*450 png.

<img src="DIP Exp03 Report.assets/Screen Shot 2021-10-16 at 17.31.25.png" alt="Screen Shot 2021-10-16 at 17.31.25" style="zoom:60%;" />

