%iterates over all of the sonorines
%downsamples from the blue layer of the orignal raw data
%downsampled image is 1/4 the size of the original image
%downsamples all 4 images of the different angles of the sonorines
%saves the downsampled image into a new directory under processed data and 
%in the Down1 folder

for i = 1:2 % iterates over all sonorines
    step = 2;
    
    img000 = imread(sprintf(...
        './Processed/Blue_images_cropped/Sonorine_%03d/sonorine_%03d_000.tiff', i, i));
    % gets dimensions of future downsampled image
    s = size(img000);
    w_raw = s(1);
    h_raw = s(2);
    w = fix(w_raw/step);
    h = fix(h_raw/step);
    m1 = single(max(max(img000)));
    img000_down = zeros(w,h);
    % generates downsampled image
    for j = 1:w
        for k = 1:h
            h_block = j*2;
            v_block = k*2;

            pt1 = single(img000(h_block-1,v_block-1));
            pt2 = single(img000(h_block-1,v_block));
            pt3 = single(img000(h_block,v_block-1));
            pt4 = single(img000(h_block,v_block));

            img000_down(j, k) = pt1/4/m1+pt2/4/m1+pt3/4/m1+pt4/4/m1;
        end
    end 
    
    img090 = imread(sprintf(...
        './Processed/Blue_images_cropped/Sonorine_%03d/sonorine_%03d_090.tiff', i, i));
    % gets dimensions of future downsampled image
    s = size(img090);
    w_raw = s(1);
    h_raw = s(2);
    w = fix(w_raw/step);
    h = fix(h_raw/step);
    m2 = single(max(max(img090)));
    img090_down = zeros(w,h);
    % generates downsampled image
    for j = 1:w
        for k = 1:h
            h_block = j*2;
            v_block = k*2;

            pt1 = single(img090(h_block-1,v_block-1));
            pt2 = single(img090(h_block-1,v_block));
            pt3 = single(img090(h_block,v_block-1));
            pt4 = single(img090(h_block,v_block));
            
            img090_down(j, k) = pt1/4/m3+pt2/4/m3+pt3/4/m3+pt4/4/m3;
        end
    end
    
    img180 = imread(sprintf(...
        './Processed/Blue_images_cropped/Sonorine_%03d/sonorine_%03d_180.tiff', i, i));
    % gets dimensions of future downsampled image
    s = size(img180);
    w_raw = s(1);
    h_raw = s(2);
    w = fix(w_raw/step);
    h = fix(h_raw/step);
    m3 = single(max(max(img180)));
    img180_down = zeros(w,h);
    % generates downsampled image
    for j = 1:w
        for k = 1:h
            h_block = j*2;
            v_block = k*2;

            pt1 = single(img180(h_block-1,v_block-1));
            pt2 = single(img180(h_block-1,v_block));
            pt3 = single(img180(h_block,v_block-1));
            pt4 = single(img180(h_block,v_block));

            img180_down(j, k) = pt1/4/m3+pt2/4/m3+pt3/4/m3+pt4/4/m3;
        end
    end
    
    img270 = imread(sprintf(...
        './Processed/Blue_images_cropped/Sonorine_%03d/sonorine_%03d_270.tiff', i, i));
    % gets dimensions of future downsampled image
    s = size(img270);
    w_raw = s(1);
    h_raw = s(2);
    w = fix(w_raw/step);
    h = fix(h_raw/step);
    m4 = single(max(max(img270)));
    img270_down = zeros(w,h);
    % generates downsampled image
    for j = 1:w
        for k = 1:h
            h_block = j*2;
            v_block = k*2;

            pt1 = single(img270(h_block-1,v_block-1));
            pt2 = single(img270(h_block-1,v_block));
            pt3 = single(img270(h_block,v_block-1));
            pt4 = single(img270(h_block,v_block));

            img270_down(j, k) = pt1/4/m4+pt2/4/m4+pt3/4/m4+pt4/4/m4;
        end
    end
    
    % creates new image files
    imwrite(img000_down, ...
        sprintf('./Processed/Uncropped_downsampled/Down1/Sonorine_%03d/sonorine_%03d_000.tiff', i, i));
    imwrite(img090_down, ...
        sprintf('./Processed/Uncropped_downsampled/Down1/Sonorine_%03d/sonorine_%03d_090.tiff', i, i));
    imwrite(img180_down, ...
        sprintf('./Processed/Uncropped_downsampled/Down1/Sonorine_%03d/sonorine_%03d_180.tiff', i, i));
    imwrite(img270_down, ...
        sprintf('./Processed/Uncropped_downsampled/Down1/Sonorine_%03d/sonorine_%03d_270.tiff', i, i));

end             
                    