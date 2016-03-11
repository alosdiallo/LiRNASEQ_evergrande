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
parser.add_argument("-bc", help="Length of barcode")#accepts the barcode length
parser.add_argument("-ul", help="UML lenght")#accepts the UMI length
parser.add_argument("-b", help="Path to the bed file")#What is the name of your bed file
args = parser.parse_args()

currentPath = os.path.dirname(os.path.realpath(__file__))
runScriptPath = currentPath + "/runScript.sh"
dirs = os.listdir(args.p)

for file in dirs:
    if file.endswith(".bz2"):
        experiment = []
        experiment = file.split('_')
        array_experiment = []
        array_experiment.append(experiment[2])
        for expfolders in array_experiment:
            expfolderpath = os.path.join(args.p, expfolders)
            fullpath = os.path.join(args.p, file)
            if not os.path.exists(expfolderpath):
                os.mkdir(expfolderpath)
                full = args.p + "/" + "*" + expfolders + "*.bz2" 
                print(full)
                os.system("cp " + full + " " + expfolderpath)


os.system("sed -i -e 's/\r$//' " + runScriptPath)

os.system(runScriptPath + " " + args.p + " " + args.time + " " + args.g + " " + args.t + " " + args.ul + " " + args.bc + " " + args.b + " " + currentPath)#calls the runScript and passes variables to it

