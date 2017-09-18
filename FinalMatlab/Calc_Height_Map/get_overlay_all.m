function Z = get_overlay_all(cx, cy, r1, r2, s) % create mask
    weight_out = 1;
    weight_in = 10^(-2);
    buffer = round(s(1)*0.01);
    [X, Y] = meshgrid(1:s(2), 1:s(1));
    Z = ones(s);
    Z = Z*weight_in;
    Z(((X-cx).^2 + (Y-cy).^2).^0.5 >= r1+buffer )= weight_out;
    Z(((X-cx).^2 + (Y-cy).^2).^0.5 <= r2-buffer )= weight_out;
end
