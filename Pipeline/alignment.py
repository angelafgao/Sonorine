import numpy as np

# get the new h and w of the aligned images as well as the top left corner
# arguments: width, height of the original images, alignment translation info
# return values: alignment translations, width and height of aligned images
def get_aligned_dims(w, h, trans_info):
    align = np.zeros((4, 4))
    align[2, 0] = w
    align[3, 0] = h
    for i in range(4):
        # determine x' values
        align[0, i] = max(0, trans_info[0, i])
        # determine y' values
        align[1, i] = max(0, trans_info[1, i])
        # determine w' values
        align[2, i] = w - abs(trans_info[0, i])
        # determine h' values
        align[3, i] = h - abs(trans_info[1, i])

    # find the new w and h values for all iamges
    w_aligned = min(align[2, :])
    h_aligned = min(align[3, :])
    # saves align as just the start x' and y' values
    align = align[0:1, :] + 1
    return [align, w_aligned, h_aligned]

def align_images(w, h, temp_images, trans_info):
    trans_info[0, :] = trans_info[0, :] + abs(min(0, min(trans_info[0, :])))
    trans_info[1, :] = trans_info[1, :] + abs(min(0, min(trans_info[1, :])))
    [align, w_aligned, h_aligned] = get_aligned_dims(w, h, trans_info)
    aligned_images = np.zeros((h_aligned, w_aligned, 4))
    for i in range(4):
        aligned_images[:, :, i] = temp_images[align[1, i]:align[1, i] + h_aligned - 1, 
            align[0, i]:align[0, i] + w_aligned - 1, i]
    return aligned_images


def get_aligned_images(images, alignment):
    s = images.shape
    h = s[0]
    w = s[1]
    aligned_images = align_images(w, h, images, trans_info)
    return aligned_images
