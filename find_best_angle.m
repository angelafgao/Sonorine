function angle = find_best_angle(w, h)
    range = 500;
    l = zeros(range,1);
    for i = 1:range
        x = (range/2-i)/10;
        w_rot = w/2*(abs(sind(x)) + abs(cosd(x))); 
        h_rot = h/2*(abs(sind(x)) + abs(cosd(x)));
        a = atand(w_rot/h_rot);
        b = atand((h_rot-2)/w_rot);
        new_angle = 90-a-b;
        l(i) = x - new_angle;
    end
    l = l-1;
    l = abs(l);
    minimum = min(l);
    i = find(minimum==l);
    angle = (range/2-i)/10;
end
