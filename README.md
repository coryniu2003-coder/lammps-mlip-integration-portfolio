# From Machine Learning Models to Molecular Dynamics

[![Shell checks](https://github.com/coryniu2003-coder/lammps-mlip-integration-portfolio/actions/workflows/checks.yml/badge.svg)](https://github.com/coryniu2003-coder/lammps-mlip-integration-portfolio/actions/workflows/checks.yml)
[![Project demo](https://img.shields.io/badge/demo-GitHub%20Pages-16697a)](https://coryniu2003-coder.github.io/lammps-mlip-integration-portfolio/)

This repository shows how I connected seven machine-learning models to LAMMPS and turned them into reproducible molecular-dynamics workflows.

It is written for two audiences:

- **Recruiters and non-specialists** can use the overview and [visual project demo](https://coryniu2003-coder.github.io/lammps-mlip-integration-portfolio/) to understand the problem and my contribution.
- **Technical users** can reuse the shell scripts, environment definitions, LAMMPS inputs and provenance records on their own workstation.

## The problem in plain English

Materials simulations need to calculate the force on every atom many thousands of times.

- **DFT (density functional theory)** is a quantum-mechanical method that can provide accurate energies and forces, but it is usually too expensive for long or large simulations.
- **MLIPs (machine-learned interatomic potentials)** learn an approximation to those quantum-mechanical calculations. Once trained, they can predict forces much faster.
- **LAMMPS** is a molecular-dynamics engine. It repeatedly asks a force model for atomic forces and then advances the atoms through time.

The difficult practical step is connecting each ML model to LAMMPS with the correct software versions, model weights, inputs and runtime environment. This repository makes that integration visible and reusable.

```text
DFT reference calculations
          |
          v
machine-learning force model
          |
          v
LAMMPS molecular dynamics
          |
          v
trajectory + thermodynamic log
          |
          v
analysis, validation and provenance
```

> This repository is a deployment portfolio. It does not run DFT calculations or train every model from scratch, and it does not redistribute private data or large model checkpoints.

## What I built

- A common interface for seven model families.
- Isolated Conda environments for incompatible Python and CUDA stacks.
- Model-specific LAMMPS input examples.
- A reusable shell launcher that creates clean output directories.
- Pre-flight checks that fail early when a dependency is missing.
- Provenance records containing the model, command, structure checksum and run parameters.
- Lightweight Python post-processing for LAMMPS thermodynamic output.

## Quick start

### 1. Clone and inspect the available models

```bash
git clone https://github.com/coryniu2003-coder/lammps-mlip-integration-portfolio.git
cd lammps-mlip-integration-portfolio
bash scripts/list_models.sh
```

### 2. Configure your machine

```bash
cp .env.example config.env
```

Edit `config.env` so it points to your LAMMPS source tree, ML-GNNP directory and model-specific LAMMPS binaries. See [the build guide](builds/README.md) if those binaries do not exist yet.

### 3. Check one model before running

```bash
bash scripts/doctor.sh --model matgl
```

The check confirms that the selected binary, Python environment and ML-GNNP driver are available.

### 4. Generate or run a demo

Generate the complete LAMMPS input and provenance record without launching:

```bash
bash scripts/run_demo.sh --model matgl --dry-run
```

Run the four-atom Argon smoke test:

```bash
bash scripts/run_demo.sh --model matgl
```

No model is silently selected. Replace `matgl` with any id printed by `scripts/list_models.sh`.

## Reuse with another material

Supply a LAMMPS atomic data file and list the chemical elements in atom-type order:

```bash
bash scripts/run_demo.sh \
  --model sevennet \
  --structure /path/to/nacl.lammps \
  --elements "Na Cl" \
  --temperature 1000 \
  --steps 5000
```

Important constraints:

1. The chosen pretrained model must support every element.
2. `--elements` must follow the atom-type order in the LAMMPS data file.
3. A successful run is not proof of physical accuracy. Results should be validated against reference data in the intended temperature, pressure and structural regime.

## What a run produces

Every run is isolated under `runs/<model>_<timestamp>/`:

```text
command.txt             exact launch command
provenance.txt          model, environment and structure checksum
run.in                  generated LAMMPS input
log.lammps              thermodynamic history
trajectory.lammpstrj    atomic trajectory
thermo.csv              parsed thermodynamic table
thermo_summary.png      temperature and energy overview
```

This layout is designed to answer a basic reproducibility question: **which model and exact input produced this trajectory?**

## Supported integrations

| Id | Model family | Environment | Portfolio status |
|---|---|---|---|
| `mace` | MACE MP0 | `mace-env` | Configuration example |
| `chgnet` | CHGNet | `base` | Configuration example |
| `matgl` | MatGL / M3GNet | `mlff_matgl_sevenn` | Tested locally |
| `sevennet` | SevenNet | `mlff_matgl_sevenn` | Tested locally |
| `mattersim` | MatterSim | `mlff_mattersim_orb` | Tested locally |
| `orb` | ORB | `mlff_mattersim_orb` | Tested locally |
| `eqv2m` | EquiformerV2-M | `mlff_fairchem` | Configuration example |

“Tested locally” means the integration was exercised on the development workstation. It does not imply that every package combination will work on different CUDA, driver or operating-system versions.

## Dependency strategy

There is deliberately no single file that pretends to install the full stack.

- [`requirements.txt`](requirements.txt) contains lightweight analysis tools.
- [`environment.yml`](environment.yml) creates the common portfolio environment.
- [`environments/`](environments/) contains model-family starting points.
- [`builds/README.md`](builds/README.md) explains why separate LAMMPS binaries may be required.

## Repository map

```text
docs/            static project demo for GitHub Pages
environments/    model-family Conda environment definitions
models/          model registry and reference LAMMPS inputs
scripts/         reusable shell launcher, diagnostics and post-processing
structures/      small public smoke-test structures
builds/          LAMMPS and environment guidance
```

## Scope and limitations

- Model checkpoints may download from their original providers.
- CUDA and PyTorch builds are platform-specific.
- Some integrations rely on a development ML-GNNP driver rather than a standard LAMMPS package.
- The included Argon case checks software integration only; it is not a scientific validation benchmark.
- Production molecular dynamics requires independent physical validation.

## Author

**Cory Niu**
MPhys studies completed at the University of Edinburgh; awaiting formal graduation. Open to graduate roles in scientific software, machine learning, data and computational science.

[GitHub profile](https://github.com/coryniu2003-coder) · [LinkedIn](https://www.linkedin.com/in/cory-niu-014559359/) · [Email](mailto:coryniu2003@gmail.com)
