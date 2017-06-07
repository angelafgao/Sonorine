range = 500;
l = zeros(range,1);
for i = 1:range
    x = (range/2-i)/10;
    w = 37/2*(abs(sind(x)) + abs(cosd(x))); 
    h = 25/2*(abs(sind(x)) + abs(cosd(x)));
    a = atand(w/h);
    b = atand((h-2)/w);
    new_angle = 90-a-b;
    l(i) = x- (90-a-b);
end
l = l-1;
l = abs(l);
minimum = min(l);
i = find(minimum==l)
angle = (range/2-i)/10
