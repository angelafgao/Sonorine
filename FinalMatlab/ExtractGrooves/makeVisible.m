img = 3;
load(sprintf('../../Processed2/Height_map/sonorine_%03d.mat', img));
minimum = min(min(height_map));
height_map = height_map - minimum;
maximum = max(max(height_map));
height_map = height_map/maximum;
imwrite(height_map, sprintf('../visibleHeightMap%03d.png', img));