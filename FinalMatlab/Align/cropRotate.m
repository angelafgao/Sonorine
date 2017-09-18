%{
% Makes the dimensions of img1 the same as those provided by
% the second and third arugments. Returns the cropped image
%}
function [img1_cropped] = cropRotate(img1, x_length, y_length)
    x_difference = size(img1, 2) - x_length;
    y_difference = size(img1, 1) - y_length;

    img1_cropped = ...
        img1(floor(y_difference/2) + 1:size(img1, 1) - ceil(y_difference/2),...
        floor(x_difference/2) + 1:size(img1, 2) - ceil(x_difference/2));
end