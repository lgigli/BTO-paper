#!/bin/bash -l

#SBATCH --time=24:00:00
#SBATCH --partition=normal
#SBATCH --nodes=1
#SBATCH --ntasks=128
#SBATCH --account=mr31
#SBATCH --cpus-per-task=1
#SBATCH --constraint=mc
#SBATCH --job-name=L6-200K

module load PrgEnv-gnu/8.3.3 cray-python/3.9.12.1 gcc/11.2.0 CMake/3.22.1
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

export PYTHONPATH="$PYTHONPATH:../librascal/build/"
export PYTHONPATH="$PYTHONPATH:../plumed2/"


source ../plumed2/sourceme.sh

rm /tmp/ipi_*

IPI=../i-pi/bin/i-pi
LAMMPS=../lammps-librascal/build/lmp

srun -n 1 --mem-per-cpu=500M --exclusive ${IPI} input_NST_MTS.xml & sleep 5;\
srun -n 126 --mem-per-cpu=500M --exclusive ${LAMMPS} -in ipi.in.lmp

