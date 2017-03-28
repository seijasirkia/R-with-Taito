#!/bin/bash -l
#SBATCH -J r_multi_proc
#SBATCH -o output_%j.txt
#SBATCH -e errors_%j.txt
#SBATCH -t 00:04:00
#SBATCH --ntasks=2
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=4000

module load r-env saga
srun RMPISNOW --no-save -f Calc_contours_snow.R
