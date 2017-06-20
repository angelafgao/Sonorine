% used to find the calibration of the Canon LIDE 220 scanner

function [l_norm, Is, normals, x, k] = calibration()
    
    heights = [0.8710, 1.175, 0.6230]; % in inches
    directions = [[-1, 0, -1]; [0, -1, -1]; [1, 0, -1]; [0, 1, -1]];
    
    % needed to load the image 
    direction_dir = ['-x/', '-y/', '+x/', '+y/'];
    height_dir = ['2_cm.jpg', '3_cm.jpg', '11_mm.jpg'];   
    path = '../../../Calibration_images/Cropped/';

    sizes = 3;
    x = 4*sizes;
    normals = zeros(x, 3);
    Is = zeros(x, 1);
    
    k = get_baseline();

    % iterates over all possible directions 
    for i = 1:4
        dir = directions(i, :);
        path_direction_dir = strcat(path, ...
            direction_dir((i-1)*3 + 1:(i-1)*3 + 3));
        % iterates over all of the possible heights of the cards
        for j = 1:sizes
            
            % get the path to get the image
            curr_path = strcat(path_direction_dir, ...
            height_dir((j-1)*8 + 1:((j-1)*8 + 8 + floor((j-1)/2))));
            image = imread(curr_path);
            image = image(:, :, 3);
            
            % get height for triangle
            height = heights(j);
            
            % get the intensity along a line
            long_edge = max(size(image));
            short_edge = min(size(image));
            I = get_intensity(image, short_edge, long_edge, dir);
            
            % get the normal vector of the image and store normals and
            % intensities
            n = get_normal(dir, short_edge, height);
            normals((i-1)*sizes + j, :) = n;
            Is((i-1)*sizes + j) = I;
        end
    end
    
    l_brute = get_light_brute(normals, Is, x, k);
    l_norm = l_brute./norm(l_brute);
end
