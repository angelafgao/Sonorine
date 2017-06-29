for i = 1:120
    for j = 1:4
        path = sprintf('Sonorine_001_aligned_cropped/sonorine_%03d_%03d.tiff', i, (j-1)*90);
        image = imread(path);
        if j == 1
            s = size(image);
            h = s(1);
            w = s(2);
            im = zeros(h, w, 4);
        end
        im(:, :, j) = im2double(image);
    end
    
    l = [0    0.3943   -0.9190];
    
    normal_map = zeros(h, w, 3);
    normal = zeros(1, 3);
    
    normal_map(:, :, 1) = (im(:, :, 4) - im(:, :, 2)) / (2 * l(2));
    normal_map(:, :, 2) = (im(:, :, 1) - im(:, :, 3)) / (2 * l(2));
    normal_map(:, :, 3) = (im(:, :, 1) + im(:, :, 2) + im(:, :, 3) + ...
        im(:, :, 4)) / (4 * l(3));
    
    normal_map = (normal_map + 1)*225/2;
    filename = sprintf('Normal_Map/sonorine_%03d.mat', i);
    save(filename, 'normal_map');
end
