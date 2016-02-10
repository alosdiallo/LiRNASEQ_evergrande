import os
import bz2
import sys
import shutil
import subprocess

species = input("What is the Species? ")#Client input of either human or mouse
genome = input("What is the genome path? ")#Client input of the set data to be run through
umiLength = input("What is the UMI length? ")#Client input of the UMI length
currentPath = input("What is the current path? ")#Client input of the directory that the local directory is in

fileHandle = open(os.path.realpath(genome), 'r+')#opens the file that is going to be run through
genomeSize = os.path.getsize(genome)#gets the file size of the genome file
uncompressedData = bz2.BZ2File(genome).read(genomeSize)#Decompressed the data set in .bz2 and does so until the size that was determined earlier

def copyFile(genome, currentPath):
    try:
        shutil.copy(genome, currentPath)#copies the genome to the local directory
    except shutil.Error as e:
        print('Error: %s' % e)
    except IOError as e:
        print('Error: %s' % e.strerror)

    
if "Human" in species or "human" in species:
    os.system("runScript_human.sh " + genome)#if input as human then it will run the human runScript in
    subprocess.call(['./liRNAseq_pipeline_2_human.sh '] + genome + " " + genome + " " + umiLength)#runs the low input RNA seqeunce script for human and passes in the genome and UMI length
elif "mouse" in species or "Mouse" in species:
    os.system("runScript_mouse.sh " + genome)#if input as mouse then it will run the mouse runScript in
    subprocess.call(['./liRNAseq_pipeline_2_mouse.sh '] + genome + " " + genome + " " + umiLength)#runs low input RNA sequence script for mouse and passes in the genome and the UMI length
else :
    print ("Please try again")#in case there was a misspelling
    
myFolders = []  #list of files in folder
        
for root, dirs, files in os.walk(genome):
    myFolders.extend(files) #add files name into list
    for d in myFolders:
        folder_name = d.rsplit('.',1)[0]#If file calls abc.txt , so takes abc
        folderNames.extend(folder_name)
        newpath = os.path.join(genome,folder_name)   
        if not os.path.exists(newpath): #check if folder exists
            os.makedirs(newpath)    #create folder based on the filenames
        file_original_path = os.path.join(genome,d)
        shutil.copy(file_original_path,newpath) #copy the corresponding files to the folder

print ("Part I succesful!")