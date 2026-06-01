# MatterSim

Microsoft's MatterSim interatomic potential driven through ML-GNNP.

## Prerequisites

- LAMMPS binary built in the `mlff_mattersim_orb` environment.
- Python packages: `mattersim==1.2.0`, `torch==2.8.0+cu128`.
- The default pretrained weights auto-download to `~/.local/mattersim/pretrained_models/`.

## Run

```bash
lmp_binary=/path/to/build-mlff_mattersim_orb/lmp_mlff_mattersim_orb
gnnp_root=/path/to/lammps/src/ML-GNNP

conda run -n mlff_mattersim_orb $lmp_binary -var gnnp_root $gnnp_root -in run_short.in
```

Thermo history lands in `log.mattersim_short`; trajectory in `xyz_short.lammpstrj`.

Set `MATTERSIM_LOG_ENQUEUE=1` only if you need asynchronous logging (disabled in this layout to avoid semaphore issues).
