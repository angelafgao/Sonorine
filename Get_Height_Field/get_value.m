function Z = get_value(X, Y, add_noise)
    Z = ((X.^2 + Y.^2)*10)/1000 + 1/1000;
    %Z((X.^2 + Y.^2) >= 2.5 )= 0;
    if add_noise == true
        Z  = awgn(Z, 100);
    end
end
