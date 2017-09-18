Coordinates = zeros(5, 4);
for j = 1:1
    for i = 5*(j-1)+1:5*(j-1)+5
        %path = sprintf('../Processed/Blue_images_rotated_cropped/Sonorine_%03d/sonorine_%03d_000.tiff', i, i);
        path = sprintf('../Processed/Masked3/Sonorine_%03d/sonorine_%03d_000.png', i, i);
        im000_matrix = imread(path);
        imshow(im000_matrix);

        rect1 = getrect;
        %rect2 = getrect;

        xmin = rect1(1);
        ymin = rect1(2);
        width = rect1(3);
        height = rect1(4);
        %Coordinates(2*(i-1)+1, :) = [xmin, ymin, width, height];
        Coordinates(i, :) = [xmin, ymin, width, height];
%{
        xmin = rect2(1);
        ymin = rect2(2);
        width = rect2(3);
        height = rect2(4);
        Coordinates(2*(i-1)+2, :) = [xmin, ymin, width, height];
%}
        %im000_cropped = im000_matrix(ymin:ymin+height, xmin:xmin+width);
        %imwrite(im000_cropped, 'Processed/Blue_images_cropped/Sonorine_001/sonorine_001_000.tiff');
    end
    name = sprintf('CoordinatesForAlignment/croppedImageMatrix_%d.mat', j);
    save(name, 'Coordinates');
end