function I = get_intensity(image, short_edge, long_edge, dir)
    if (dir(1) == -1)
        data = image(floor(long_edge/3):floor(long_edge*2/3), ...
        short_edge - 40);
    elseif (dir(2) == -1) 
        data = image(short_edge - 40, ...
            floor(long_edge/3):floor(long_edge*2/3));
    elseif (dir(1) == 1) 
        data = image(floor(long_edge/3):floor(long_edge*2/3), ...
        40);
    elseif (dir(2) == 1)
        data = image(40, floor(long_edge/3):floor(long_edge*2/3));
    end
    I = ((mean(data))/255*2) - 1;
end
