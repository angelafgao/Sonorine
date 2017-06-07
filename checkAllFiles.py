import os
import filecmp
import string

# compare the files in the directory to see if they are different
# return False if 2 files are the same
# return True if they are all different
def cmpFiles(filenames, count):
    for i in range(0, count):
        for j in range(i+1, count):
            if filecmp.cmp(filenames[i], filenames[j])==True: 
                print(filenames[i], filenames[j])
                return False
    return True

# get the angle of the image from the file name
# returns the angle
def getAngle(sonorine_file):
    a, b, c = sonorine_file.split("_")
    e, f = c.split(".")
    return e

def check_folder_format(sonorine_folder):
    a, sonorine_number = sonorine_folder.split("_")
    #error checking for file name
    if  a != "Sonorine": return False 
    if len(sonorine_number) != 3: return False
    return True

# counts the number of files in a given folder
# makes sure all angles are present
def file_count(path, sonorine_folder, count):
    file_counter = 0
    filenames = []
    file_angles = set()
    # iterate over all of the images of the sonorines in the folder
    for sonorine_file in os.listdir(path + sonorine_folder):
        if (sonorine_file.startswith("sonorine")):
            file_counter+=1
            filenames.append(path + sonorine_folder + "/" + sonorine_file)
            angle = getAngle(sonorine_file)
            file_angles.add(angle)
    if (count == 5) and (file_angles != {'180', '270', 'front', '000', '090'}): 
        print("ERROR: file names missing angle")
        print("Missing Angles = ")
        print({'180', '270', 'front', '000', '090'} - file_angles)
        return False
    if (count == 4) and (file_angles != {'180', '270', '000', '090'}):
        print("ERROR: file names missing angle")
        print("Missing Angles = ")
        print({'180', '270', '000', '090'} - file_angles)
    if cmpFiles(filenames, count) == False: 
        print("ERROR: files are the same")
        return False
    if file_counter != count: 
        printf("ERROR: file count not right. Count = " + 
            str(file_counter))
        return False
    return True


# checks to see if the files and folders are formatted correctly
# checks to see if there are 5 images in each sonorine folder
# checks to see if all of the rotation angles are present
# checks to see if each file size is roughly correct (around  500-600 MB)
# checks to see if each image is different 
def checkFiles():
    # iterate over all of the sonorine folders in the raw data
    for sonorine_folder in os.listdir("Data/Raw"): 
        if (sonorine_folder.startswith("Sonorine")):
            if check_folder_format(sonorine_folder) == False:
                print("Improper folder format for a Data/Raw folder")
            if file_count("Data/Raw/", sonorine_folder, 5) == False:
                return False
    print("all raw files accounted for")
    # iterate over all of the sonorine files in the downsampled and uncropped data
    for down_folder in os.listdir("Data/Processed/Downsampled"):
        if (down_folder.startswith("Down")):
            counter = 0
            for sonorine_folder in os.listdir("Data/Processed/Downsampled/" + down_folder):
                counter += 1
                if check_folder_format(sonorine_folder) == False:
                    print("Improper folder format for a Data/Raw folder")
                if file_count("Data/Processed/Downsampled/" + down_folder + "/", sonorine_folder, 4) == False:
                    continue
        print("all downsampled files accounted for in " + down_folder)
    return True

print(checkFiles())