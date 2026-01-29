# Notes on Inferred Values

This document explains how certain values in the `README.md` tables were derived when they were not explicitly stated in the original papers. These calculations are based on information from the papers, official code repositories, and standard practices in the field.

## CTransPath

- **Magnification (~4-10x)**: Paper Section 4.1 states patches are 1024×1024 at 20x. GitHub repo `datasets/dataset.py` shows `RandomResizedCrop(image_size, scale=(0.2, 1.0))`. At scale=1.0: 20x × (224/1024) ≈ 4.4x; at scale=0.2: 20x × (224/458) ≈ 9.8x.

## RetCCL

- **Magnification (~4-10x)**: Patches are 1024×1024 at 20x. Built on MoCo v2 which uses `RandomResizedCrop(224, scale=(0.2, 1.0))`. At scale=1.0: 20x × (224/1024) ≈ 4.4x; at scale=0.2: 20x × (224/458) ≈ 9.8x.

## HIPT

- **Magnification (~18-28x)**: Paper Section 3.3 states patches are 256×256 at 20x ("extracted at 20× objective"). HIPT uses the DINO framework with default augmentation parameters: `global_crops_scale=(0.4, 1.0)` with output size 224. At scale=1.0: 20x × (224/256) = 17.5x; at scale=0.4: 20x × (224/161.9) = 27.7x. Rounded to ~18-28x for global views (which the teacher network receives).

## REMEDIS

- **Magnification (multi-scale)**: Paper Methods section explicitly states: "In the pathology tasks, to capture details specifically present in high-resolution pathology slides, we obtained patches from various magnification levels." Unlike other models that extract patches at a fixed magnification, REMEDIS intentionally used multi-scale patch extraction. The specific magnification levels and their distribution are not reported. Input size is 224×224 with SimCLR augmentation (`area_range=(0.08, 1.0)`).
