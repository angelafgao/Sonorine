% used to find the calibration of the Canon LIDE 220 scanner

function [l_norm, Is, normals] = calibration()
    heights = [2, 3, 1.2]/2.54; % in inches
    directions = [[-1, 0, -1]; [0, -1, -1]; [1, 0, -1]; [0, 1, -1]];
    
    % needed to load the image 
    direction_dir = ['-x/', '-y/', '+x/', '+y/'];
    height_dir = ['2_cm.jpg', '3_cm.jpg', '11_mm.jpg'];   
    path = '../../Calibration_images/Cropped/';

    sizes = 3;
    x = 4*sizes;
    light = zeros(x, 3);
    normals = zeros(x, 3);
    Is = zeros(x, 1);

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
            
            % get dimensions and measurements of the image
            height = heights(j);
            long_edge = max(size(image));
            short_edge = min(size(image));
            
            % get the intensity along a line
            data = image(floor(long_edge/3):floor(long_edge*2/3), ...
            short_edge - 50);
            I = ((mean(data))/255*2) - 1;
            
            % get the normal vector of the image and store normals and
            % intensities
            n = get_normal(dir, short_edge, height);
            normals((i-1)*sizes + j, :) = n;
            Is((i-1)*sizes + j) = I;
            
            % calculate the light vector
            l = get_light(n, I); 
            light((i-1)*sizes + j, :) = l;
        end
    end

    Y = light(:, 3);
    X = ones(x, 2);
    X(:, 2) = light(:, 2);
    B = X\Y;
    b0 = double(B(1));
    b1 = double(B(2));

    eps = 0.00001;
    x = 0:eps:1;
    y1 = vpa(b1*x + b0); % line of best fit
    y2 = vpa(sqrt(1-x.^2)); % constraint of unit vector
   
    %// Find point of intersection
    x_intersection_values = find(abs(y1 - y2) < 0.000005, 2);
    x_avg = sum(x_intersection_values)/2*eps;
    l_calc = [0, x_avg, b1*x_avg + b0];
    l_norm = l_calc./norm(l_calc);
    
    figure
    scatter(X(:, 2), Y);
    hold on
    plot(x, y1);
    hold on
    plot(x, y2);
    
    
end
