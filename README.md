                                                    LiRNASEQ_evergrande

Description
--------------------
The LiRNASEQ_evergrande is used to analyze single cell RNA Seq experiments, generated by the Evergrande Center for Immunologic Diseases  

    Usage:
        Run.py [-h] [-p P] [-g G] [-t T] [-time TIME] [-bc BC] [-ul UL] [-b B] [-r R]
        
    Arguments:
        -h
            produces - 
            -p P        path of the project
            -g G        genome
            -t T        transcriptome
            -time Time  amount of time to run the experiment
            -bc BC	Barcode length(plus the UMI length)
            -u U        UMI Length
            -b B        Name of Bed File
            -r R        Location of Rda files
        -p 
            directory path of the genome
        -t
            transcriptome
        -time Time
            How long processing will take?
        -bc BC
            Barcode length including the umi length
        -u
            UMI length
        -b B
            Name of Bed File  
        -R R
            Location of Rda files            
    Example
        python ./RUN.py -p /home/ad249/immdiv-bioinfo/evergrande/yael/FC_01744/Project_yael/mouse_S9-S10 -g
        /groups/immdiv-bioinfo/evergrande/yael/genomes/NOD_custom_mm10/genome -t
        /groups/immdiv-bioinfo/evergrande/yael/genomes/NOD_custom_mm10/known_mm10 -time 36 -bc 12 -u 4 -b known_mm10_exons.bed
        -r /groups/cbdm_lab/dp133/scripts/allon_scripts/
        
References
--------------------
	David Puyraimond-Zemmour - Harvard Medical School
  	Ashley Sun - Harvard Medical School
	Jiang, Yu-Shan - Harvard Medical School
  	Alos Diallo - Harvard Medical School
  	Evergrande Center for Immunologic Diseases
  	http://evergrande.hms.harvard.edu/
