for i = 4:4
    for j = 1:4
        path = sprintf('../../Processed2/Aligned/Sonorine_%03d/sonorine_%03d_%03d.tiff', i, i, (j-1)*90);
        image = imread(path);
        if j == 1
            s = size(image);
            h = s(1);
            w = s(2);
            im = zeros(h, w, 4);
        end
        im(:, :, j) = im2double(image);
    end
    
    %l = [0    -0.3943   0.9190];
    %l = [0.13, -0.3721, 0.9190];
    %l = [0.1329, -0.3712, 0.9190];
    l = [0.1477, -0.3656, 0.9190];
    
    lx = l(1);
    ly = l(2);
    lz = l(3);
    
    normal_map = zeros(h, w, 3);
    
    I1 = reshape(im(:, :, 1)', h*w, 1)';
    I2 = reshape(im(:, :, 2)', h*w, 1)';
    I3 = reshape(im(:, :, 3)', h*w, 1)';
    I4 = reshape(im(:, :, 4)', h*w, 1)';
    
    A = [-lx, -ly, lz; ...
        -ly, lx, lz; ...
        lx, ly, lz; ...
        ly, -lx, lz];
    b = [I1; I2; I3; I4];
    x = A\b;
    
    nx = reshape(x(1, :), w, h)';
    ny = reshape(x(2, :), w, h)';
    nz = reshape(x(3, :), w, h)';
    
    magnitudes = (nx.^2 + ny.^2 + nz.^2).^0.5;
    normal_map(:, :, 1) = nx./magnitudes;
    normal_map(:, :, 2) = ny./magnitudes;
    normal_map(:, :, 3) = nz./magnitudes;
        
    normal_map = (normal_map + 1)*255/2;
    filename = sprintf('../../Normal_Map/sonorine_%03d.mat', i);
    save(filename, 'normal_map');
end