function [output] = PyrFusion(input1, input2, N)
%PRYFUSION Summary of this function goes here
%   Detailed explanation goes here

if N == 0
    N = 5;
end

[g1, l1] = Pyr(input1, N);
[g2, l2] = Pyr(input2, N);

resL = cell(1, N);

for i=1:N
%     para1 = sum(g1{i});
%     para2 = sum(g2{i});
%     paraSum = para1 + para2;
%     para1 = para1 / paraSum;
%     para2 = 1 - para1;
    resL{i} = l1{i} * 0.5 + l2{i} * 0.5;
%     figure, imshow(g1{i});
end

resG = cell(1, N);
resG{N} = resL{N};

for i=N-1:-1:1
    resG{i} = PyrUp(resG{i+1}) + resL{i};
end
output = resG;

end
