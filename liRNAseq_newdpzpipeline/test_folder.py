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
    if file.endswith(".bz2"):
        experiment = []
        experiment = file.split('_')
        print(experiment[2])
        print(experiment[4])
        arrexperiment = []
        arrexperiment.append(experiment[2])
        print(len(arrexperiment))
        for expfolders in arrexperiment:
            expfolderpath = os.path.join(args.p, expfolders)
            if not os.path.exists(expfolderpath):
                os.mkdir(expfolderpath)
                if file.endswith("R1.fastq.bz2"):
                    shutil.move(file, os.path.join(expfolderpath, arrexperiment[4]))
                elif file.endswith("R2.fastq.bz2"):
                    shutil.move(file, os.path.join(expfolderpath, arrexperiment[4]))
                else:
                    print("Error")