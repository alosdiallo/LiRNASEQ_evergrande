import os
import bz2
import sys
import shutil
import subprocess
import argparse

parser = argparse.ArgumentParser(description="Run Genomes through scripts")

parser.add_argument("-g", help="path of the genome")#accepts the genome parameterargs = parser.parse_args()
args = parser.parse_args()

currentPath = os.path.dirname(os.path.realpath(__file__))


print ("Path - " + args.g)
print ("CurrentPath - " + currentPath)

