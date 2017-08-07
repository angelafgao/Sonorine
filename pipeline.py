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
        if i == 0:
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
# return value: normal map with dims h x w x 3 with range (0, 255)
def get_normal_map(images):
    s = images.shape
    h = s[0]
    w = s[1]
    normal_map = np.zeros((h, w, 3))

    l = [0.1329, -0.3712, 0.9190]
    lx = l[0]
    ly = l[1]
    lz = l[2]

    I1 = np.reshape(images[:, :, 0], h*w)
    I2 = np.reshape(images[:, :, 1], h*w)
    I3 = np.reshape(images[:, :, 2], h*w)
    I4 = np.reshape(images[:, :, 3], h*w)

    # use least squares to solve for normal map
    A = np.array(
        [[lx, ly, lz], 
        [ly, -lx, lz], 
        [-lx, -ly, lz], 
        [-ly, lx, lz]])
    b = np.array([I1, I2, I3, I4])
    x = np.linalg.lstsq(A,b)[0]
    nx = np.reshape(x[0, :], (w, h))
    ny = np.reshape(x[1, :], (w, h))
    nz = np.reshape(x[2, :], (w, h))

    magnitudes = (nx**2 + ny**2 + nz**2)**0.5
    normal_map[:, :, 0] = nx/magnitudes
    normal_map[:, :, 1] = ny/magnitudes
    normal_map[:, :, 2] = nz/magnitudes

    return (normal_map + 1)*255/2

# get height field of the sonorine
# argument: normal map with dims h x w x 3
# return value: height field with dims s x s
def get_height_field(normal_map, c = None, r_in = None, r_out = None):
    s = normal_map.shape
    h = s[0]
    w = s[1]

    [cx, cy, r, Z] = get_mask(h, w, c, r_in, r_out)

    nx = normal_map[cy-r:cy+r, cx-r:cx+r, 0]
    ny = normal_map[cy-r:cy+r, cx-r:cx+r, 1]
    nz = normal_map[cy-r:cy+r, cx-r:cx+r, 2]

    L = (nx**2 + ny**2 + nz**2)**0.5
    U = nx./L
    V = ny./L
    W = nz./L 

    s = Z.shape
    num_rows = s[0]
    num_cols = s[1]
    total = num_rows*num_cols
    b = np.zeros(3*total, 1)

    b[0:total] = reshape(U, total, 1) # fill top of b with n_x
    b[total+1:total*2] = reshape(V, total, 1) # fill middle of b with n_y

    A = fill_matrix(num_cols, num_rows, Z)

    x = scipy.sparse.linalg.cg(A, b)

    x = x[0:total]
    height_map = reshape(x, s)
    height_map = height_map
    return [height_map, [cx, cy]]

# helper function of get_height_field
# get the mask to generate the height field
# arguments: dimensions and center
# return value: mask
def get_mask(h, w, c, r_in, r_out):
    if c == None:
        cx = w/2
        cy = h/2
    else:
        cx = c[0]
        cy = c[1]

    r = cy
    if r_in == None:
        r_in = r*0.33
    if r_out == None:
        r_out =  r*0.95

    weight_out = 1
    weight_in = 10**(-2)

    [X, Y] = np.mgrid[0:w, 0:h]
    Z = np.ones((h, w))
    Z = Z*weight_in
    distance = (((X-cx)**2 + (Y-cy)**2)**0.5)
    Z[distance <= r_in]= weight_out
    Z[distance >= r_out] = weight_out
    return [cx, cy, r, Z]

# helper function of get_height_field
# arguments: size of height_map (r, c) and mask Z
# return value: square matrix A with dimensions 3rc x 3rc
def fill_matrix(num_rows, num_cols, Z):
    total = num_rows*num_cols
    A = scipy.sparse.csr_matrix((3*total, 3*total)) 
    ones = np.ones((total, 1))
    columns = [one, -one]
    d = [-1 1]
    A[0:total, :] = scipy.sparse.spdiags(columns, d, total, total)

    columns = [one, -one]
    d = [-num_cols, num_cols]
    A[total:2*total, :] = scipy.sparse.spdiags(columns, d, total, total)

    A3_main_diag = np.reshape(Z, (total, 1))
    A(total*2:total*3, :) = scipy.sparse.spdiags(A3_main_diag, 0, total, total)
    return A

# get center of the sonorine
# argument: height_map
# return value: [cx, cy] = center of the sonorine in reference to the height_map
#   and the inner radius and outer radius
def get_center(height_map):
    s = height_map.shape
    h = s(0)
    w = s(1)

    cx = w/2
    cy = h/2
    
    # iterate over 5 (x,y) pairs and 4 thetas
    shift = [-150, -100, -50, 0, 50, 100, 150]
    dirs = [0, 1]
    c = [cx, cy]
    calc_center = np.zeros((length(shift), length(dirs)))

    for i in range(length(shift)):
        for j in range(length(dirs)):
            curr_shift = shift[i]
            curr_dir = dirs[j]
            # get smoothed chunk
            # get the normalized plot of the grooves
            shifted = get_smoothed_shifted(height_map, curr_shift + c[j], curr_dir)

            # find the left half of grooves and right half of grooves
            [a, b] = get_grooves(shifted, c[j])

            #calculate center
            calc_center[i, j] = check_center(a, b)
    
    center = mean(calc_center)
    # r_in and r_out along center line where cy is constant
    center_shifted = get_smoothed_shifted(height_map, center[0], 0)
    [a, b] = get_grooves(shifted, center[0])
    r_in = min(abs(c[0] - a[0]), abs(c[0] - b[0]))
    r_out = max(abs(c[0] - a[-1]), abs(c[0] - b[-1]))
    return [center, r_in, r_out]

# helper function of get_center
# arguments: smoothed and shifted center map, rough center of sonorine
#   center of the height_map
# return value: [a, b] = grooves on left of center and 
#   grooves on right of center
def get_grooves(data, c):
    count = 0
    grooves = np.zeros((1, 100))
    delta = 7
    eps = -0.5

    for i in range(delta, length[data] - delta):
        if (min(data[i - delta:i + delta]) == data[i]) and (data[i] < eps):
            count = count + 1
            grooves[count] = i

    tmp = grooves - c
    idx = np.argmin(tmp(tmp>0))
    a = grooves[0:idx]
    a = [::-1]
    b = grooves[idx + 1:count]

    return [a, b]

# helper function of get_center
# arguments: height_map, starting point, direction (vertically or horizontal)
# return value: smoothed and shifted height_map
def get_smoothed_shifted(height_map, start_row, d):
    num_rows = 21
    sigma = 3
    x = np.zeros((1, sigma*6))
    y = np.zeros((sigma*6, 1))
    
    # shift in x direction
    if d == 1
        mask = scipy.ndimage.filters.gaussian_filter(x, sigma)
        imfilt = scipy.ndimage.convolve(height_map, mask)
        cols = imfilt[:,start_row - num_rows:start_row + num_rows]
        col = np.sum(cols, 0)/num_rows
    # shift in y direction
    else if d == 0:
        mask = scipy.ndimage.filters.gaussian_filter(y, sigma)
        imfilt = scipy.ndimage.convolve(height_map, mask)
        cols = imfilt[start_row - num_rows:start_row + num_rows,:]
        col = np.sum(cols, 1)/num_rows
   
    small_window = scipy.signal.gaussian(11, 2)
    small_window = small_window / np.sum(small_window)
    small_smooth = scipy.signal.convolve(col, small_window, 'same')

    window = scipy.signal.gaussian(31, 5)
    window = window / np.sum(window)
    smoothed = scipy.signal.convolve(col, window, 'same');

    shifted = small_smooth - smoothed;
    return shifted

# helper function of get_center
# arguments: grooves on left of center and grooves on right of center
# return value: best center given grooves
def check_center(a, b):
    A = length(a)
    B = length(b)
    errors = np.zeros(A-1, B-1, 2)
    hits = np.zeros(A-1, B-1, 2)
    centers = np.zeros(A-1, B-1, 2)

    for j in range(0, B-1):
        for i in range(0, A-1):
            # assume using a as mids
            mids = (np.roll(a, -1) + a)/2
            mids = mids[1:A]
            c_new = (mids[1] + b[j])/2
            groove_dists = abs(b[i:B] - c_new)
            mid_dists = abs(mids - c_new)
            [error, hit] = get_error_hits(groove_dists, mid_dists)
            errors[i, j, 0] = error
            hits[i, j, 0] = hit
            centers[i, j, 0] = c_new


            # assume using b as mids
            # a_i = - (b_i + b_i+1)/2
            mids = (np.roll(b, -1) + b)/2
            mids = mids[1:B]
            c_new = (mids[1] + a[i])/2
            groove_dists = abs(a[i:A] - c_new)
            mid_dists = abs(mids - c_new)
            [error, hit] = get_error_hits(groove_dists, mid_dists)
            errors[i, j, 1] = error
            hits[i, j, 1] = hit
            centers[i, j, 1] = c_new
    
    hits[hits == 0] = -1
    errors[errors == 0] = -1
    score = hits*100 + max(errors[:])/(errors./hits)
    idx = np.argmax(score)
    [r, c, d] = numpy.unravel_index(idx, score.shape)
    center = centers[r, c, d]
    return center

# helper function of get_center
# arguments: groove distance and mid point between groove distances
# return value: number of good matching grooves and midpoints and error
def get_error_hits(groove_dists, mid_dists):
    tol = 0.05*30
    error = 0
    hits = 0
    for  i in range(0, min(length(mid_dists), length(groove_dists))):
        distance = abs(groove_dists[i] - mid_dists[i])
        error = error + abs(distance)
        if (distance < tol):
            hits = hits + 1
    return [error, hits]

# blur height field
# arguments: height_map and total number of gaussian blur directions
# return value: radially blurred height_map with dimensions s x s
def get_blur_map(height_map, total_masks):
    dtheta = 180/total_masks
    s = height_map.shape
    blur_map = np.zeros(s)
    [alphas, segs] = get_alphas_segs(s, total_masks)
    neg_alphas = 1 - alphas;
    temp = np.zeros(s)
    next_sec = blur(height_map, dtheta, total_masks - 1)
    for i in range(0, total_masks):
        prev_sec = next_sec
        next_sec = blur(height_map, dtheta, i)
        temp(segs == j) = -1;
        temp(segs != j) = 0;
        section = alphas * temp * prev_sec + neg_alphas * temp * next_sec
        blur_map += section
    return blur_map

# helper function to get_blur_map
# arguments: size of height_map and total number of gaussain blur directions
# return value: blurred height_map in direction dtheta*i
def get_alphas_segs(s, total_masks):
    h = s[0]
    w = s[1]
    cx = w/2
    cy = h/2
    dtheta = pi/total_masks
    segs = np.zeros(s)
    alphas = np.zeros(s)
    for i in range(0, h):
        for j in range(0, w):
            dx = j - cx
            dy = j - cy
            if dx == 0:
                theta = 0
            elif dy == 0:
                theta = pi/2
            else:
                theta = pi - atan(dx/dy)
            i_prev = math.floor(theta/dtheta)
            i_next = i_prev + 1
            theta_prev = i_prev * dtheta
            theta_next = i_next * dtheta
            i_prev = i_prev % total_masks
            i_next = i_next % total_masks
            alphas[i, j] = (theta - theta_next)/(theta_prev - theta_next)
            segs[i, j] = i_prev
    return [alphas, segs]

# helper function to get_blur_map
# arguments: height_map with dimensions s x s, dtheta*i = rotation of gaussian
# return value: blurred height_map in direction dtheta*i size s x s
def blur(height_map, dtheta, i):
    rot_mask = mask()
    imrot = scipy.misc.imrotate(image, dtheta*i)
    imfilt = scipy.ndimage.filters.convolve(imrot, rotmask)/sum(rotmask)
    imrot = scipy.misc.imrotate(imfilt, -dtheta*i)
    s1 = height_map.shape
    s2 = imrot.shape
    offset = (s2 - s1)/2
    im = imrot[offset[0]: offset[0]+ s1[0], offset[1]: offset[1] + s1[1]]
    return im

# helper function to get_blur_map
# arguments: nothing
# return value: gaussian filter
def mask():
    sig_x = 5;
    sig_y = 0.25;
    dx = sig_x * 6;
    dy = sig_y * 6;
    [X, Y] = np.mgrid(-dx:0.1:dx, -dy:0.1:dy)

    a = 1/(2*sig_x**2)
    b = 1/(2*sig_y**2)

    X0 = 0
    Y0 = 0
    A = 1

    filt = A*exp(-(a*(X-X0)**2 + b*(Y-Y0)**2))
    return filt

# main
def main(sonorine_num):
    total_masks = 30

    im_raw = get_raw_images(sonorine_num)
    im_cropped = get_cropped_rotated_images(im_raw)
    im_aligned = get_aligned_images_wrapper(im_cropped)
    normal_map = get_normal_map(im_aligned)
    [height_field_rough, center_rough] = get_height_field(normal_map)
    [center_calc, r_in, r_out] = get_center(height_field_rough)

    # calculate new center in relation to the whole normal map
    norm_s = normal_map.shape
    norm_s = np.array(norm_s[0:2])
    height_s = np.array(height_field_rough.shape)
    center_calc = np.array(center_calc)
    center_rough = np.array(center_rough)
    dist = (norm_s - height_s)/2

    center_new = ((center_calc + dist) - center_rough) + dist

    [height_field, c, r_in, r_out] = get_height_field(normal_map, center_new)
    blur_map = get_blur_map(height_field, total_masks)
    sound = get_grooves(height_field, c)
