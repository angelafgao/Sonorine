im0 = imread('../Processed/Blue_images_rotated_cropped/Sonorine_001/sonorine_001_000.tiff');
im90 = imread('../Processed/Blue_images_rotated_cropped/Sonorine_001/sonorine_001_090.tiff');
imshow(im0);
coords0 = getrect();
imshow(im90);
coords90 = getrect();