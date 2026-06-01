# MACE Materials Project MP0

Medium-sized MACE model (`medium-mpa-0`) accessed via the ML-GNNP driver.

## Prerequisites

- LAMMPS compiled with ML-GNNP support (see `../../builds/README.md`).
- Python environment containing `mace-torch` so the driver can load the MP0 checkpoint (automatically cached under `~/.cache/mace/`).

## Run

```bash
lmp_binary=/path/to/build-cpu/lmp
gnnp_root=/path/to/lammps/src/ML-GNNP

$lmp_binary -var gnnp_root $gnnp_root -in run_short.in
```

Artifacts:

- `log.mace_mp0_short` - thermo log.
- `xyz_short.lammpstrj` - trajectory (every 10 steps).

Tune the timestep or total steps as needed for your system.
