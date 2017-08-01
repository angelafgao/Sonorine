for i = 4:4
    filename = sprintf('../../Normal_Map/sonorine_%03d.mat', i);
    path = sprintf('../../Processed/Aligned2/Sonorine_%03d/sonorine_%03d_000.tiff', i, i);
    m = matfile(filename);
    normal_map = m.normal_map;
    Z = gui_all(path);
    
    nx = normal_map(:, :, 1);
    ny = normal_map(:, :, 2);
    nz = normal_map(:, :, 3);
    L = sqrt(nx.^2 + ny.^2 + nz.^2);
    U = nx./L;
    V = ny./L;
    
    s = size(Z);
    num_rows = s(1);
    num_cols = s(2);
    total = num_rows*num_cols;
    b = zeros(3*total, 1);

    b(1:total) = reshape(U', total, 1); % fill top of b with n_x
    b(total+1:total*2) = reshape(V', total, 1); % fill middle of b with n_y

    A = fill_matrix_lin_all(num_cols, num_rows, Z);
    tol = 1e-6;
    iter = 160;
    
    fprintf('made A\n');
    [x,FLAG,RESNE,ITER] = cgls(A, b, 0, tol, iter); % use an iterative method linear least squares, conjugate gradient

    fprintf('got least squares \n');
    x = x(1:total);
    height_map = reshape(x, [s(2) s(1)]);
    height_map = height_map';
    
    figure
    imshow((height_map + abs(min(min(height_map))))/ (max(max(height_map)) - min(min(height_map))));
    
    filename = sprintf('../../Height_Map/sonorine_%03d.mat', i);
    save(filename, 'height_map');
end