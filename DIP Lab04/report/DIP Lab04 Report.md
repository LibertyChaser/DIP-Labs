# DIP Lab04 Report

---

[toc]

Author: Songqing Zhao, Minzu University of China 

Written at Nov 4^th^, 2021

E-mail: liberty_chaser@outlook.com 

---

**Reference:**

>[Digital watermarking](https://en.wikipedia.org/wiki/Digital_watermarking)
>
>[matlab2018在图片上添加文字并保存且图片没有白边](https://blog.csdn.net/qigeyonghuming_1/article/details/108448443?spm=1001.2101.3001.6650.8&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7Edefault-8.essearch_pc_relevant&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7Edefault-8.essearch_pc_relevant)
>
>[Fourier Transform](https://homepages.inf.ed.ac.uk/rbf/HIPR2/fourier.htm)

---

## Lab Purpose

Generate digital watermark. Add a digital watermark (including personal information logo) on the experimental image. Requires frequency domain processing methods.

1) Submit the original image, watermarked image, watermarked image, and watermarked image;

2) Submit M documents;

3) Submit a WORD experiment report, including relevant test results against geometric attacks.

  (Design, process, results, analysis, conclusion)

## Lab Principle

### Watermark technology background

A **digital watermark** is a kind of marker covertly embedded in a noise-tolerant [signal](https://en.wikipedia.org/wiki/Signal_(electrical_engineering)) such as audio, video or image data. It is typically used to identify ownership of the copyright of such signal. "Watermarking" is the process of hiding digital information in a [carrier signal](https://en.wikipedia.org/wiki/Carrier_signal); the hidden information should,[[1\]](https://en.wikipedia.org/wiki/Digital_watermarking#cite_note-Cox-1) but does not need to, contain a relation to the carrier signal. Digital watermarks may be used to verify the authenticity or integrity of the carrier signal or to show the identity of its owners. It is prominently used for tracing [copyright infringements](https://en.wikipedia.org/wiki/Copyright_infringement) and for [banknote](https://en.wikipedia.org/wiki/Banknote)authentication.

Digital watermarking technology is currently an important branch in the field of information security. As an active authentication method for copyright protection and authenticity identification, it has become an important means to protect the security of multimedia information (digital image watermark, digital audio watermark and digital video watermark...).

Digital image is the most important part of multimedia resources, and digital image watermarking has also become a core research direction in digital watermarking technology, and it has played an important role in digital image content authentication and copyright protection.

In an open Internet environment, digital image watermarking technology hides the watermark information in the image content that needs to be protected. When implementing the copyright protection process, it is necessary to ensure that the visual quality of the carrier image is not significantly reduced, and it must be affected by external interference or signals. After the attack, most of the hidden watermark information can still be extracted.

At present, the problem of geometric attack resistance and the balance of robustness and imperceptibility are still common problems in the field of digital image watermarking research.

Digital watermarking technology essentially optimizes key links such as watermark preprocessing, embedding location selection, embedding method design and extraction method design, and seeks to meet the optimization design problems under the constraints of robustness, imperceptibility, and security.

For a complete digital watermark system, it usually consists of two steps: 

1. Digital watermark embedding
2. Digital watermark extraction

### Fourier transform

As we are only concerned with digital images, we will restrict this discussion to the *Discrete Fourier Transform* (DFT).

The DFT is the sampled Fourier Transform and therefore does not contain all frequencies forming an image, but only a set of samples which is large enough to fully describe the spatial domain image. The number of frequencies corresponds to the number of pixels in the spatial domain image, *i.e.* the image in the spatial and Fourier domain are of the same size.

For a square image of size M×N, the two-dimensional DFT is given by:
$$
F(K,l)=\sum_{i=0}^{M-1}\sum_{j=0}^{N-1}f(i,j)e^{-\iota2\pi (\frac{ki}M+\frac{lj}N)}
$$
where $f(a,b)$ is the image in the spatial domain and the exponential term is the basis function corresponding to each point $F(k,l)$ in the Fourier space. The equation can be interpreted as: the value of each point $F(k,l)$ is obtained by multiplying the spatial image with the corresponding base function and summing the result.

The basis functions are sine and cosine waves with increasing frequencies, $i.e. F(0,0)$ represents the DC-component of the image which corresponds to the average brightness and $F(M-1,N-1)$ represents the highest frequency.

In a similar way, the Fourier image can be re-transformed to the spatial domain. The inverse Fourier transform is given by:
$$
f(a,b)=\frac1{N^2}\sum_{k=0}^{M-1}\sum_{l=0}^{N-1}F(k,l)e^{-\iota2\pi (\frac{ka}M+\frac{lb}N)}
$$
Note the $\frac1{N^2}$ normalization term in the inverse transformation. This normalization is sometimes applied to the forward transform instead of the inverse transform, but it should not be used for both. 

## Lab Procedure

### Create a watermark image file in the folder

`create_watermark_image.m`

Input the text which will be used as the watermark image. This function will create the specific watermark image and save it as the file named `watermark_image.jpg`. However, the current image still can’t be used. Since the main content text is surrounded by the black and white frames that hinder out future work. This is the watermark image we will use in the next step.

```matlab
function [] = create_watermark_image(input)

% I = imread('cameraman.tif');
I = 0 * ones(50, 100, 'uint8');
imshow(I);

text('Position',[16 16],'String',input,'FontSize',8,'color','w');

f = getframe(figure(1)); % Capture axes or figures as movie frames

imwrite(f.cdata,'watermark_image.jpg');
close;
end

```

### Remove surrounding pixels in watermark image

`remove_surrounding_pixels.m`

The watermark image is surrounded by two frames. The outer frame is a white frame. The inner frame is rather a black one.

Therefore, we need to cut the white frame out at first.

```matlab
function [W] = remove_surrounding_pixels(W)

c = size(W, 2);
temp = 1;
while 1
    if sum(W(temp, :)) == c && sum(W(temp+1, :)) ~= c
        W = W(temp+1:end, :);
        temp = 1;
    end
    if sum(W(temp, :)) ~= c && sum(W(temp+1, :)) == c
        W = W(1:temp, :);
        temp = 1;
        break;
    end
    temp = temp + 1;
end

r= size(W, 1);
while 1
    if sum(W(:, temp)) == r && sum(W(:, temp + 1)) ~= r
        W = W(:, temp+1:end);
        temp = 1;
    end
    if sum(W(:, temp)) ~= r && sum(W(:, temp + 1)) == r
        W = W(:, 1:temp);
        break;
    end
    temp = temp + 1;
end
```

Then it turns to black frame.


```matlab
temp = 1;
while 1
    if sum(W(temp, :)) == 0 && sum(W(temp+1, :)) ~= 0
        W = W(temp:end, :);
        temp = 1;
    end
    if sum(W(temp, :)) ~= 0 && sum(W(temp+1, :)) == 0
        W = W(1:temp+1, :);
        temp = 1;
        break;
    end
    temp = temp + 1;
end

while 1
    if sum(W(:, temp)) == 0 && sum(W(:, temp + 1)) ~= 0
        W = W(:, temp:end);
        temp = 1;
    end
    if sum(W(:, temp)) ~= 0 && sum(W(:, temp + 1)) == 0
        temp = 1;
        break;
    end
    temp = temp + 1;
end

W = fliplr(W);

while 1
    if sum(W(:, temp)) == 0 && sum(W(:, temp + 1)) ~= 0
        W = W(:, temp:end);
        temp = 1;
    end
    if sum(W(:, temp)) ~= 0 && sum(W(:, temp + 1)) == 0
        break;
    end
    temp = temp + 1;
end

W = fliplr(W);
imwrite(W,'watermark_image.jpg');
% imshow(W);
end

```

Now we get a pure watermark image without the useless frame.

Call the function and input the text “DIP”. The  export watermark image is down blow.

![watermark_image](DIP Lab04 Report.assets/watermark_image.jpg)

### Make a digital watermark image

`make_watermark.m`

Call the previous function written just now.

```matlab
function [w_img] = make_watermark(input_text, input_img)

create_watermark_image(input_text);
W = imread('watermark_image.jpg');
W = mat2gray(rgb2gray(W));
W = round(W);
W = remove_surrounding_pixels(W);
```
Preprocessing without explaining.

```matlab
% img = imread(input_path);
img = input_img;
img = rgb2gray(img);
```
We wanted to add our watermark in the Fourier spectrum of the target image which is calculated from its Fourier transform.

```matlab
% Fourier transform
F = fft2(img);
% [F_r, F_c] = size(F);

% Center transformation result
F_C = fftshift(F);

% Fourier spectrum
S_C = abs(F_C);

[w_row, w_col] = size(W);
```
Add watermark in the upper left corner and bottom right corner in the Fourier spectrum.

```matlab
% W = W * mean(mean(S_C(1:w_row, 1:w_col)));
W = W * max(mean(S_C(1:w_row, 1:w_col))) .^ 1.75;

% rotate watermark
r_W = rot90(W, 2);

% watermarked fourier spectrum
w_S_C = S_C;
w_S_C(1:w_row, 1:w_col) = W;
w_S_C(end-w_row+1:end, end-w_col+1:end) = r_W;

w_S = ifftshift(w_S_C);
phi = angle(F);
w_F = w_S .* exp(1i * phi);

w_img = uint8(real(ifft2(w_F)));

% figure, imshow(log(w_S_C), [ ]), title("Log Fourier Spectrum");
% figure, imshow(w_img);

end

```

### Display the watermark

`display_watermark.m`

```matlab
function [S_C] = display_watermark(f)
F = fft2(f);
F_C = fftshift(F);
S_C = abs(F_C);
end

```

### Test in `main.m`

`main.m`

```matlab
clc; clear;

img = imread('../image/sample.png');
% img = imread('../image/588*853.jpg');
% imshow(rgb2gray(img)), title('Original Image');

watermarked = make_watermark('DIP', img);
S_C = display_watermark(watermarked);

imshow(watermarked), title('Watermarked Image');
figure, imshow(log(S_C), [ ]), title('Display the watermark');
```

We have 2 test image in this test. 

The first is `sample.png`. 

<img src="DIP Lab04 Report.assets/sample.png" alt="sample" style="zoom:50%;" />

The second is `588*853.jpg`.

<img src="DIP Lab04 Report.assets/588*853-6194492.jpg" alt="588*853" style="zoom:50%;" /> 

### Blur

`blur.m`

```matlab
function [gpc] = blur(f, sig)

% f = rgb2gray(f);

[f, revertclass] = tofloat(f);
% sig = 50;
PQ = paddedsize(size(f));
Fp = fft2(f, PQ(1), PQ(2));
Hp = lpfilter('gaussian', PQ(1), PQ(2), 2*sig);
Gp = Hp .* Fp;
gp = ifft2(Gp);
gpc = gp(1:size(f,1), 1:size(f,2));
gpc = revertclass(gpc);
% imshow(gpc);

end

```

### Resize

`main.m`

```matlab
resize1_1 = imresize(watermarked, 1.1);
resize0_9 = imresize(watermarked, 0.9);
```

## Lab Result

### Test code

`main.m`

```matlab
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

figure, imshow(rgb2gray(img)), title('Original Gray Image');
figure, imshow(watermarked), title('Watermarked Image');
figure, imshow(log(S_C), [ ]), title('Display the watermark');
figure, imshow(blur_watermarked), title('Blured watermarked image');
figure, imshow(log(S_C_blur), [ ]), title('Display the watermark after blur');
figure, imshow(resize1_1), title('resize 1.1');
figure, imshow(log(S_C_1_1), [ ]), title('Display the watermark resized 1.1');
figure, imshow(resize0_9), title('resize 0.9');
figure, imshow(log(S_C_0_9), [ ]), title('Display the watermark resized 0.9');

```

### Preprocessing

`original_gray_image1.jpg`

<img src="DIP Lab04 Report.assets/original_gray_image1-6197221.jpg" alt="original_gray_image1" style="zoom:50%;" />

### Watermarked image and its watermark

`watermarked_1.jpg`

<img src="DIP Lab04 Report.assets/watermarked_1.jpg" alt="watermarked_1" style="zoom:50%;" />

`watermark_1.jpg`

<img src="DIP Lab04 Report.assets/watermark_1.jpg" alt="watermark_1" style="zoom:50%;" />

### Blur watermarked image and its watermark

`blured_1.jpg`

<img src="DIP Lab04 Report.assets/blured_1.jpg" alt="blured_1" style="zoom:50%;" />

`watermark_blured_1.jpg`

<img src="DIP Lab04 Report.assets/watermark_blured_1.jpg" alt="watermark_blured_1" style="zoom:50%;" />

### Enlarge watermarked image and its watermark

`resized1.1_1.jpg`

<img src="DIP Lab04 Report.assets/resized1.1_1.jpg" alt="resized1.1_1" style="zoom:50%;" />

`watermark_resize1.1_1.jpg`

<img src="DIP Lab04 Report.assets/watermark_resize1.1_1.jpg" alt="watermark_resize1.1_1" style="zoom:50%;" />

### Zoom out watermarked image and its watermark

`resized0.9_1.jpg`

<img src="DIP Lab04 Report.assets/resized0.9_1.jpg" alt="resized0.9_1" style="zoom:50%;" />

`watermark_resize0.9_1.jpg`

<img src="DIP Lab04 Report.assets/watermark_resize0.9_1.jpg" alt="watermark_resize0.9_1" style="zoom:50%;" />

## Lab Conclusion

Geometric attacks can be better resisted, but high-pass filtering will directly remove the watermark

