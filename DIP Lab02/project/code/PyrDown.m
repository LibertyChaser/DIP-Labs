function [output] = PyrDown(input)
%PRYDOWN Summary of this function goes here
%   Detailed explanation goes here

% kernelWidth = 5; % default
cw = .375;
ker1d = [.25-cw/2 .25 cw .25 .25-cw/2]*1;
kernel = kron(ker1d,ker1d');

input_blur = imfilter(input, kernel, 'conv');

[r,c] = size(input);
input_blur_row = input_blur(1:2:r,:);
output = input_blur_row(:,1:2:c);

end
