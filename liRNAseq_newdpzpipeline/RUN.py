import os
import bz2
import sys
import shutil
import subprocess
import argparse
import glob

parser = argparse.ArgumentParser(description="Run Genomes through scripts")

parser.add_argument("-p", help="path of the experiment")#accepts the path parameter
parser.add_argument("-g", help="path of the genome")#accepts the genome parameter
parser.add_argument("-t", help="path of the transcriptome")#accepts the transcriptome parameter
parser.add_argument("-time", help="The amount of hours the genome will take to process")#accepts the time parameter
parser.add_argument("-bc", help="The start of the barcode")#accepts the barcode length
parser.add_argument("-ul", help="The start of the UMI")#accepts the UMI length
parser.add_argument("-b", help="Name of Bed File")#What is the name of your bed file
args = parser.parse_args()

currentPath = os.path.dirname(os.path.realpath(__file__))

dirs = os.listdir(args.p)

for file in dirs:
    if file.endswith(".bz2"):
        experiment = []
        experiment = file.split('_')
        #print(experiment[2])
        #print(experiment[4])
        array_experiment = []
        array_experiment.append(experiment[2])
        #print(len(arrexperiment))
        for expfolders in array_experiment:
            expfolderpath = os.path.join(args.p, expfolders)
            fullpath = os.path.join(args.p, file)
            if not os.path.exists(expfolderpath):
                os.mkdir(expfolderpath)
                full = args.p + "/" + "*" + expfolders + "*.bz2" 
                print(full)
                os.system("cp " + full + " " + expfolderpath)

#print ("Path - " + args.p)
#print ("CurrentPath - " + currentPath)

os.system("sed -i -e 's/\r$//' runScript.sh")

os.system("./runScript.sh " + args.p + " " + args.time + " " + args.g + " " + args.t + " " + args.ul + " " + args.bc + " " + args.b)#calls the runScript and passes variables to it
