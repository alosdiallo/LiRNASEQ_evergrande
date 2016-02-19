import os
import bz2
import sys
import shutil
import subprocess
import argparse
import glob
import pprint

parser = argparse.ArgumentParser(description="Run Genomes through scripts")

parser.add_argument("-p", help="path of the experiment")#accepts the path parameter
args = parser.parse_args()


for s in glob.glob(args.p):
    organized = s.rsplit('_')[2]
    y=[]
    y.append(os.path.join(args.p, organized)
        pprint.pprint(locals(y))
    for expfolders in y:
        if not os.path.exists(expfolders)
            os.mkdir(expfolders)
            if y[4] == "R1"
                shutil.move(s, os.path.join(s, os.path.basename(s)))
            elif y[4] == "R2"
                shutil.move(s, os.path.join(s, os.path.basename(s)))
            else
