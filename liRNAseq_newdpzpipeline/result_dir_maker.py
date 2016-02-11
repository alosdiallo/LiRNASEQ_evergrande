import os
import glob
from Yael_genomes_param.py import *#imports the neccasary variables from Yael_genomes_param.py 

resultPath = currentPath + "\Results"#creates the new path with the Results folder
if not os.path.exists(result):#checks whether folder already exists
    os.makedirs("Results")#creates a folder called Results

for folder in myFolders:
    os.mkdir(resultPath + '\\' + folder, 0755)#creates the folders with the names of the files from the genome within the Results folder