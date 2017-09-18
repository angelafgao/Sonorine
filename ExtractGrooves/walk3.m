%{
    % This script walks along the groove and stores many points along the
    groove. It uses the starting point and approximates the next point.
    Then it looks at the line perpendicular to its walking angle and fits a
    quadratic to the valley. Calculates the minimum of the valley and uses
    that as its actual second point. Calculates subsequent points
    similarly.
%}

% Initialize Everything, Convention: [row, col]
walk_distance = 27000; % Distance to walk along groove (In step sizes)
%step_size = 5; % Distance between each recorded point magnitude
step_angle = 0.5; % Distance between each recorded point angle
perp_search = 5; % Distance to search in perpendicular valley in each side
drdt = 0.06;
%center = [2782, 2778]; % Center of image
center = [2772, 2755];
first = [4121, 3712]; % First point in the groove
last = [2900, 43];
points = ones([walk_distance, 2]); % List of recorded points
points(1, :) = first; 
delta_matrix = zeros([walk_distance, 1]); % List of polynomial fitting error
delta_matrix(1) = 0; % Set first error to zero
p_matrix = zeros([walk_distance, 1]); % List of the second degree coefficients
correct = true;
correct_matrix = true([walk_distance, 1]);
reached_end = false;
accuracy = 10;
%height_matrix = zeros([walk_distance, 1]);
theta_matrix = zeros([walk_distance, 1]);
radius_matrix = zeros([walk_distance, 1]);
%visible = imread('../visibleHeightMap.png');
load('../../Height_map/Correct/sonorine_001.mat');

% Find distance between first and center
X = [center(2), center(1); first(2), first(1)];
theta = atand((center(1) - first(1))/(first(2) - center(2)));
radius = pdist(X, 'euclidean');

% get pixels on the perpendicular and figure out the minimum value, 
% which will be the valley of the groove
i = 1;
while ~reached_end
    %height_matrix(i) = height_map(first(1), first(2));
    theta_matrix(i) = theta;
    % approximate the next point
    X = [center(2), center(1); first(2), first(1)];
    new_radius = pdist(X, 'euclidean');
    radius_matrix(i) = new_radius;
    if correct
        radius = 0.8*radius + 0.2*new_radius;
        radius = radius + drdt;
    else
        radius = radius + drdt;
    end
    i = i + 1;
    theta = theta + step_angle;
    y = round(center(1) - radius * sind(theta));
    x = round(center(2) + radius * cosd(theta));
    calculated_second = [y, x];
    % Perpendicular angle is the angle between the center and the
    % calculated point
    [delta, p, y, x] = getDeepestPoint(height_map, theta, calculated_second);
    p_matrix(i) = p(1);
    delta_matrix(i) = delta;
    
    % If error for quadratic fitting is too high, approximate the next
    % point using the center and the radius
    
    correct = delta < 0.01 && p(1) > 0.0008;
    correct_matrix(i) = correct;
    if correct
        points(i, :) = [y, x];
    else
        points(i, :) = calculated_second;
    end
    
    first = points(i, :);
    if abs(first(1) - last(1)) < 15 && abs(first(2) - last(2)) < 15
        reached_end = true;
    end
end
size = i;

correct_matrix = correct_matrix(1:size);
theta_matrix = theta_matrix(1:size);
radius_matrix = radius_matrix(1:size);
points = points(1:size, :);
smoothed_radius = medfilt1(radius_matrix, 7);
gauss_filter = gausswin(5);
gauss_filter = gauss_filter / sum(gauss_filter);
smoothed_radius = conv(smoothed_radius, gauss_filter, 'same');

new_points = ones([size, 2]);
height_matrix = zeros([size, 1]);
for i = 1:size
    radius = smoothed_radius(i);
    theta = theta_matrix(i);
    y = round(center(1) - radius * sind(theta));
    x = round(center(2) + radius * cosd(theta));
    new_points(i, :) = [y, x];
    height_matrix(i) = height_map(y, x);
end

% Get points in between
between_points = ones([size*accuracy, 2]);
height_matrix = zeros([size*accuracy, 1]);
for i = 1:size
    theta = theta_matrix(i);
    radius = smoothed_radius(i);
    y = round(center(1) - radius * sind(theta));
    x = round(center(2) + radius * cosd(theta));
    between_points((i-1)*accuracy+1, :) = [y, x];
    for j = 1:accuracy-1
        theta = theta + 0.5/accuracy;
        y = round(center(1) - radius * sind(theta));
        x = round(center(2) + radius * cosd(theta));
        between_points((i-1)*accuracy+1 + j, :) = [y, x];
    end
end
%{
points = between_points;
save('points.mat', 'points');
save('HeightMap', 'height_map');
%}
for i = 1:size*accuracy
    height_matrix(i) = height_map(between_points(i, 1), between_points(i, 2));
end
%{
% Smooth the radius vector and obtain corresponding points and intensities
imshow(visible);
hold on;
for i = 1:size
    if correct_matrix(i) == true
        plot(points(i, 2), points(i, 1), 'b.', 'MarkerSize', 2);
    else
        plot(points(i, 2), points(i, 1), 'r.', 'MarkerSize', 2);
    end
end
%}
% Eliminate DC offset and convert frequency to audio
gaussFilter = gausswin(64);
gaussFilter = gaussFilter / sum(gaussFilter);
smoothedVector = conv(height_matrix, gaussFilter, 'same');
shiftedHeights = height_matrix - smoothedVector;
shiftedHeights = shiftedHeights';
invertedHeights = fliplr(shiftedHeights);
audiowrite('sound_4.wav', invertedHeights, 1080*accuracy);
