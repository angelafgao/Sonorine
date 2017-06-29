%{
[X, Y] = meshgrid(-2:0.5:2, -2:0.5:2);
Z = get_value(X, Y, true);
[nx, ny, nz] = surfnorm(X, Y, Z);
%}

filename = 'Normal_Map/sonorine_001.mat';
m = matfile(filename);
normal_map = m.normal_map;
s = size(normal_map);
[X, Y] = meshgrid(1:s(1), 1:s(2));

nx = normal_map(:, :, 1);
ny = normal_map(:, :, 2);
nz = normal_map(:, :, 3);
L = sqrt(nx.^2 + ny.^2 + nz.^2);
U = nx./L;
V = ny./L;
W = nz./L ;

fprintf('got map');

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

A = sparse(3*total, 3*total);
b = sparse(3*total, 1);

eps = 0.5;

for i = 0:num_rows-1
    for j = 1:num_cols
        x = i*num_cols + j;
        y = x + total;
        cons = x + 2*total;
        b(x) = U(i+1,j);
        b(y) = V(i+1, j);
        %B(cons) = 0;
        A(cons, x) = eps;
        if is_edge(num_rows, num_cols, i, j) == false
            A(x, x-1) = 2/8;
            A(x, x+1) = -2/8;
            A(x, x-num_cols-1) = 1/8;
            A(x, x+num_cols-1) = 1/8;
            A(x, x-num_cols+1) = -1/8;
            A(x, x+num_cols+1) = -1/8;
            
            A(y, x-num_cols) = 2/8;
            A(y, x+num_cols) = -2/8;
            A(y, x-num_cols-1) = 1/8;
            A(y, x-num_cols+1) = 1/8;
            A(y, x+num_cols-1) = -1/8;
            A(y, x+num_cols+1) = -1/8;
           
        end
    end
end

fprintf('made A');
x = cgls(A, b); % use an iterative method linear least squares, conjugate gradient
%x = lsqnonneg(A,b);
fprintf('got least squares ');
x = x(1:total);
filename = sprintf('Height_Map/sonorine_%03d.mat', i);
save(filename, 'x');
height_map = vec2mat(x, num_cols);

%figure
%quiver3(X, Y, Z, U, V, W)
%hold on
%subplot(1,2,2)

figure
surf(X, Y, height_map)

figure
%subplot(1,2,1)
%pcolor(X, Y, Z);
%subplot(1,2,2)
pcolor(X, Y, height_map)
