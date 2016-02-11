import os
import bz2
import sys
import shutil
import subprocess
import argparse
from optparse import OptionParser

parser = argparse.ArgumentParser(description="Run Genomes through scripts")

parser.add_argument("-p", help="path of the genomes")
parser.add_argument("-t", type=int, help="transcriptome")
parser.add_argument("-u", help="UMI Length")
parser.add_argument("-c", help="The path of the directory that this code directory is in *including this directory*")
parser.add_argument("-time", help="The amount of hours the genome will take to process")
parser.add_argument("-bf", help="The start of the barcode")
parser.add_argument("-bl", help="The end of the barcode")
parser.add_argument("-uf", help="The start of the UMI")
parser.add_argument("-ul", help="The end of the UMI")
args = parser.parse_args()

fileHandle = open(os.path.realpath(args.p), 'r+')#opens the file that is going to be run through
genomeSize = os.path.getsize(args.p)#gets the file size of the args.p file
uncompressedData = bz2.BZ2File(args.p).read(genomeSize)#Decompressed the data set in .bz2 and does so until the size that was determined earlier

def copyFile(args.p, currentPath):
    try:
        shutil.copy(args.p, currentPath)#copies the args.p to the local directory
    except shutil.Error as e:
        print('Error: %s' % e)
    except IOError as e:
        print('Error: %s' % e.strerror)

    
if "Human" in species or "human" in species:
    os.system("runScript_human.sh " + args.p)#if input as human then it will run the human runScript in
    subprocess.call(['./liRNAseq_pipeline_2_human.sh '] + args.p + " " + args.p + " " + args.u)#runs the low input RNA seqeunce script for human and passes in the args.p and UMI length
elif "mouse" in species or "Mouse" in species:
    os.system("runScript_mouse.sh " + args.p)#if input as mouse then it will run the mouse runScript in
    subprocess.call(['./liRNAseq_pipeline_2_mouse.sh '] + args.p + " " + args.p + " " + args.u)#runs low input RNA sequence script for mouse and passes in the args.p and the UMI length
else :
    print ("Please try again")#in case there was a misspelling
    
myFolders = []  #list of files in folder
        
for root, dirs, files in os.walk(args.p):
    myFolders.extend(files) #add files name into list
    for d in myFolders:
        folder_name = d.rsplit('.',1)[0]#If file calls abc.txt , so takes abc
        folderNames.extend(folder_name)
        newpath = os.path.join(args.p,folder_name)   
        if not os.path.exists(newpath): #check if folder exists
            os.makedirs(newpath)    #create folder based on the filenames
        file_original_path = os.path.join(args.p,d)
        shutil.copy(file_original_path,newpath) #copy the corresponding files to the folder

print ("Part I succesful!")