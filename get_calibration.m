[l_norm, Is, normals, x, k] = calibration();
measured = zeros(1, 11);
calculated = zeros(1, x);

for i = 1:x
    n = normals(i, :);
    n = n';
    measured(i) = 255/2 * (Is(i) + 1);
    c = k * dot(l_norm, n);  
    calculated(i) = (c + 1)  * 255/2;
end

error = measured - calculated;
