load('HeightMap.mat');
load('points.mat');
relative_heights = zeros([size(points, 1), 1]);
height_matrix = zeros([size(points, 1), 1]);
center = [2772, 2755];
angle = 0;
perp_search = 15;
accuracy = 10;

for i = 1:size(points, 1)
    curr_point = points(i, :);
    angle = atand((center(1) - curr_point(1))/(curr_point(2) - center(2)));
    perp_heights = zeros([2*perp_search+1, 1]);
    for j = 0:2*perp_search
        y = round(curr_point(1) - sind(angle)*(j - perp_search));
        x = round(curr_point(2) + cosd(angle)*(j - perp_search));
        perp_heights(j+1) = height_map(y, x);
    end
    %p = polyfit(linspace(1, 2*perp_search+1, 2*perp_search+1)', perp_heights, 2);
    %height_matrix(i) = -8 * p(1);
    height_matrix(i) = min(perp_heights);
    %plot(linspace(1, 2*perp_search+1, 2*perp_search+1), perp_heights);
end

gaussFilter = gausswin(64);
gaussFilter = gaussFilter / sum(gaussFilter);
smoothedVector = conv(height_matrix, gaussFilter, 'same');
shiftedHeights = height_matrix - smoothedVector;
shiftedHeights = shiftedHeights';
invertedHeights = fliplr(shiftedHeights);
audiowrite('test1.wav', invertedHeights, 1080*accuracy);