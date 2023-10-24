#!/bin/bash -l

#This is an example of a job that works with an MPI installation of LAMMPS on an HPC infrastructure
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=72
#SBATCH --account=cosmo
#SBATCH --cpus-per-task=1
#SBATCH --job-name=L6-200K

module load gcc/11.3.0 cmake/3.23.1 openmpi/4.1.3 python/3.10.4
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

source $PWD/../i-pi/env.sh
source $PWD/../plumed-librascal/sourceme.sh

rm /tmp/ipi_*

LAMMPS=$PWD/../lammps-librascal/build/lmp

i-pi input_NST_MTS.xml & sleep 5;\
srun ${LAMMPS} -in ipi.in.lmp

