# ORB v2

Orbital Materials' ORB potential deployed with ML-GNNP.

## Prerequisites

- LAMMPS binary linked against the `mlff_mattersim_orb` environment.
- Python packages: `orb-models==0.5.5`, `torch==2.8.0+cu128`.
- Default checkpoint downloads to `~/.cache/orb_models/`; use the `path` variant in `pair_coeff` for custom weights.

## Run

```bash
lmp_binary=/path/to/build-mlff_mattersim_orb/lmp_mlff_mattersim_orb
gnnp_root=/path/to/lammps/src/ML-GNNP

conda run -n mlff_mattersim_orb $lmp_binary -var gnnp_root $gnnp_root -in run_short.in
```

Outputs:

- `log.orb_short`
- `xyz_short.lammpstrj`

Adjust `pair_coeff` to point at alternative ORB checkpoints when required.
