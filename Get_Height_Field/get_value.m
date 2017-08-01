function Z = get_value(X, Y, add_noise)
    cx = 4735;
    cy = 3093;
    r1 = 1686;
    r2 = 2687;
    %Z = (sin(((X-cx).^2 + (Y-cy).^2)*10))+1;
    Z = ones(size(X));
    Z(((X-cx).^2 + (Y-cy).^2).^0.5 >= r2 )= 0;
    Z(((X-cx).^2 + (Y-cy).^2).^0.5 <= r1 )= 1/3000;
    if add_noise == true
        Z  = awgn(Z, 100);
    end
end
