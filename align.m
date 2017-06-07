% initialize translation variables
fileID = fopen('translations.txt', 'w');
fprintf(fileID, 'Sonorine      Angle %6s %6s %6s\n', 'x', 'y', 'rot');
for i = 1:120   % Loop on the number of sonorines
    for j = 1:3 % Loop on the different angle images for each sonorine
        trans_x = 0;
        trans_y = 0;
        rotation = 0;
        for level = 1:8 % Loop on each level of downsampling
            level_name = 9-level;
            path = sprintf('../Processed/Down%d/', level_name);
            img1_path = sprintf('Sonorine_%03d/sonorine_%03d_000_down%d.tiff', 1, 1, level_name);
            img2_path = sprintf('Sonorine_%03d/sonorine_%03d_%03d_down%d.tiff', 1, 1, 90*j, level_name);

            img1 = imread(strcat(path, img1_path));
            img2 = imread(strcat(path, img2_path));
            % Pad image if necessary
            [img1, img2] = padImage(img1, img2);
            
            % translate inner region and calculate error using sum of absolute
            % differences
            [trans_x, trans_y, rotation] = calculateTranslationRotation(trans_x, trans_y, rotation, img1, img2, level);
            trans_x = trans_x*2;
            trans_y = trans_y*2;
        end
        % Save the result of each image pair to translations.txt
        fprintf(fileID, '%8d        %03d %6d %6d %6d\n', i, 90*j, trans_x, trans_y, rotation);
    end
    fprintf(fileID, '\n');
end
fclose(fileID);