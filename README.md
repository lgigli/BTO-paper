# BTO-paper

[![DOI](https://zenodo.org/badge/702389161.svg)](https://zenodo.org/doi/10.5281/zenodo.10036255)
[![plumID:23.043](https://www.plumed-nest.org/eggs/23/043/badge.svg)](https://www.plumed-nest.org/eggs/23/043/)

> L. Gigli, A. Goscinski, M. Ceriotti and G. A. Tribello, “Modeling the ferroelectric phase transition in barium titanate with DFT accuracy and converged sampling”, arXiv:2310.12579 (2023)
< https://doi.org/10.48550/arXiv.2310.12579 >.

### Dependencies

The following dependencies must be fulfilled by librascal

| Package     | Required version   |
|-------------|--------------------|
| gcc (g++)   | 4.9 or higher      |
| cmake       | 2.8 or higher      |
| Python      | 3.7 or higher      |
| cython      | 0.29.33 or higher  |

### i-Pi

```bash
git clone https://github.com/i-pi/i-pi.git
```
We used commit [46ff069](https://github.com/i-pi/i-pi/commit/46ff069) for the results of the paper.

### Building lammps with librascal interface

One can install the lammps-librascal interface by first cloning our lammps fork

```bash
git clone --single-branch --branch feat/rascal_integration_draft \
        https://github.com/agoscinski/lammps.git lammps-librascal
```
For the results of the paper the commit [e1860405](https://github.com/agoscinski/lammps/pull/1/commits/e18604056bcd703ad9661a8de00c988b8ebbfecc) has been used. Then the librascal repository needs to be cloned into the lammps `src` folder.
The interface on the librascal side is implemented in branch `feat/lammps_preparations`.
```bash
cd lammps-librascal/src
git clone --single-branch --branch feat/lammps_preparations \
        https://github.com/lab-cosmo/librascal.git
cd ..
```
For the results of the paper the commit [879cb59](https://github.com/lab-cosmo/librascal/pull/367/commits/879cb5942a40577ea005842227712848f361ab7f) has been used. We have hardcoded the librascal dependency into the [lammps-librascal/cmake/CMakesLists.txt line 128 to 150](https://github.com/agoscinski/lammps/blob/e18604056bcd703ad9661a8de00c988b8ebbfecc/cmake/CMakeLists.txt#L128-L150). So we do not need to add extra flags to the lammps compilation. We build lammps using
```
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=Release -D PKG_USER-MISC=on ../cmake
make
cd ../..
```
The package `PKG_USER-MISC` is needed to use `i-Pi` with lammps. If you want to have a parallel LAMMPS installation, please add the option `-D BUILD_MPI=yes`.

### PLUMED

We first clone the PLUMED fork with the librascal interface
```bash
git clone --single-branch --branch hack-the-tree \
        https://github.com/agoscinski/plumed2.git plumed-librascal
```
We used commit [124c83c](https://github.com/agoscinski/plumed2/commit/124c83c00e4bfc2e4a104cef888830981124e3f8) of PLUMED for the results of the paper. Now we clone a custom version of librascal in the main PLUMED folder.
```bash
cd plumed-librascal
git clone --single-branch --branch feat/plumed \
        https://github.com/lab-cosmo/librascal.git librascal
```
We used commit [ed1112ee](https://github.com/lab-cosmo/librascal/commit/ed1112eefca577832b29ef0ceb34714e6a8ebe66) of the branch for the results of the paper. Then we build librascal using
```bash
cd librascal
mkdir build
cd build
cmake ..
make
cd ../..
```

and then PLUMED using
```bash
LIBRASCAL_PATH=$PWD/librascal
./configure CXX=g++ --enable-cxx=14 --enable-modules=all --enable-fftw=no --enable-mpi=no --enable-asmjit --enable-rascal LDFLAGS="-L$LIBRASCAL_PATH/build/external/wigxjpf/lib -lwigxjpf -L$LIBRASCAL_PATH/build/src -lrascal" CPPFLAGS="-I$LIBRASCAL_PATH/src/ -I$LIBRASCAL_PATH/build/external/Eigen3/ -I$LIBRASCAL_PATH/build/external/wigxjpf/inc"
make
```
You can test if the code correctly compiled with
```bash
source sourceme.sh
cd regtest/rascal/rt-perovskite
make
cat tmp/CV1
```
The output should be
```
#! FIELDS time CV1
 0.000000 7.338286e+02
```
Please also check that plumed can be imported as a python module with
```bash
import plumed
```
 otherwise i-PI will not be able to call plumed while running the simulation. If this import does not succeed at this stage, plumed has not produced a python wrapper in the installation, which means that you are either missing a python or a cython installation.

The `metad-example/` folder contains the setup of a metadynamics run with the full i-pi/lammps/plumed/rascal stack to simulate the cubic-tetragonal phase transition of barium titanate (see Gigli et al., <https://doi.org/10.48550/arXiv.2310.12579> for additional information).
