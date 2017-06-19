function l_norm = get_light(n, I)
    nCell = num2cell(n);
    [n_x, n_y, n_z] = nCell{:};
    
    p = [n_y^2 + n_z^2, -I*n_y, I^2 - n_z^2];
    r = roots(p);
    
    y = max(r);
    l = [0, y, sqrt(1-y.^2)];
    l_norm = l./norm(l);
end