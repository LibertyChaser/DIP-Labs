function [] = create_watermark_image(input)

% I = imread('cameraman.tif');
I = 0 * ones(50, 100, 'uint8');
imshow(I);

text('Position',[16 16],'String',input,'FontSize',8,'color','w');

f = getframe(figure(1)); % Capture axes or figures as movie frames

imwrite(f.cdata,'watermark_image.jpg');
close;
end
