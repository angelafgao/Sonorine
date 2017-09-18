verticalPoints = zeros([3, 2]);
imshow('../visibleHeightMapLine.png');

for i = 1:3
    [x1, y1] = getpts();
    verticalPoints(i, :) = [x1, y1];
end