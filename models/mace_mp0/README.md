# MACE MP0 integration

MACE is an equivariant graph neural-network force model. This example requests the pretrained `medium-mpa-0` model.

```bash
bash scripts/doctor.sh --model mace
bash scripts/run_demo.sh --model mace
```

This entry is labelled a **configuration example** because the latest local audit found an incompatible `mace-torch 0.3.15` / `torch 2.1.2` runtime. The environment file uses a compatible `mace-torch 0.3.14` / `torch 2.4.1` starting point that must be used when rebuilding the linked LAMMPS binary.
