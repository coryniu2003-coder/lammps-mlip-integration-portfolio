# EquiformerV2-M (eqV2-M)

FAIR-Chem EquiformerV2 medium checkpoint driven through ML-GNNP.

## Prerequisites

- LAMMPS binary built against the `mlff_fairchem` Conda environment (Python executable passed to CMake; see `../../builds/README.md`).
- `fairchem-core==1.3.0` with its Torch/torch-geometric dependencies.
- Checkpoint `eqV2_86M_omat.pt` copied into `ML-GNNP/fairchem-omat24/` or another path referenced by `pair_coeff`.

## Run

```bash
lmp_binary=/path/to/build-mlff_fairchem/lmp_mlff_fairchem
gnnp_root=/path/to/lammps/src/ML-GNNP

$lmp_binary -var gnnp_root $gnnp_root -in run_short.in
```

Outputs:

- `log.eqv2m_short`
- `xyz_short.lammpstrj`

Extend the `run` length for production workloads once the smoke test passes.
