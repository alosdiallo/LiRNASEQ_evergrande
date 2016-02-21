import os
import bz2
import sys
import shutil
import subprocess
import argparse
import glob
import pprint
import re

parser = argparse.ArgumentParser(description="Run Genomes through scripts")

parser.add_argument("-p", help="path of the experiment")#accepts the path parameter
args = parser.parse_args()

dirs = os.listdir(args.p)

for file in dirs:
    exptype = file.split('_')
    arrexptype = []
    arrexptype.extend(exptype[2])
    for expfolders in arrexptype:
        expfolderpath = os.path.join(args.p, expfolders)
        if not os.path.exists(expfolderpath):
            os.mkdir(expfolderpath)
            if re.match("R1", exptype[4]):
                shutil.move(file, os.path.join(expfolderpath, arrexptype[4]))
            elif re.match("R2", exptype[4]):
                shutil.move(file, os.path.join(expfolderpath, arrexptype[4]))
            else:
                print("Error")