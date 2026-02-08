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

## Phikon

- **Magnification (~20-35x)**: Section 3.2 states tiles are extracted at 20× magnification (0.5 μm/px) with a fixed size of 224×224 pixels. Section 3.1 describes multi-crop augmentation: "two global crops [...] are sampled within a proportion of (32%, 100%) [...] of the original image size" and "Global [...] crops are resized to 224 × 224 pixels". At scale=1.0: 20x × (224/224) = 20x; at scale=0.32: 20x × (224/(√0.32×224)) = 35.4x.

## CONCH

- **Magnification: Not determinable.** Unlike other models that extract patches from WSIs at controlled magnifications, CONCH's pretraining data consists of 1.17M image-caption pairs from diverse published sources:
  - Educational resources (textbooks, teaching materials)
  - PubMed Central Open Access figures
  - In-house BWH data

  These are published figures at unknown and variable magnifications, not standardized WSI patches. The paper explicitly notes CONCH did not use public slide collections like TCGA, PAIP, or GTEx. While the iBOT vision encoder uses global crop scale (0.32, 1.0) with 224×224 output (Supplementary Table 33), the source image magnifications are not documented or controlled, making effective magnification impossible to calculate.

## Virchow

- **Magnification (~20-35x)**: Methods section states WSIs are scanned at 20x (0.5 MPP) and non-overlapping 224×224 tiles are extracted directly. DINOv2 default hyperparameters are used, which includes `global_crops_scale=(0.32, 1.0)` with 224×224 output. At scale=1.0: 20x × (224/224) = 20x; at scale=0.32: 20x × (224/(√0.32×224)) = 20x × (224/126.7) ≈ 35x.

## Campanella et al. (DINO)

- **Magnification (~20-32x)**: Methods section states slides were scanned at 0.25 MPP and "tissue tiles were extracted from each slide at 0.5 MPP resolution" (i.e., 20x). The paper explicitly states: "The SSL algorithms were cloned directly from their official GitHub repositories. Unless specified, no changes were made to the code except for customizing the data loading procedures." The official DINO repository uses `global_crops_scale=(0.4, 1.0)` with 224×224 output. At scale=1.0: 20x × (224/224) = 20x; at scale=0.4: 20x × (224/(√0.4×224)) = 20x × (224/141.7) ≈ 31.6x.

## Campanella et al. (MAE)

- **Magnification (~20-45x)**: Same tile extraction as DINO variant—0.5 MPP (20x). The official MAE repository uses `RandomResizedCrop(224, scale=(0.2, 1.0))`. At scale=1.0: 20x × (224/224) = 20x; at scale=0.2: 20x × (224/(√0.2×224)) = 20x × (224/100.2) ≈ 44.7x.

## Path Foundation

- **Magnification (~2-32x)**: Methods section states patches are "sampled evenly across multiple magnifications, including 5⨉ (~2 μm/pixel), 10⨉ (~1 μm/pixel), and 20⨉ (~0.5 μm/pixel)." Supplementary Table 1a shows original patch size is 256×256 with RandomResizedCrop scale (0.3, 1.0) to 224×224. SimCLR-best uses 512×512 patches (Table 3). At 5x with 512px patches, scale=1.0: 5x × (224/512) = 2.2x. At 20x with 256px patches, scale=0.3: 20x × (224/(√0.3×256)) = 32x.

## UNI

- **Magnification (~9-25x)**: Methods section states patches are extracted at 256×256 at 20x (main training) and 512×512 at 20x (high-resolution fine-tuning in last 12,500/125,000 iterations). Supplementary Table 5 shows DINOv2 uses `global_crops_scale=(0.48, 1.0)` with 224×224 output.
  - Main training (256px, 90% of iterations): At scale=1.0: 20x × (224/256) = 17.5x; at scale=0.48: 20x × (224/177) = 25.3x → ~18-25x
  - High-res fine-tuning (512px, 10% of iterations): At scale=1.0: 20x × (224/512) = 8.8x; at scale=0.48: 20x × (224/355) = 12.6x → ~9-13x
  - Combined range: ~9-25x

## PathoDuet

- **Magnification (~18-124x)**: Section 4.1 states patches are 256×256 "under the highest magnification level" from TCGA. TCGA slides have mixed magnifications (20x or 40x). The code (`main_moco.py`) uses BYOL-style augmentation with `RandomResizedCrop(224, scale=(0.08, 1.0))`.
  - For 20x slides: At scale=1.0: 20x × (224/256) = 17.5x; at scale=0.08: 20x × (224/72.4) = 61.9x → ~18-62x
  - For 40x slides: At scale=1.0: 40x × (224/256) = 35x; at scale=0.08: 40x × (224/72.4) = 124x → ~35-124x
  - Combined range across all slides: ~18-124x

## RudolfV

- **Magnification (~18-31x)**: Patches are 256×256 at 0.5 MPP (20x). Methods Section 4.1: "The patch size is 256 × 256 pixels at 0.5 mpp." Built on DINOv2 with default `global_crops_scale=(0.32, 1.0)` and `global_crops_size=224`. The paper explicitly lists augmentation modifications (stain augmentation, 90° rotations, flips, solarization removal) but does not change the crop scale. At scale=1.0: 20x × (224/256) = 17.5x; at scale=0.32: 20x × (224/144.8) = 30.9x.

## kaiko

- **Magnification (~4-62x)**: Patches are 256×256 extracted at four magnification levels: 5×, 10×, 20×, and 40× (Section IV-C: "random sampling of 256×256 patches" and "training encompasses multiple magnification levels, specifically 5×, 10×, 20×, and 40×"). The ViT-L14 model uses DINOv2 with default `global_crops_scale=(0.32, 1.0)` and `global_crops_size=224`. The paper states deviations from default DINOv2 recipe but does not modify crop scales. At 5× scale=1.0: 5 × (224/256) = 4.4x; at 40× scale=0.32: 40 × (224/144.8) = 61.9x.

## PLUTO

- **Magnification (~5-71x)**: Tiles are extracted at four resolutions: 40× (0.25 mpp), 20× (0.5 mpp), 10× (1 mpp), and 5× (2 mpp) (Section 2.2). Tile extraction pixel size is not explicitly stated in the paper, but inferred to be 224×224 based on: the paper's use of "224 × 224 image tile" as the canonical example (Section 2.1), throughput measurement with "tile size of 224 × 224" (Section 4.4), and the model input size of 224. Training is described as "consistent with DINOv2 training" (Section 3.2), with "Two global crops and four local crops of sizes 224 and 96 respectively." DINOv2 default augmentation uses `RandomResizedCrop(224, scale=(0.32, 1.0))`. At 5× scale=1.0: 5 × (224/224) = 5.0x; at 40× scale=0.32: 40 × (224/126.7) = 70.7x.

## BEPH

- **Magnification (~40-89x)**: Patches are 224×224 extracted at 40x magnification (GitHub README: "cropped into 224×224 tiles at 40X magnification"). The pre-training framework is BEiTv2 via mmselfsup. The training config (`beitv2_vit.py`) uses `RandomResizedCropAndInterpolationWithTwoPic(size=224, scale=(0.2, 1.0))`. At scale=1.0: 40x × (224/224) = 40x; at scale=0.2: 40x × (224/100.2) ≈ 89.4x.
