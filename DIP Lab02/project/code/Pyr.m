function [gauss, laplace] = Pyr(input, layerNum)
%PRY Summary of this function goes here
%   Detailed explanation goes here

gauss = cell(1,layerNum);
laplace = cell(1,layerNum);

gauss{1} = input;

for i=2:layerNum
    gauss{i} = PyrDown(gauss{i-1});
    laplace{i-1} = gauss{i-1} - PyrUp(gauss{i});
end

laplace{layerNum} = gauss{layerNum};

end
