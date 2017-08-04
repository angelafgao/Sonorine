import numpy as np
import scipy.misc as misc
import scipy
import math
import imageio

# load raw images from disk
# argument: the sonorine number
# return value: 3D matrix, each 2D layer containing a raw rotated image with 
# dims h x w x 4
def get_raw_images(sonorine_num):
    # load 4 rotations of sonorine
    for i in range(0, 4):
        path = 'Raw/Sonorine_%03d/sonorine_%03d_%03d.tiff' % (sonorine_num, 
            sonorine_num, i*90)
        im = imageio.imread(path)
        s = im.shape
        h = s[0]
        w = s[1]
        if i == 0:
            im_raw = np.zeros((h, w, 4))
        im_raw[:, :, i] = im[:, :, 2]
    return im_raw

# get rough cropped images
# argument: 3D matrix, each 2D layer containing raw rotated image with dims
# h x w x 4
# return value: 3D matrix, each 2D layer containing cropped and rotated image
# with dims h_new x w_new x 4
def get_cropped_rotated_images(im_raw):
    pass

# down sample images
# argument: 1 set of sonorine images with dims h x w
# return value: 1 set of sonorine images with dims h/2 x w/2
def get_downsampled_images(images):
    step = 2
    s = images.shape
    h = s[0]
    w = s[1]
    h_new = math.floor(h/step)
    w_new = math.floor(w/step)
    im_down = np.zeros((h_new, w_new, 4))
    for i in range(0, h_new):
        for j in range(0, w_new):
            h_block = i*2
            w_block = j*2
            for k in range(0,4):
                im_down[i, j, k] = np.sum(images[h_block:h_block+2, 
                    w_block:w_block+2, k])/4
    return im_down

# get alignment of images
# argument: cropped and rotated images h x w x 4
# return value: aligned images with dims h_new x w_new x 4
def get_aligned_images_wrapper(im_cropped):
    im_down1 = get_downsampled_images(im_cropped)
    im_down2 = get_downsampled_images(im_down1)
    im_down3 = get_downsampled_images(im_down2)
    im_down4 = get_downsampled_images(im_down3)
    im_down5 = get_downsampled_images(im_down4)
    im_down6 = get_downsampled_images(im_down5)
    im_down7 = get_downsampled_images(im_down6)


# get aligned images
def align_images(images, alignment):
    pass

# get light vector

# get normal map
# argument: aligned images with dims h x w x 4
# return value: normal map with dims h x w x 3
def get_normal_map(images):
    s = images.shape
    normal_map = np.zeros((s(0), s(1), 3))
    l = [0.1329, , 3]
    lx = l[0]
    ly = l[1]
    lz = l[2]
    I1 = images[:, :, 0]
    I2 = images[:, :, 1]
    I3 = images[:, :, 2]
    I4 = images[:, :, 3]

    # use least squares to solve for normal map
    A = [[lx, ly, lz], 
        [-ly, lx, lz], 
        [-lx, -ly, lz], 
        [ly, -lx, lz]]
    b = [I1, I2, I3, I4]
    x = linalg.lstsq(A,b) 
    return normal_map

# get height field
# argument: normal map with dims h x w x 3
# return value: height field with dims h x w
def get_height_field(normal_map):
    return height_field

# get radial blur

# get groove

# blur height field

# get sound

# blur sound

# filtering

# main
def main(sonorine_num):
    #im_raw = get_raw_images(sonorine_num)
    im_raw = im_raw = np.zeros((10, 10, 4))
    grid = np.mgrid[0:10, 0:10]
    X = grid[1]

    im_raw[:, :, 0] = X
    im_raw[:, :, 1] = X
    im_raw[:, :, 2] = X
    im_raw[:, :, 3] = X
    print(im_raw)
    im_cropped = im_raw
    # im_cropped = get_cropped_rotated_images(im_raw)
    im_aligned = get_aligned_images_wrapper(im_cropped)
    # normal_map = get_normal_map(im_aligned)
    # height_field = get_height_field(normal_map)
    # sound = get_grooves(height_field)
