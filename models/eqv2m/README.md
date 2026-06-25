# EquiformerV2-M integration

EquiformerV2 is an equivariant transformer model distributed through FAIR-Chem. This configuration requests the medium OMat model.

```bash
bash scripts/doctor.sh --model eqv2m
bash scripts/run_demo.sh --model eqv2m
```

The environment starting point uses `fairchem-core 1.3.0`. This entry is labelled a **configuration example** until a clean-machine checkpoint download and full smoke test are repeated.
