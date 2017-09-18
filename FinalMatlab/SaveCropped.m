CoordinateStruct = load('CroppedCoordinates/croppedRectanglesMatrixFinal');
Coordinates = CoordinateStruct.TotalCoordinates;

for i = 1:120
    for j = 0:3
        im_path = sprintf('../Processed/Blue_images_rotated_cropped/Sonorine_%03d/sonorine_%03d_%03d.tiff', i, i, j*90);
        im = imread(im_path);
        x = floor(Coordinates((i-1)*2+1, 1));
        y = floor(Coordinates((i-1)*2+1, 2));
        width = floor(Coordinates((i-1)*2+1, 3));
        height = floor(Coordinates((i-1)*2+1, 4));
        block1 = im(y:y+height, x:x+width);
        
        x = floor(Coordinates((i-1)*2+2, 1));
        y = floor(Coordinates((i-1)*2+2, 2));
        width = floor(Coordinates((i-1)*2+2, 3));
        height = floor(Coordinates((i-1)*2+2, 4));
        block2 = im(y:y+height, x:x+width);
        
        imwrite(block1, sprintf('../Processed/Really_cropped/Sonorine_%03d/sonorine_%03d_%03d_1.tiff', i, i, j*90));
        imwrite(block2, sprintf('../Processed/Really_cropped/Sonorine_%03d/sonorine_%03d_%03d_2.tiff', i, i, j*90));
    end
end