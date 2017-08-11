% set paths 
source = '../../Processed/Roughly_aligned/';
dest = '../../Processed/Aligned/';
folder = 'Sonorine_%03d/sonorine_%03d_%03d.tiff';
source_path = strcat(source, folder);
dest_path = strcat(dest, folder);

% extract rotation and translation data for Down1 matrix
rot_trans_struct = load('../TranslationMatrices/finalTranslationMatrixStretched1.mat');
rot_trans = rot_trans_struct.FinalMatrix;

%trans_info= zeros(3, 2); % load translation and rotation data
%temp_images = zeros(h, w, 4); % store temporarily translated images

% iterate over all of the sonorines
% rotate and crop all images for each sonorine so that they are 
% all the same size and same alignment    
for i = 1:5
    % get reference image 000 and save to temp_images
    temp_pic_000 = imread(sprintf(source_path, i, i, 0));
    w = size(temp_pic_000, 2);
    h = size(temp_pic_000, 1);
    trans_info= zeros(2, 4); % load translation and rotation data
    temp_images = zeros(h, w, 4); % store temporarily translated images
    
    temp_images(:, :, 1) = temp_pic_000;
    trans_info(1, 1) = 0;
    trans_info(2, 1) = 0;
    % rotate 0, 90, 180, 270 images
    for j = 1:3
        im = imread(sprintf(source_path, i, i, 90*j));
        % save translation data
        trans_info(1, j+1) = rot_trans((i-1)*3+j, 1);
        trans_info(2, j+1) = rot_trans((i-1)*3+j, 2);
        % rotate and save image into temp_images
        rot = rot_trans((i-1)*3+j, 3);
        im_rot = imrotate(im, rot);
        temp_images(:, :, j+1) = cropRotate(im_rot, w, h);
    end
    
    % align images
    aligned_images = align_images(w, h, temp_images, trans_info);
    
    % write aligned images into the final file
    for rot = 1:4
        bit16_im = uint16(aligned_images(:, :, rot));
        imwrite(bit16_im, ...
            sprintf(dest_path, i, i, (rot-1)*90));
    end
    fprintf('Done with sonorine %d\n', i);
end