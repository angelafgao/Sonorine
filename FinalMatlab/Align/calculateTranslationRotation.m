%{
    Calculates the x, y translations and rotation of img2 which best aligns
    it with img1. Takes in the x, y translations and rotation calculated in
    the previous levels. Returns the new x, y translations and rotation.
    Level is 9-actual level. Uses imrotate_white, which is a modified
    version of imrotate in which the background black pixels that fill in
    the edges are white.
%}
function [trans_x, trans_y, rotation, min_rotation_error] = calculateTranslationRotation(prev_trans_x, prev_trans_y, prev_rotation, img1, img2, level)
    x_length = size(img2, 2);
    y_length = size(img2, 1);
    rotation_matrix = zeros([13, 3]);
    for rot_index = -6:6  
        temp_img2 = imrotate_white(img2, prev_rotation + rot_index/(2^(level-1)), 'bicubic');
        temp_img2 = cropRotate(temp_img2, x_length, y_length);

        error_matrix = calculateErrorMatrix1(prev_trans_x, prev_trans_y, img1, temp_img2, level);
        [min_error, min_error_index] = min(error_matrix);
        new_trans_x = mod(min_error_index-1, 5) - 2 + prev_trans_x;
        new_trans_y = floor(((min_error_index-1)/5)) - 2 + prev_trans_y;
        rotation_matrix(rot_index + 7, :) = [min_error, new_trans_x, new_trans_y];
    end
    [min_rotation_error, rotation_index] = min(rotation_matrix(:, 1));
    rotation_col = rotation_matrix(rotation_index, :);
    trans_x = rotation_col(1, 2);
    trans_y = rotation_col(1, 3);
    rotation = prev_rotation + (rotation_index - 7)/(2^(level-1));
end