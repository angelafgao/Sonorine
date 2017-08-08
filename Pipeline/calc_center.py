# get center of the sonorine
# argument: height_map
# return value: [cx, cy] = center of the sonorine in reference to the height_map
#   and the inner radius and outer radius
def get_center(height_map, r1, center):
    s = height_map.shape
    h = s(0)
    w = s(1)

    cx = center[0]
    cy = center[1]
    
    # iterate over 5 (x,y) pairs and 4 thetas
    shift = [-50, -25, 0, 25, 50]
    thetas = [-90, -60, -30, 0, 30, 60, 90]
    c = [cx, cy]
    T = length(thetas)
    S = length(shift)
    A = np.zeros((S*T, 2))
    b = np.zeros((S*T, 1))

    for i in range(S):
        for j in range(theta):
            curr_shift = shift[i]
            theta = thetas[j]
            # get smoothed chunk
            # get the normalized plot of the grooves
            shifted = get_smoothed_shifted(height_map, curr_shift + c[j], theta)

            # find the left half of grooves and right half of grooves
            [a, b] = get_grooves(shifted, c[j])

            #calculate center
            index = i*T + j
            b[index] = check_center(a, b)
            A[index, 0] = math.cos(theta)
            A[index, 1] = math.sin(theta)

    
    center = mean(calc_center)


    # cos(theta)x + sin(theta)y = distance
    # A = cos(theta) sin(theta)
    # center = [x, y]
    # b = distances

    center = np.linalg.lstsq(A,b)[0]

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
    a = a[::-1]
    b = grooves[idx + 1:count]

    return [a, b]

# helper function of get_center
# arguments: height_map, starting point, direction (vertically or horizontal)
# return value: smoothed and shifted height_map
def get_smoothed_shifted(height_map, start_row, theta):
    num_rows = 21
    sigma = 3
    x = np.zeros((1, sigma*6))
    y = np.zeros((sigma*6, 1))
    
    imrot = scipy.misc.imrotate(height_map, theta)
    mask = scipy.ndimage.filters.gaussian_filter(x, sigma)
    imfilt = scipy.ndimage.convolve(imrot, mask)
    cols = imfilt[:,start_row - num_rows:start_row + num_rows]
    col = np.sum(cols, 0)/num_rows
   
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
    score = hits*100 + max(errors[:])/(errors/hits)
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
