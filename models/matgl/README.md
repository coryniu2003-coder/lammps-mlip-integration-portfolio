# MatGL (M3GNet)

MatGL's pretrained M3GNet PES accessed via ML-GNNP.

## Prerequisites

- LAMMPS binary linked against the `mlff_matgl_sevenn` environment.
- Python packages: `matgl==1.3.0`, `torch==2.1.0+cu121`, `dgl==2.1.0`, `sevenn==0.11.2.post1` (SevenNet shares the same environment).

## Run

```bash
lmp_binary=/path/to/build-mlff_matgl_sevenn/lmp_mlff_matgl_sevenn
gnnp_root=/path/to/lammps/src/ML-GNNP

conda run -n mlff_matgl_sevenn $lmp_binary -var gnnp_root $gnnp_root -in run_short.in
```

Named outputs:

- `log.matgl_short`
- `xyz_short.lammpstrj`

Point `pair_coeff` to another MatGL checkpoint if desired.
