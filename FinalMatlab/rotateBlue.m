for i = 26:120
    % Read the blue images
    img0 = imread(sprintf('../Processed/Blue_images/Sonorine_%03d/sonorine_%03d_000.tiff', i, i));
    img90 = imread(sprintf('../Processed/Blue_images/Sonorine_%03d/sonorine_%03d_090.tiff', i, i));
    img180 = imread(sprintf('../Processed/Blue_images/Sonorine_%03d/sonorine_%03d_180.tiff', i, i));
    img270 = imread(sprintf('../Processed/Blue_images/Sonorine_%03d/sonorine_%03d_270.tiff', i, i));
    
    % Rotate the blue images
    img90_rot = imrotate(img90, 90);
    img180_rot = imrotate(img180, 180);
    img270_rot = imrotate(img270, 270);
    
    % Save the rotated blue images
    imwrite(img0, sprintf('../Processed/Blue_images_rotated/Sonorine_%03d/sonorine_%03d_000.tiff', i, i));
    imwrite(img90_rot, sprintf('../Processed/Blue_images_rotated/Sonorine_%03d/sonorine_%03d_090.tiff', i, i));
    imwrite(img180_rot, sprintf('../Processed/Blue_images_rotated/Sonorine_%03d/sonorine_%03d_180.tiff', i, i));
    imwrite(img270_rot, sprintf('../Processed/Blue_images_rotated/Sonorine_%03d/sonorine_%03d_270.tiff', i, i));
    
    fprintf('Done with %d\n', i);
end