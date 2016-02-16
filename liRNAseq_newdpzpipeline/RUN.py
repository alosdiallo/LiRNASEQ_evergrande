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

for file_path in glob.glob(os.path.join(args.p, '*.*')):
    new_dir = file_path.rsplit('.', 1)[0]
    os.mkdir(os.path.join(args.p, new_dir))
    shutil.move(file_path, os.path.join(new_dir, os.path.basename(file_path)))

print ("Path - " + args.p)
print ("CurrentPath - " + currentPath)

os.system("./runScript.sh " + args.p + " " + args.time + " " + args.g + " " + args.t + " " + args.ul + " " + args.bc)#calls the runScript and passes variables to it
    