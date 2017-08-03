import numpy as np
import scipy.misc as misc
import scipy


# load raw images from disk
# argument: the sonorine number
# return value: 3D matrix, each 2D layer containing a raw rotated image
def get_raw_images(sonorine_num):
    # load 4 rotations of sonorine
    for i in range(0, 4):
        path = 'Raw/Sonorine_%03d/sonorine_%03d_%03d.tiff' % (sonorine_num, 
            sonorine_num, i*90)
        im = misc.imread(path)
        s = im.shape
        h = s[0]
        w = s[1]
        if i == 0:
            im_raw = np.zeros([h, w, 4])
        im_raw[:, :, i] = im[:, :, 3]
    return im_raw

# get rough cropped images
# argument: 3D matrix, each 2D layer containing raw rotated image
# return value: 3D matrix, each 2D layer containing cropped and rotated image
def get_cropped_rotated_images(im_raw):
    pass

# down sample images
def get_downsampled_images(im_cropped):
    return im_down

# get alignment of images
def get_aligned_images_wrapper(im_downsampled):
    im_down1 = get_downsampled_images(im_downsampled)
    im_down2 = get_downsampled_images(im_down1)
    im_down3 = get_downsampled_images(im_down2)
    im_down4 = get_downsampled_images(im_down3)
    im_down5 = get_downsampled_images(im_down4)
    im_down6 = get_downsampled_images(im_down5)
    im_down7 = get_downsampled_images(im_down6)


# get aligned images

# get light vector

# get normal map

# conjugate gradient algorithm

# get height field

# get radial blur

# get groove

# blur height field

# get sound

# blur sound

# filtering

# main
def main(sonorine_num):
    im_raw = get_raw_images(sonorine_num)
    #im_cropped = get_cropped_rotated_images(im_raw)
    #im_aligned = get_aligned_images_wrapper(im_cropped)
