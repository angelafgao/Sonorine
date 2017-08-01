%{
[X, Y] = meshgrid(-2:0.5:2, -2:0.5:2);
Z = get_value(X, Y, true);
[nx, ny, nz] = surfnorm(X, Y, Z);
%}

filename = '../Normal_Map/sonorine_001.mat';
m = matfile(filename);
normal_map = m.normal_map;
s = size(normal_map);
h = s(1);
w = s(2);
c = 5699;
start_h = floor((h-c)/2);
start_w = floor((w-c)/2);
[X, Y] = meshgrid(1:c+1, 1:c+1);

nx = normal_map(start_h:start_h+c, start_w:start_w+c, 1);
ny = normal_map(start_h:start_h+c, start_w:start_w+c, 2);
nz = normal_map(start_h:start_h+c, start_w:start_w+c, 3);
L = sqrt(nx.^2 + ny.^2 + nz.^2);
U = nx./L;
V = ny./L;
W = nz./L ;

fprintf('got map \n');

eps = 1e-6;
%{
%figure
%quiver3(X, Y, Z, U, V, W)
%hold on
figure
subplot(1,2,1)
surf(X, Y, Z)
%}

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

filename = '../Height_Map/sonorine_001_e-6.mat';
save(filename, 'height_map');

figure
surf(X, Y, height_map, 'EdgeColor', 'none');

figure
h = pcolor(X, Y, height_map);
set(h, 'edgecolor', 'none');
