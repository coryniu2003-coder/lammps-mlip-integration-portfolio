# ORB integration

ORB is a graph-based force model from Orbital Materials. This configuration requests the `orb-v2` base model.

```bash
bash scripts/doctor.sh --model orb
bash scripts/run_demo.sh --model orb
```

The development workstation used a development `orb-models` build. ORB checkpoint formats can change between versions, so the runtime check is essential before reusing a custom checkpoint.
