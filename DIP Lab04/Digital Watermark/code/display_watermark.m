function [S_C] = display_watermark(f)
F = fft2(f);
F_C = fftshift(F);
S_C = abs(F_C);
end
