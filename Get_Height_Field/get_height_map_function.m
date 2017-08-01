[X, Y] = meshgrid(1:6330/2, 1:9404/2);
Z = get_value(X, Y, false);
[nx, ny, nz] = surfnorm(X, Y, Z);

eps = 0.5;
L = sqrt(nx.^2 + ny.^2 + nz.^2);
U = nx./L;
V = ny./L;
W = nz./L ;

fprintf('got map \n');

figure
surf(X, Y, Z, 'EdgeColor', 'none')

s = size(X);
num_rows = s(1);
num_cols = s(2);
total = num_rows*num_cols;
b = zeros(3*total, 1);

b(1:total) = reshape(U', total, 1); % fill top of b with n_x
b(total+1:total*2) = reshape(V', total, 1); % fill middle of b with n_y

A = fill_matrix2(num_cols, num_rows, eps);

fprintf('made A\n');
x = cgls(A, b); % use an iterative method linear least squares, conjugate gradient

fprintf('got least squares \n');
x = x(1:total);
height_map = reshape(x, s);
height_map = height_map';
filename = '../Height_Map/test.m';
save(filename, 'height_map');

figure
surf(X, Y, height_map, 'EdgeColor', 'none')