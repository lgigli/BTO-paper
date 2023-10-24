#This job works with a serial installation of LAMMPS (no MPI)

source $PWD/../i-pi/env.sh
source $PWD/../plumed-librascal/sourceme.sh

rm /tmp/ipi_*

LAMMPS=$PWD/../lammps-librascal/build/lmp

i-pi input_NST_MTS.xml & sleep 5;\
${LAMMPS} -in ipi.in.lmp

