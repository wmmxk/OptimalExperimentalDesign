#!/bin/bash
#SBATCH -p med
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem-per-cpu 2000
#SBATCH -t 10:00:00
#SBATCH -o log/slurm.%N.%j.out
#SBATCH -e log/slurm.%N.%j.err

module load R
cd ../Random
srun -n 1 Rscript 1_All_in_one.R 4 30 500 9 real 48 true relative
