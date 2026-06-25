# SevenNet integration

SevenNet is an equivariant graph neural-network potential. This example uses the `7net-0` pretrained model through ML-GNNP.

```bash
bash scripts/doctor.sh --model sevennet
bash scripts/run_demo.sh --model sevennet
```

The development setup used `sevenn 0.11.2.post1` in `mlff_matgl_sevenn`. Alternative checkpoints require changing the pair payload in `models/registry.tsv`.
