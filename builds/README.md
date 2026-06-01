# LAMMPS build & environment guide

Each machine-learned potential lives in a dedicated Conda environment that is baked into the LAMMPS build via `Python_EXECUTABLE`. Keeping the environments separate avoids version conflicts between Torch/DGL variants.

All builds share the same flags:

- `-DCMAKE_C_COMPILER=mpicc`
- `-DCMAKE_CXX_COMPILER=mpicxx`
- `-DPKG_ML-GNNP=on -DPKG_PYTHON=on -DPKG_OPENMP=on`
- `-DPython_EXECUTABLE=$CONDA_PREFIX/bin/python`

From the build directory run `cmake --build . --parallel` and optionally `cmake --install .`.

> Adjust the MPI compiler wrappers if you prefer a serial build (`gcc`, `g++`). For GPU acceleration add `-DPKG_GPU=on` and rebuild after configuring CUDA.

## 1. Baseline build (`build-cpu/lmp`) - CHGNet & MACE

This binary is linked against the base Anaconda environment. Install the Python packages once:

```bash
conda activate base
pip install chgnet==0.3.0 mace-torch==0.3.6
```

Then configure and build:

```bash
mkdir -p ~/lammps/build-cpu
cd ~/lammps/build-cpu
cmake ../cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=mpicc \
  -DCMAKE_CXX_COMPILER=mpicxx \
  -DPKG_ML-GNNP=on -DPKG_PYTHON=on -DPKG_OPENMP=on \
  -DPython_EXECUTABLE=$(which python)
cmake --build . --parallel
```

## 2. `mlff_matgl_sevenn` environment - MatGL & SevenNet

Create the environment (CUDA 12.1 stack as used on this machine):

```bash
conda create -n mlff_matgl_sevenn python=3.11
conda activate mlff_matgl_sevenn
pip install --index-url https://download.pytorch.org/whl/cu121 torch==2.1.0 torchvision==0.16.0
pip install dgl==2.1.0+cu121 -f https://data.dgl.ai/wheels/cu121/repo.html
pip install matgl==1.3.0 sevenn==0.11.2.post1
```

Configure LAMMPS while the environment is active:

```bash
mkdir -p ~/lammps/build-mlff_matgl_sevenn
cd ~/lammps/build-mlff_matgl_sevenn
cmake ../cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=mpicc \
  -DCMAKE_CXX_COMPILER=mpicxx \
  -DPKG_ML-GNNP=on -DPKG_PYTHON=on -DPKG_OPENMP=on \
  -DPython_EXECUTABLE=$CONDA_PREFIX/bin/python
cmake --build . --parallel
```

The resulting binary is referenced as `lmp_mlff_matgl_sevenn` in the model READMEs.

## 3. `mlff_mattersim_orb` environment - MatterSim & ORB

This environment carries a newer CUDA 12.8 PyTorch build:

```bash
conda create -n mlff_mattersim_orb python=3.11
conda activate mlff_mattersim_orb
pip install --index-url https://download.pytorch.org/whl/cu128 torch==2.8.0 torchvision==0.19.0
pip install mattersim==1.2.0 orb-models==0.5.5
```

Configure & build:

```bash
mkdir -p ~/lammps/build-mlff_mattersim_orb
cd ~/lammps/build-mlff_mattersim_orb
cmake ../cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=mpicc \
  -DCMAKE_CXX_COMPILER=mpicxx \
  -DPKG_ML-GNNP=on -DPKG_PYTHON=on -DPKG_OPENMP=on \
  -DPython_EXECUTABLE=$CONDA_PREFIX/bin/python
cmake --build . --parallel
```

Run the resulting `lmp_mlff_mattersim_orb` under `conda run -n mlff_mattersim_orb` so the dynamic libraries resolve correctly.

## 4. `mlff_fairchem` environment - EquiformerV2 (eqV2-M)

FAIR-Chem relies on PyTorch Geometric; the following pip installs mirror the working setup:

```bash
conda create -n mlff_fairchem python=3.11
conda activate mlff_fairchem
pip install --index-url https://download.pytorch.org/whl/cu128 torch==2.8.0 torchvision==0.19.0
pip install --find-links https://data.pyg.org/whl/torch-2.8.0+cu128.html torch-scatter torch-sparse torch-cluster torch-spline-conv
pip install fairchem-core==1.3.0
```

Configure & build:

```bash
mkdir -p ~/lammps/build-mlff_fairchem
cd ~/lammps/build-mlff_fairchem
cmake ../cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=mpicc \
  -DCMAKE_CXX_COMPILER=mpicxx \
  -DPKG_ML-GNNP=on -DPKG_PYTHON=on -DPKG_OPENMP=on \
  -DPython_EXECUTABLE=$CONDA_PREFIX/bin/python
cmake --build . --parallel
```

Place the EquiformerV2 checkpoint under `src/ML-GNNP/fairchem-omat24/` or adjust `pair_coeff path ...`.

## 5. `mace-env` rebuild - GPU MACE (Ar/Si/Na)

The MACE driver is compiled against a CUDA-enabled Torch build. Recreate the environment whenever you refresh the binary:

```bash
conda create -n mace-env python=3.10
conda activate mace-env
conda install --solver classic -c conda-forge ase h5py
conda install --solver classic libabseil=20240116.2 libprotobuf=4.25.3
pip install --extra-index-url https://download.pytorch.org/whl/cu121 \
  "torch==2.1.2" "torchvision==0.16.2" "torchaudio==2.1.2"
```

Then rebuild the dedicated LAMMPS binary (`~/lammps/build-mace_mliap`):

```bash
cd ~/lammps/build-mace_mliap
cmake ../cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=mpicc \
  -DCMAKE_CXX_COMPILER=mpicxx \
  -DCMAKE_CXX_STANDARD=17 \
  -DPKG_ML-GNNP=on -DPKG_PYTHON=on -DPKG_OPENMP=on \
  -DPKG_ML-IAP=on -DPKG_ML-MACE=on -DPKG_ML-SNAP=on \
  -DPython_EXECUTABLE=$CONDA_PREFIX/bin/python \
  -DPython_INCLUDE_DIR=$CONDA_PREFIX/include/python3.10 \
  -DPython_LIBRARY=$CONDA_PREFIX/lib/libpython3.10.so \
  -DMKL_INCLUDE_DIR=$CONDA_PREFIX/include \
  -DMKL_LIBRARY=$CONDA_PREFIX/lib/libmkl_rt.so \
  -DTorch_DIR=$CONDA_PREFIX/lib/python3.10/site-packages/torch/share/cmake/Torch
cmake --build . --parallel
```

`model-setups/mace_mp0` and `model-setups_Na/mace_mp0` both call this binary via `build-mace_env/lmp_mace_env.sh`, so keeping the environment and build in sync ensures CUDA is available across all structures.

After each build, add the binary to your `PATH` or reference it directly in the per-model instructions. Always launch the runs through `conda run -n <env>` when the linked environment is not the currently activated one.
