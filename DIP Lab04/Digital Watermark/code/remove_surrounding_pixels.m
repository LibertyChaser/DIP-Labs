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
imwrite(W, 'watermark_image.jpg');
% imshow(W);
end

