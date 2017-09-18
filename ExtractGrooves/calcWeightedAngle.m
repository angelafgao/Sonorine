% Calculates the angle as a function of previous 10 angles
function [angle] = calcWeightedAngle(points, index)
    angle = 0;
    for i = -1:8
        angle = angle + 0.1*atand((points(index-i-1, 2)-points(index-i, 2))/(points(index-i, 1)-points(index-i-1, 1)));
    end
end

