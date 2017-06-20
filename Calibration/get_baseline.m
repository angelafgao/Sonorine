function k = get_baseline()
    path = '../../../Calibration_images/Cropped/';
    curr_path = strcat(path, 'flat.jpg');
    image = imread(curr_path);
    image = image(:, :, 3);
    long_edge = max(size(image));
    short_edge = min(size(image));
    data = image(floor(long_edge/3):floor(long_edge*2/3), ...
        floor(short_edge/3):floor(short_edge*2/3));
    k = ((mean(mean(data)))/255*2) - 1;
end
