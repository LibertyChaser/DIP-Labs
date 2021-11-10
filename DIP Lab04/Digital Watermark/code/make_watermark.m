function [w_img] = make_watermark(input_text, input_img)

create_watermark_image(input_text);
W = imread('watermark_image.jpg');
W = mat2gray(rgb2gray(W));
W = round(W);
W = remove_surrounding_pixels(W);

% img = imread(input_path);
img = input_img;
img = rgb2gray(img);

% Fourier transform
F = fft2(img);
% [F_r, F_c] = size(F);

% Center transformation result
F_C = fftshift(F);

% Fourier spectrum
S_C = abs(F_C);

[w_row, w_col] = size(W);

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

