[l_norm, Is, normals] = calibration();
measured = zeros(1, 11);
calculated = zeros(1, 11);

for i = 1:12
    n = normals(i, :);
    n = n';
    measured(i) = 255/2 * (Is(i) + 1);
    norm(n)
    norm(l_norm)
    c = abs(dot(l_norm, n));  
    calculated(i) = (c + 1)  * 255/2;
end

error = measured - calculated;