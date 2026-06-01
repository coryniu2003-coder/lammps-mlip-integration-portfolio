# SevenNet

SevenNet multi-fidelity potential running under the same build as MatGL.

## Prerequisites

- LAMMPS built with the `mlff_matgl_sevenn` toolchain.
- Python environment `mlff_matgl_sevenn` containing `sevenn==0.11.2.post1` and its CUDA-enabled Torch stack.

## Run

```bash
lmp_binary=/path/to/build-mlff_matgl_sevenn/lmp_mlff_matgl_sevenn
gnnp_root=/path/to/lammps/src/ML-GNNP

conda run -n mlff_matgl_sevenn $lmp_binary -var gnnp_root $gnnp_root -in run_short.in
```

Outputs:

- `log.sevennet_short`
- `xyz_short.lammpstrj`

Switch the `pair_coeff` payload to target other SevenNet checkpoints when needed (`pair_coeff * * sevennet 7net-mf-ompa ...`).
