%{
    Takes in the masked scans(Increased contrast to remove grooves and 
    highlight features) and calculates the translations and rotations
    required to align them.
%}

% initialize translation variables
Translations = zeros([360, 3]);
for i = 1:120   % Loop on the number of sonorines
    for j = 1:3 % Loop on the different angle images for each sonorine
        trans_x = 0;
        trans_y = 0;
        rotation = 0;
        %scale = 1;
        for level = 1:8 % Loop on each level of downsampling
            level_name = 9-level;
            path = sprintf('../../Processed2/Downsampled/Down%d/', level_name);
            img1_path = sprintf('Sonorine_%03d/sonorine_%03d_000.png', i, i);
            img2_path = sprintf('Sonorine_%03d/sonorine_%03d_%03d.png', i, i, 90*j);
            
            img1 = imread(strcat(path, img1_path));
            img2 = imread(strcat(path, img2_path));
            % Pad image if necessary
            [img1, img2] = padImage(img1, img2);
            
            [trans_x, trans_y, rotation, min_error] = calculateTranslationRotation(trans_x, trans_y, rotation, img1, img2, level);
            trans_x = trans_x*2;
            trans_y = trans_y*2;
        end
        % Save the result of each image pair to translations.txt
        %Translations((i-1)*3  + j, :) = [trans_x, trans_y, rotation, scale];
        Translations((i-1)*3  + j, :) = [trans_x, trans_y, rotation];
    end
    fprintf('Done with sonorine %d\n', i);
end

FinalMatrix = zeros([360, 3]);

for i = 1:120   % Loop on the number of sonorines
    path = '../../Processed2/Masked/';
    img1_path = sprintf('Sonorine_%03d/sonorine_%03d_000.png', i, i);
    img1 = imread(strcat(path, img1_path));
    for j = 1:3 % Loop on the different angle images for each sonorine
        trans_x = Translations((i-1)*3 + j, 1);
        trans_y = Translations((i-1)*3 + j, 2);
        rotation = Translations((i-1)*3 + j, 3);
       
        img2_path = sprintf('Sonorine_%03d/sonorine_%03d_%03d.png', i, i, 90*j);
        img2 = imread(strcat(path, img2_path));
        
        % Pad image if necessary
        [img1, img2] = padImage(img1, img2);

        % translate inner region and calculate error using sum of absolute
        % differences
        [trans_x, trans_y, rotation] = calculateTranslationRotation(trans_x, trans_y, rotation, img1, img2, 9);
        % Save the result of each image pair
        FinalMatrix((i-1)*3+j, :) = [trans_x, trans_y, rotation];
    end
    fprintf('Done with sonorine %d\n', i);
end

save('../TranslationMatrices/finalTranslationMatrixStretched.mat', 'FinalMatrix');