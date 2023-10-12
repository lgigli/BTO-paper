#This job works with a serial installation of LAMMPS (no MPI)
source ../plumed-librascal/sourceme.sh

rm /tmp/ipi_*

IPI=$PWD/../i-pi/bin/i-pi
LAMMPS=$PWD/../lammps-librascal/build/lmp

${IPI} input_NST_MTS.xml & sleep 5;\
${LAMMPS} -in ipi.in.lmp

