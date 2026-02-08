---
name: add-magnification
description: Calculate and add the effective magnification for a pathology foundation model already listed in the README. Use when the user asks to add magnification for a model that is already in the table.
---

# Add Magnification

Calculate and add the **effective magnification** for a pathology foundation model that is already listed in `README.md`. The magnification column should currently be blank for this model.

## Prerequisites

First, follow the **`read-paper`** skill (`.claude/skills/read-paper/SKILL.md`) to find and thoroughly read the paper. Pay special attention to:

- **Patch extraction details**: magnification or MPP at which patches were extracted
- **Patch size**: the pixel dimensions of extracted patches (e.g., 256×256, 512×512, 1024×1024)
- **Input size**: the size patches are resized to before being fed to the model (e.g., 224×224)
- **Data augmentation**: especially `RandomResizedCrop` parameters (scale range)
- **SSL framework**: which self-supervised method was used, as its default augmentations apply

Then return here to calculate and add the magnification.

## Understanding Effective Magnification

Magnification is the **effective magnification** at which the model sees tissue during pretraining. This is often not directly stated and must be calculated. The README explains:

> If patches are obtained at 20x with patch size 1024 but resized to 224 before being fed to the model, the effective magnification is 20x × (224/1024) ≈ 4.4x.

## Workflow

### Step 1: Determine Whether Magnification Can Be Calculated

**Critical**: Before attempting to calculate magnification, verify that the training data comes from **standardized WSI patches at known magnifications**. Magnification **cannot** be meaningfully calculated when:

- Training images are **published figures** from papers, textbooks, or educational materials (unknown original magnifications)
- Training data is **image-caption pairs** scraped from PubMed, educational resources, or similar sources
- The paper explicitly states images come from **diverse sources** without controlled extraction parameters
- Training uses **natural images** mixed with pathology (e.g., some vision-language models)

**Example**: CONCH is trained on 1.17M image-caption pairs from educational resources and PubMed Central figures—these are published images at unknown/variable magnifications, not WSI patches extracted at controlled magnifications. Even though the model uses iBOT with known crop scales, the source image magnifications are undocumented, making effective magnification impossible to calculate.

If magnification cannot be determined:

1. **Leave the magnification field blank** in README.md
2. **Document in NOTES.md** why magnification cannot be determined, including what data sources the model uses
3. **Report to the user** why magnification could not be calculated

### Step 2: Gather the Required Values

Magnification can only be calculated when **all** of the following are known:

1. **Patch extraction magnification** (e.g., 20x, or convert from MPP: 0.5 MPP ≈ 20x, 1 MPP ≈ 10x)
2. **Patch size** at extraction (e.g., 1024×1024)
3. **Input size** to the model (e.g., 224×224)
4. **Data augmentation details**, especially random crop parameters

### Step 3: Investigate Augmentation Pipeline

**Important**: Be thorough when investigating augmentations. Check the **underlying SSL framework's repository**, not just the model's paper:

- If a model is "built on MoCo v2", check [MoCo's main_moco.py](https://github.com/facebookresearch/moco/blob/main/main_moco.py) for `RandomResizedCrop` parameters
- If "similar to SimCLR", check [SimCLR's data_util.py](https://github.com/google-research/simclr/blob/master/data_util.py) for `area_range`
- MoCo v1/v2 uses `scale=(0.2, 1.0)`, SimCLR uses `scale=(0.08, 1.0)`

Also check:

- The model's own GitHub repo for custom augmentation code
- Config files or training scripts that may override framework defaults
- The paper's methods section or appendix for augmentation details

### Step 4: Calculate Effective Magnification

**Important**: Do not perform calculations mentally. Use bash Python or another tool to perform the calculations.

**For models without random crops** (or where patches are simply resized):

```
effective_mag = base_mag × (input_size / patch_size)
```

**For models with random crops**, the effective magnification is a range:

- At `scale=1.0` (full image): `base_mag × (input_size / patch_size)`
- At `scale=S_min`: `base_mag × (input_size / (√S_min × patch_size))`

Example for 1024px patches at 20x with MoCo v2 augmentation (`scale=(0.2, 1.0)`) to 224px input:

- At scale=1.0: 20x × (224/1024) ≈ 4.4x
- At scale=0.2: 20x × (224/(√0.2 × 1024)) ≈ 20x × (224/458) ≈ 9.8x
- Report as: **~4-10x**

### Step 5: Update README.md

Find the model's existing row in `README.md` and fill in the magnification column with the calculated value.

### Step 6: Document in NOTES.md

Add a magnification note to `NOTES.md` under the model's section. The order of models in `NOTES.md` should match their order in `README.md` (chronological by release date).

Keep the note concise. Example:

```markdown
## ModelName

- **Magnification (~4-10x)**: Patches are 1024×1024 at 20x. Built on MoCo v2 which uses `RandomResizedCrop(224, scale=(0.2, 1.0))`. At scale=1.0: 20x × (224/1024) ≈ 4.4x; at scale=0.2: 20x × (224/458) ≈ 9.8x.
```

If magnification could not be determined, document why:

```markdown
## ModelName

- **Magnification (N/A)**: Training data consists of image-caption pairs from PubMed and educational resources. Source image magnifications are unknown/variable, so effective magnification cannot be calculated.
```

### Step 7: Report Findings to User

Provide the user with a detailed explanation of the magnification calculation:

1. **Value**: The magnification you added (or explain why it couldn't be determined)
2. **Source quotes**: Direct quotes supporting each input value (patch extraction magnification, patch size, input size, augmentation parameters)
3. **Calculation**: Show the full calculation with all intermediate steps
4. **Sources checked**: List all sources you checked (paper sections, GitHub repos, SSL framework code, etc.)

Format like this:

```
**Magnification**: [value]
- Patch extraction: [mag/MPP] — "[quote]" (source)
- Patch size: [size] — "[quote]" (source)
- Input size: [size] — "[quote]" (source)
- Augmentation: [details] — "[quote or code reference]" (source)
- Calculation: [show work]
```
