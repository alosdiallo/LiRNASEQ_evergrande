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
args = parser.parse_args()

currentPath = os.path.dirname(os.path.realpath(__file__))
for s in glob.glob(args.p):
    organized = s.rsplit('_')[3]
    y = []
    y.append(os.path.join(args.p, organized)
    for x in y:
        if x == x + 1
            os.mkdir(x)
            if y[5] == "R1"
                shutil.move(s, os.path.join(s, os.path.basename(s)))
            elif y[5] == "R2"
                shutil.move(s, os.path.join(s, os.path.basename(s)))
            else


#print ("Path - " + args.p)
#print ("CurrentPath - " + currentPath)

os.system("sed -i -e 's/\r$//' runScript.sh")

os.system("./runScript.sh " + args.p + " " + args.time + " " + args.g + " " + args.t + " " + args.ul + " " + args.bc)#calls the runScript and passes variables to it
