%{
    Calculates a matrix of errors of all possible translations in all sides
    of the image within 2 pixels. Takes in the x and y translations
    calculated at previous levels. Takes in the 2 images and the level of
    the current iteration.
%}
function [error_matrix] = calculateErrorMatrix(prev_trans_x, prev_trans_y, img1, img2, level)
    error_matrix = zeros(25, 1);
    for i = -2:2
        for j = -2:2
            start = 2^(level+1) - 2;
            check1 = img1(start+1:size(img1, 1)-start, start+1:size(img1, 2)-start);
            check2 = img2(prev_trans_y+start+1+i:prev_trans_y+size(img2, 1)-start+i,...
                prev_trans_x+start+1+j:prev_trans_x+size(img2, 2)-start+j);
            sub = abs(check1 - check2);
            error_matrix((i+2)*5 + 1 + (j+2)) = sum(sum(sub));
        end
    end
end