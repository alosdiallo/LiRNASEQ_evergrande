import os
import bz2
import sys
import shutil
import subprocess
import argparse

parser = argparse.ArgumentParser(description="Run Genomes through scripts")

parser.add_argument("-p", help="path of the experiment")#accepts the path parameter
parser.add_argument("-g", help="path of the genome")#accepts the genome parameter
parser.add_argument("-t", help="path of the transcriptome")#accepts the transcriptome parameter
parser.add_argument("-time", type=int, help="The amount of hours the genome will take to process")#accepts the time parameter
parser.add_argument("-bc", help="The start of the barcode")#accepts the barcode length
parser.add_argument("-ul", help="The start of the UMI")#accepts the UMI length
args = parser.parse_args()

currentPath = os.path.dirname(os.path.realpath(__file__))

for i in os.listdir(args.p):
    if i.endswith(".bz2"):
        i = args.p + "/" + i
        statinfo = os.stat(i)
        i = statinfo.st_size
        i = i.encode('string_encode')
        with open(i, 'r+') as f:#opens the file that is going to be run through
            genomeSize = statinfo.st_size#gets the file size of the args.p file
            uncompressedData = bz2.BZ2File(f).read(genomeSize)#Decompressed the data set in .bz2 and does so until the size that was determined earlier
        continue
    else:
        continue
    
print ("Path - " + args.p)
print ("CurrentPath - " + currentPath)

os.system("runScript.sh " + args.p + " " + args.time + " " + args.g + " " + args.t + " " + args.ul + " " + args.bc)#calls the runScript and passes variables to it
    
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

f.closed        
        
