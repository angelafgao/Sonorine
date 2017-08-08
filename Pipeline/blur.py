

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
        temp[segs == j] = -1;
        temp[segs != j] = 0;
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
    sig_x = 5
    sig_y = 0.25
    dx = sig_x * 6
    dy = sig_y * 6
    [X, Y] = np.mgrid[-dx:0.1:dx, -dy:0.1:dy]

    a = 1/(2*sig_x**2)
    b = 1/(2*sig_y**2)

    X0 = 0
    Y0 = 0
    A = 1

    filt = A*exp(-(a*(X-X0)**2 + b*(Y-Y0)**2))
    return filt
