#!/bin/bash
#SBATCH -J r_job
#SBATCH -o output.txt
#SBATCH -e errors.txt
#SBATCH -t 0:01:00
#SBATCH -p test
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=1000
#
module load r-env
srun Rscript --no-save simplercode.R
