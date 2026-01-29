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

## Lunit-DINO

- **Magnification (~9-28x)**: Table 1 and Section 4.1 state patches are 512×512 at both 20x and 40x magnification. Section B.4 confirms DINO uses standard augmentation: `global_crops_scale=(0.4, 1.0)` for 224px crops. From 20x patches at scale=1.0: 20x × (224/512) = 8.75x; from 40x patches at scale=0.4: 40x × (224/(√0.4×512)) = 27.7x. Combined range: ~9-28x.

## Lunit-{BT,MoCoV2,SwAV}

- **Magnification (~9-62x)**: Patches are 512×512 at both 20x and 40x (Table 1, Section 4.1). Section B.4 confirms standard SSL augmentation recipes are followed. Each method has different `RandomResizedCrop` scales:
  - MoCo v2: `scale=(0.2, 1.0)` → ~9-39x
  - SwAV: `scale=(0.14, 1.0)` for global crops → ~9-47x
  - Barlow Twins: `scale=(0.08, 1.0)` → ~9-62x
  
  The full range spanning all three methods is ~9-62x. Base calculation: from 20x at scale=1.0: 20x × (224/512) = 8.75x; from 40x at scale=0.08 (BT): 40x × (224/(√0.08×512)) = 61.9x.
