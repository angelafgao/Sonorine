import numpy as np
import numpy.linalg
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
        if i == 0: # store images into a layer of the matrix
            im_raw = np.zeros((h, w, 4))
        im_raw[:, :, i] = im[:, :, 2]
    return im_raw

# get rough cropped images
# argument: 3D matrix, each 2D layer containing raw unrotated image with dims
# h x w x 4
# return value: 3D matrix, each 2D layer containing cropped and rotated image
# with dims h_new x w_new x 4
def get_cropped_rotated_images(im_raw):
    pass

# down sample images
# argument: 1 set of sonorine images with dims h x w
# return value: 1 set of sonorine images with dims floor(h/2) x floor(w/2)
def get_downsampled_images(images):
    # downsampled rate = set
    step = 2
    # get the dimensions of the images
    s = images.shape
    h = s[0]
    w = s[1]
    # get new dimensions of downsampled images
    h_new = math.floor(h/step)
    w_new = math.floor(w/step) 
    # create block in memory to store downsampled image
    im_down = np.zeros((h_new, w_new, 4))
    for i in range(0, h_new):
        for j in range(0, w_new):
            h_block = i*2
            w_block = j*2
            for k in range(0,4): 
                # calculate new downsampled image
                im_down[i, j, k] = np.sum(images[h_block:h_block+2, 
                    w_block:w_block+2, k])/4
    return im_down

# get alignment of images
# argument: cropped and rotated images h x w x 4
# return value: aligned images with dims h_new x w_new x 4
def get_aligned_images_wrapper(im_cropped):
    # get all of the downsampled image sets
    im_down1 = get_downsampled_images(im_cropped)
    im_down2 = get_downsampled_images(im_down1)
    im_down3 = get_downsampled_images(im_down2)
    im_down4 = get_downsampled_images(im_down3)
    im_down5 = get_downsampled_images(im_down4)
    im_down6 = get_downsampled_images(im_down5)
    im_down7 = get_downsampled_images(im_down6)
    # iterate over all downsampled images
    for i in range(1, 8):

# get aligned images
def align_images(images, alignment):
    pass

# get normal map using least squares approximations
# use light vector calibrated to the Cannon 220 LIDE scanner
# noramlized normal map 
# argument: aligned images with dims h x w x 4
# return value: normal map with dims h x w x 3 with range (0, 255)
def get_normal_map(images):
    s = images.shape
    h = s[0]
    w = s[1]
    normal_map = np.zeros((h, w, 3))

    # light vector calibrated from the Cannon LIDE 220 scanner
    l = [0.1329, -0.3712, 0.9190]
    lx = l[0]
    ly = l[1]
    lz = l[2]

    # shape the intensities into vectors of size 1 x hw
    # ordered across rows
    I1 = np.reshape(images[:, :, 0], h*w)
    I2 = np.reshape(images[:, :, 1], h*w)
    I3 = np.reshape(images[:, :, 2], h*w)
    I4 = np.reshape(images[:, :, 3], h*w)

    # use least squares to solve for normal map
    # Ax = b
    # A = light vectors dimensions: 4 x 3
    # x = normal vectors dimensions: 3 x pixels
    # b = intensities dimensions: 4 x pixels

    # I1 = nxlx + nyly + nzlz
    # I2 = nxly - nylx + nzlz
    # I3 = -nxlx - nyly + nzlz
    # I4 = -nxly + nylx + nzlz

    # l dot n = I
    A = np.array(
        [[lx, ly, lz], 
        [ly, -lx, lz], 
        [-lx, -ly, lz], 
        [-ly, lx, lz]])
    b = np.array([I1, I2, I3, I4])
    # use linear least squares to solve for x (first return value of lstsq)
    x = np.linalg.lstsq(A,b)[0]
    # reshape x into the normal vectors
    # x = 3 by pixels 
    # first row is nx, second row is ny, third row is nz
    nx = np.reshape(x[0, :], (w, h))
    ny = np.reshape(x[1, :], (w, h))
    nz = np.reshape(x[2, :], (w, h))

    # normalize normal map by the magnitudes of the normals
    magnitudes = (nx**2 + ny**2 + nz**2)**0.5
    normal_map[:, :, 0] = nx/magnitudes
    normal_map[:, :, 1] = ny/magnitudes
    normal_map[:, :, 2] = nz/magnitudes

    # put range of normal map from (-1, 1) to (0, 255)
    return (normal_map + 1)*255/2

# get height field of the sonorine using conjugate gradient least squares 
# approximation
# use a mask to increase tendancy for the height to be 0 in areas that 
# are outside of the grooove region
# use sparse matrices to generate the matrices to solve the least squares
# approximation
# argument: normal map with dims h x w x 3
# return value: height field with dims s x s
def get_height_field(normal_map, c, r_in, r_out):
    s = normal_map.shape
    h = s[0]
    w = s[1]

    # get the center of the sonorine, mask, and radius
    [cx, cy, r, Z] = get_mask(h, w, c, r_in, r_out)

    # get normal map as a square matrix around center
    nx = normal_map[cy-r:cy+r, cx-r:cx+r, 0]
    ny = normal_map[cy-r:cy+r, cx-r:cx+r, 1]
    nz = normal_map[cy-r:cy+r, cx-r:cx+r, 2]

    # normalize the height map
    L = (nx**2 + ny**2 + nz**2)**0.5
    U = nx/L
    V = ny/L
    W = nz/L 

    # solve least squares Ax = b
    # A contains linear kernel to solve for nx and ny, and heights to 
    # be around 0
    # b contains 3 portions: nx, ny, and 0s to keep values around zero
    s = Z.shape
    num_rows = s[0]
    num_cols = s[1]
    total = num_rows*num_cols
    b = np.zeros(3*total, 1)

    b[0:total] = reshape(U, total, 1) # fill top of b with n_x
    b[total:total*2] = reshape(V, total, 1) # fill middle of b with n_y

    # A needs to be a square matrix
    A = fill_matrix(num_cols, num_rows, Z)
    x = scipy.sparse.linalg.cg(A, b)
    # only first 1/3 of values is important
    x = x[0:total]
    height_map = reshape(x, s)
    # return height map and center of image
    return height_map

# helper function of get_height_field
# get the mask to generate the height field
# arguments: dimensions and center
# return value: mask
def get_mask(h, w, c, r_in, r_out):
    cx = c[0]
    cy = c[1]
    r = 1.05*r_out

    # weights of the mask on the sonorine grooves
    weight_out = 1
    weight_in = 10**(-2)

    # create the mask as high outside of the grooves and low within the
    # region with the grooves
    [X, Y] = np.mgrid[0:w, 0:h]
    Z = np.ones((h, w))
    Z = Z*weight_in
    distance = (((X-cx)**2 + (Y-cy)**2)**0.5)
    Z[distance <= r_in]= weight_out # set weight inside inner grooves
    Z[distance >= r_out] = weight_out # set weight outside outter grooves
    return [cx, cy, r, Z]

# helper function of get_height_field
# arguments: size of height_map (r, c) and mask Z
# return value: square matrix A with dimensions 3rc x 3rc
def fill_matrix(num_rows, num_cols, Z):
    total = num_rows*num_cols
    A = scipy.sparse.csr_matrix((3*total, 3*total)) 
    ones = np.ones((total, 1))

    # fill in rows with linear nx kernel
    # kernel is [[0 0 0]
    #            [1 0 -1]
    #            [0 0 0]]
    columns = [one, -one]
    d = [-1, 1]
    A[0:total, :] = scipy.sparse.spdiags(columns, d, total, total)

    # fill in rows with linear ny kernel
    # kernel is [[0 1 0]
    #            [0 0 0]
    #            [0 -1 0]]
    columns = [one, -one]
    d = [-num_cols, num_cols]
    A[total:2*total, :] = scipy.sparse.spdiags(columns, d, total, total)

    # fill in kernel along main diagonal
    A3_main_diag = np.reshape(Z, (total, 1))
    A[total*2:total*3, :] = scipy.sparse.spdiags(A3_main_diag, 0, total, total)
    return A









# main
def main(sonorine_num):
    total_masks = 30
    im_raw = get_raw_images(sonorine_num)
    im_cropped = get_cropped_rotated_images(im_raw)


    [r_in, r_out, cx_rough, cy_rough]

    im_aligned = get_aligned_images_wrapper(im_cropped)
    normal_map = get_normal_map(im_aligned)

    # translate cx_rough and cy_rough in terms of aligned normal_map images

    height_field_rough = get_height_field(normal_map, 
        [cx_rough, cy_rough], r_in, r_out)
    [center_calc] = get_center(height_field_rough, r1, [cx_rough, cy_rough])

    # translate center_calc in terms of normal_map

    [height_field] = get_height_field(normal_map, center_calc)
    blur_map = get_blur_map(height_field, total_masks)
    sound = get_grooves(height_field, center_calc)
