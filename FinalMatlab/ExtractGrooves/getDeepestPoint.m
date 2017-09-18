function [delta, p, y, x] = getDeepestPoint(height_map, angle, point)
    point_search = 9;
    perp_search = 5;
    list_points = zeros([2*point_search+1, 2]);
    info = zeros([2*point_search+1, 6]);
    for i = 0:2*point_search
        y = round(point(1) - sind(angle)*(i - point_search));
        x = round(point(2) + cosd(angle)*(i - point_search));
        list_points(i+1, :) = [y, x];
    end
    for i = 1:2*point_search+1
        curr_point = list_points(i, :);
        perp_intensities = zeros([2*perp_search+1, 1]);
        perp_points = zeros([2*perp_search+1, 2]);
        for j = 0:2*perp_search
            y = round(curr_point(1) - sind(angle)*(j - perp_search));
            x = round(curr_point(2) + cosd(angle)*(j - perp_search));
            perp_points(j+1, :) = [y, x];
            perp_intensities(j + 1, :) = height_map(y, x);
        end
        [p_temp, S] = polyfit(linspace(1, 2*perp_search+1, 2*perp_search+1)', perp_intensities, 2);
        [~, delta_temp] = polyval(p_temp, 1, S);
        min_index = round(-p_temp(2)/(2*p_temp(1)));
        if min_index < 1
            min_index = 1;
        elseif min_index > 11
            min_index = 11;
        end
        y = perp_points(min_index, 1);
        x = perp_points(min_index, 2);
        info(i, 1:3) = p_temp;
        info(i, 4) = delta_temp;
        info(i, 5:6) = [y, x];
    end
    [~, index] = max(info(:, 1));
    p = info(index, 1:3);
    delta = info(index, 4);
    y = info(index, 5);
    x = info(index, 6);
end

