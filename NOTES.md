# Notes on Inferred Values

This document explains how certain values in the `README.md` tables were derived when they were not explicitly stated in the original papers. These calculations are based on information from the papers, official code repositories, and standard practices in the field.

## RetCCL

- **Magnification (~4-10x)**: Patches are 1024×1024 at 20x. Built on MoCo v2 which uses `RandomResizedCrop(224, scale=(0.2, 1.0))`. At scale=1.0: 20x × (224/1024) ≈ 4.4x; at scale=0.2: 20x × (224/458) ≈ 9.8x.
