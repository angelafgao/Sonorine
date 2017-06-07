%{
    Crops the rotated image to the same size as the original image.
%}
function [img2_cropped] = cropRotate(img2, x_length, y_length)
    x_difference = size(img2, 2) - x_length;
    y_difference = size(img2, 1) - y_length;

    img2_cropped = img2(floor(y_difference/2) + 1:size(img2, 1) - ceil(y_difference/2),...
        floor(x_difference/2) + 1:size(img2, 2) - ceil(x_difference/2));
end