                                                    LiRNASEQ_evergrande

Description
--------------------
The LiRNASEQ_evergrande is a simple system of analyzing and organizing genomes. It 
starts and ends with python scripts but also uses bash scripts made by David Puyraimond-Zemmour.
There are other files in the directory that will be referenced by the bash scripts. This is all 
basically a moveable directory that will work as long as one passes in the right variables.

    Usage:
        Run.py [-h] [-p P] [-t T] [-u U] [-c C]
        
    Arguments:
        -h
            produces - 
            -p P        path of the genomes
            -t T        transcriptome
            -u U        UMI Length
            -c C        The path of the directory including this directory
        -p 
            directory path of the genome
        -t
            transcriptome
        -u
            UMI length
        -c
            Current Path of the code directory
    Example
        RUN.py -p C:\..\S9 -t 1 -u 3 -c C:\..\LiRNASEQ_evergrande\liRNAseq_newdpzpipeline
        
References:

  David Puyraimond-Zemmour - Harvard Medical School
  
  Ashley Sun - Harvard Medical School
  
