# Build and environment guide

## Why this project uses separate environments

LAMMPS is a compiled molecular-dynamics program, while the force models in this portfolio are Python packages built on different PyTorch, CUDA, DGL and PyTorch-Geometric versions.

The ML-GNNP integration embeds Python inside LAMMPS. The Python interpreter used when compiling a LAMMPS binary therefore matters. A binary linked to one Conda environment cannot safely be assumed to load every other model stack.

The practical solution is:

1. Keep incompatible model families in separate Conda environments.
2. Build or provide a LAMMPS executable for each environment.
3. Record the executable path in `config.env`.
4. Run `scripts/doctor.sh` before starting a simulation.

## Source expectation

The examples target a LAMMPS source tree containing the `ML-GNNP` package with:

```text
src/ML-GNNP/gnnp_driver.py
src/ML-GNNP/pair_gnnp.cpp
src/ML-GNNP/pair_gnnp.h
```

The development workstation used the `mace` branch of [`ACEsuit/lammps`](https://github.com/ACEsuit/lammps). This is a specialist integration and should not be confused with every standard LAMMPS release.

## Common CMake pattern

Activate the target Conda environment before configuring LAMMPS:

```bash
conda activate <environment>

cmake -S /path/to/lammps/cmake -B /path/to/build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=mpicc \
  -DCMAKE_CXX_COMPILER=mpicxx \
  -DPKG_ML-GNNP=on \
  -DPKG_PYTHON=on \
  -DPKG_OPENMP=on \
  -DPython_EXECUTABLE="$CONDA_PREFIX/bin/python"

cmake --build /path/to/build --parallel
```

The exact flags can vary with the LAMMPS branch, MPI implementation and GPU toolchain. Treat this as the reproducible pattern, not a universal binary recipe.

## Environment starting points

```bash
conda env create -f environments/mace.yml
conda env create -f environments/matgl-sevennet.yml
conda env create -f environments/mattersim-orb.yml
conda env create -f environments/fairchem.yml
```

GPU-enabled PyTorch, DGL and PyTorch-Geometric wheels must match the CUDA runtime on the target machine. Install those platform-specific wheels before treating an environment as production-ready.

## Configure executable paths

```bash
cp .env.example config.env
```

Example:

```bash
LAMMPS_ROOT="$HOME/src/lammps"
GNNP_ROOT="$LAMMPS_ROOT/src/ML-GNNP"
MACE_LMP_BIN="$HOME/builds/lammps-mace/lmp"
MATGL_LMP_BIN="$HOME/builds/lammps-matgl/lmp"
SEVENNET_LMP_BIN="$HOME/builds/lammps-matgl/lmp"
MATTERSIM_LMP_BIN="$HOME/builds/lammps-mattersim/lmp"
ORB_LMP_BIN="$HOME/builds/lammps-mattersim/lmp"
EQV2M_LMP_BIN="$HOME/builds/lammps-fairchem/lmp"
```

Then check each integration:

```bash
bash scripts/doctor.sh --model mace
bash scripts/doctor.sh --model matgl
bash scripts/doctor.sh --model sevennet
```

## Locally observed package versions

These versions document the development workstation; they are not a claim that other combinations are unsupported.

| Environment | Observed packages |
|---|---|
| `mace-env` | Current local binary exposed an incompatible `mace-torch 0.3.15` / `torch 2.1.2` combination; the environment file uses a compatible starting point instead |
| `mlff_matgl_sevenn` | `matgl 1.3.0`, `sevenn 0.11.2.post1` |
| `mlff_mattersim_orb` | `mattersim 1.2.0`, development `orb-models` |
| `mlff_fairchem` | `fairchem-core 1.3.0` |

## Troubleshooting

### Python module missing

The selected LAMMPS binary and the activated environment probably do not refer to the same Python installation. Run:

```bash
bash scripts/doctor.sh --model <model>
```

### CUDA library or symbol errors

Confirm the NVIDIA driver, CUDA runtime and PyTorch wheel are compatible. Rebuild the model-specific LAMMPS binary after changing environments.

### Model downloads fail

Some pretrained models download their weights on first use. Check network access, cache permissions and the provider’s current model name.

### Simulation runs but results are implausible

The integration test only proves that software executed. Validate energies, forces, structures and trajectories against trusted reference data before using the model scientifically.
