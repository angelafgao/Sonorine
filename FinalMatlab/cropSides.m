path = '../Processed/Stretched/Sonorine_%03d/sonorine_%03d_%03d.tiff';
for i = 1:20
    im0 = imread(sprintf(path, i, i, 0));
    im180 = imread(sprintf(path, i, i, 180));
    new_im0 = im0(1: size(im0, 1), 16:size(im0, 2)-14);
    new_im180 = im180(1: size(im180, 1), 16:size(im180, 2)-14);
    imwrite(new_im0, sprintf(path, i, i, 0));
    imwrite(new_im180, sprintf(path, i, i, 180));
end