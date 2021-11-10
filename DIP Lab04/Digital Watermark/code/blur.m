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
