function l_brute = get_light_brute(normals, Is, x, k)
    errors = zeros(12, 2001);
    data = zeros(3, 2001);
    for i = 1:2001
        l_y = (i - 1001)/1000;
        l = [0, l_y, -(1-(l_y^2))^0.5];
        for j = 1:x
            c = k*dot(normals(j, :), l);
            I_calc = (c + 1)  * 255/2;
            I = 255/2 * (Is(j) + 1);
            diff = I - I_calc;
            errors(j, i) = diff;
        end
        data(1, i) = mean(errors(:, i));
        errors = abs(errors);
        data(2, i) = mean(errors(:, i));
        data(3, i) = std(errors(:, i));
    end
    [~, min_index] = min(data(2, :));
    l_y = (min_index - 1001)/1000;
    l_brute = [0, l_y, -(1-l_y^2)^0.5 ];
    
    X = -1:0.001:1;
    Y = -(1-X.^2).^0.5;
    Z = data(2, :);
    plot3(X, Y, Z)
end