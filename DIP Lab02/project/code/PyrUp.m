function [output] = PyrUp(input)
%PRYUP Summary of this function goes here
%   Detailed explanation goes here
[r, c] = size(input);

cw = .375;
ker1d = [.25-cw/2 .25 cw .25 .25-cw/2]*1.9;
kernel = kron(ker1d,ker1d');

inputDouble = zeros(r*2, c*2);
inputDouble(1:2:end,1:2:end) = input;
output = imfilter(inputDouble, kernel, 'conv');

end
