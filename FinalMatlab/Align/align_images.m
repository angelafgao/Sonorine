function aligned_images = align_images(w, h, temp_images, trans_info)
    trans_info(1, :) = trans_info(1, :) + abs(min(0, min(trans_info(1, :))));
    trans_info(2, :) = trans_info(2, :) + abs(min(0, min(trans_info(2, :))));
    [align, w_aligned, h_aligned] = get_aligned_dims(w, h, trans_info);
    aligned_images = zeros(h_aligned, w_aligned, 4);
   
    for i = 1:4
        aligned_images(:, :, i) = ...
            temp_images(align(2, i):align(2, i)+h_aligned - 1, ...
            align(1, i):align(1, i) + w_aligned - 1, i);
    end
end