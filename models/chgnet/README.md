# CHGNet (v0.3.0)

Graph neural network potential from the Ceder Group deployed through the LAMMPS `ML-GNNP` driver.

## Prerequisites

- LAMMPS built with `PKG_ML-GNNP=on`, `PKG_PYTHON=on`, `PKG_OPENMP=on` (see `../../builds/README.md`).
- Python environment with `chgnet==0.3.0` accessible to the LAMMPS binary (the base Anaconda environment works in this setup).

## Run

```bash
lmp_binary=/path/to/build-cpu/lmp
gnnp_root=/path/to/lammps/src/ML-GNNP

$lmp_binary -var gnnp_root $gnnp_root -in run_short.in
```

Output files:

- `log.chgnet_short` - thermo history.
- `xyz_short.lammpstrj` - trajectory.

Increase the `run` command inside `run_short.in` for production trajectories.
