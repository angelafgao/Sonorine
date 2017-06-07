%{
    Makes both images the same size by padding with 0's on the right and
    bottome sides of the smaller image
%}
function [temp1, temp2] = padImage(img1, img2)
    if (size(img1, 1) ~= size(img2, 1)) || (size(img1, 2) ~= size(img2, 2))
        max_height = max(size(img1, 2), size(img2, 2));
        max_width = max(size(img1, 1), size(img2, 1));
        temp1 = zeros(max_width, max_height);
        temp2 = zeros(max_width, max_height);
        temp1(1:size(img1, 1), 1:size(img1, 2)) = img1;
        temp2(1:size(img2, 1), 1:size(img2, 2)) = img2;
    else
        temp1 = img1;
        temp2 = img2;
    end
end