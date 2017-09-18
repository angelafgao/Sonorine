function [X, Y, Z, r] = get_overlay(cx, cy, r1, r2, s) % create mask
    weight_out = 1;
    weight_in = 10^(-2);
    buffer = round(s(1)*0.01);
    r = r1+buffer*2;
    [X, Y] = meshgrid(cx-r:cx+r, cy-r:cy+r);
    Z = ones(2*r+1);
    Z = Z*weight_in;
    Z(((X-cx).^2 + (Y-cy).^2).^0.5 >= r1+buffer )= weight_out;
    Z(((X-cx).^2 + (Y-cy).^2).^0.5 <= r2-buffer )= weight_out;
end
