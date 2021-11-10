clc;clear;

img = imread('../image/sample.png');
W = imread('../image/watermark1.png');

img = rgb2gray(img);
W = mat2gray(rgb2gray(W));

% Fourier transform
F = fft2(img);
[F_r, F_c] = size(F);

% Center transformation result
F_C = fftshift(F);

% Fourier spectrum
S_C = abs(F_C);

% Log fourier spectrum
% log_S = log(S_C);
imshow(W);

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
        W = W(:, 1:temp+1);
        break;
    end
    temp = temp + 1;
end

[w_row, w_col] = size(W);

% W = W * mean(mean(S_C(1:w_row, 1:w_col)));
W = W * max(max(S_C));

% rotate watermark
r_W = rot90(W, 2);

% watermarked fourier spectrum
w_S_C = S_C;
w_S_C(1:w_row, 1:w_col) = W;
w_S_C(end-w_row+1:end, end-w_col+1:end) = r_W;

w_S = ifftshift(w_S_C);
phi = angle(F);
w_F = w_S .* exp(1i * phi);

w_img = uint8(real(ifft2(F)));

imshow(img);
% figure, imshow(watermark1);
% figure, imshow(S, [ ]), title("fourier spectrum");
figure, imshow(log(w_S_C), [ ]), title("log fourier spectrum");
% figure, imshow(log(w_S), [ ]);
figure, imshow(w_img);


