# LAMMPS + Machine-Learned Potentials Portfolio

This repository collects the seven ML force-field integrations I built around the
LAMMPS `ML-GNNP` driver. Each folder is self-contained with a smoke-test input,
structure file and environment notes so the setups can be reproduced or used as
starting points for future projects.

## Directory layout

- `builds/` - CMake recipes and Conda environment snippets for the specialised LAMMPS binaries.
- `models/` - Per-model input decks (`run_short.in`) and docs.
- `structures/` - Shared structures used by the demos (`li_mno2.lammps`).

## Supported models

| Model | `pair_coeff` payload | LAMMPS binary | Python env |
| ----- | -------------------- | ------------- | ---------- |
| CHGNet v0.3.0 | `chgnet 0.3.0 Ar` | `build-cpu/lmp` | base (`chgnet==0.3.0`) |
| MACE MP0 | `mace medium-mpa-0 Ar` | `build-cpu/lmp` | base (`mace-torch`) |
| EquiformerV2-M | `fairchem EquiformerV2-86M-OMat Ar` | `build-mlff_fairchem/lmp_mlff_fairchem` | `mlff_fairchem` (`fairchem-core==1.3.0`) |
| MatGL M3GNet | `matgl M3GNet-MP-2021.2.8-PES Ar` | `build-mlff_matgl_sevenn/lmp_mlff_matgl_sevenn` | `mlff_matgl_sevenn` |
| SevenNet | `sevennet 7net-0 Ar` | `build-mlff_matgl_sevenn/lmp_mlff_matgl_sevenn` | `mlff_matgl_sevenn` |
| MatterSim | `mattersim MatterSim-v1.0.0-1M Ar` | `build-mlff_mattersim_orb/lmp_mlff_mattersim_orb` | `mlff_mattersim_orb` |
| ORB v2 | `orb orb-v2 Ar` | `build-mlff_mattersim_orb/lmp_mlff_mattersim_orb` | `mlff_mattersim_orb` |

All inputs expect a `-var gnnp_root` argument pointing at your `ML-GNNP` source
inside the LAMMPS tree, e.g.

```bash
lmp_binary -var gnnp_root /path/to/lammps/src/ML-GNNP -in run_short.in
```

The smoke tests run 2,000 steps with a 0.5 fs timestep; extend them for production workflows.

## Build & environment setup

See `builds/README.md` for the exact CMake invocations and the Conda environments
bound to each binary. The builds are intentionally split so heavyweight
dependencies (MatGL/SevenNet, MatterSim/ORB, FAIR-Chem) stay isolated.

## Reusing the inputs

1. Clone LAMMPS and enable the ML-GNNP package.
2. Create the Conda environments following `builds/README.md`.
3. Compile the required LAMMPS binaries.
4. Copy or symlink the `models/*` folders into your working directory.
5. Launch the smoke tests to verify the setup, then customise the decks for your systems.
