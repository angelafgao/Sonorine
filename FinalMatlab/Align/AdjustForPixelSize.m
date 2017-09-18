%{
    This function stretches the 0 and 180 degree scans along the width
    and the 90 and 270 degree scans along the height because the scanner
    was not well calibrated. Basically, the camera slid at a different 
    speed vertically as compared to horizontally
%}

% stretch 000 and 180
scale = 1.0034;
for i = 1:120
    source_path = '../../Processed2/Original/Sonorine_%03d/sonorine_%03d_%03d.tiff';
    dest_path = '../../Processed2/Stretched/Sonorine_%03d/sonorine_%03d_%03d.tiff';
    %dest_path2 = '../../Processed/Stretched2_cropped/Sonorine_%03d/sonorine_%03d_%03d.tiff';
    x_length = 9600;
    y_length = 6500;
    for j = 0:1
        image = imread(sprintf(source_path, i, i, j*180));
        s = size(image);
        height = s(1);
        width = s(2);

        width_new = width*scale;

        im_new = imresize(image, [height, width_new],'bilinear');
        im_new = cropRotate(im_new, x_length, y_length);
        imwrite(im_new, sprintf(dest_path, i, i, j*180));
    end
    for k = 0:1
        image = imread(sprintf(source_path, i, i, 180*k+90));
        s = size(image);
        height = s(1);
        width = s(2);
        
        height_new = height*scale;
        
        im_new = imresize(image, [height_new, width],'bilinear');
        im_new = cropRotate(im_new, x_length, y_length);
        imwrite(im_new, sprintf(dest_path, i, i, 180*k+90));
    end
    %{
    for l = 0:3
        image = imread(sprintf(dest_path, i, i, l*90));
        im_new = image(301:301+5649, 351:351+8799);
        imwrite(im_new, sprintf(dest_path2, i, i, l*90));
    end
    %}
end