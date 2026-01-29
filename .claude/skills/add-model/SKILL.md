---
name: add-model
description: Add a new pathology foundation model to the README from a paper PDF. Use when the user asks to add a model, paper, or feature extractor to the list, or mentions a new paper in the papers/ directory.
---

# Add Model from Paper

Add a new pathology foundation model to `README.md` by extracting information from its paper PDF and associated GitHub repository.

The user will provide the title of the paper. If they don't provide the title, ask them to provide it.

## Workflow

### Step 1: Find the Paper

Search `papers/` for PDF files:

```bash
ls papers/*.pdf
```

Choose the PDF file that matches the title provided by the user (filename might be slightly different, so use common sense).

**Note**: Some papers have multiple PDFs—one for the main text and one for supplementary materials. These are named sensibly (e.g., `ModelName.pdf` and `ModelName_supplementary.pdf`). Be sure to read both if available, as supplementary materials often contain important details like training hyperparameters, dataset statistics, and architecture specifics not found in the main paper.

### Step 2: Read the Paper Thoroughly

Read the entire PDF to extract model information. Key sections to examine:

- **Abstract**: Model name, SSL method, high-level approach
- **Methods/Architecture**: Architecture details, training procedure, loss functions
- **Datasets**: Training data sources, number of WSIs, tiles, patients
- **Experimental Setup/Implementation Details**: Batch size, epochs/iterations, input size, GPU setup
- **Results/Ablations**: Verify numbers refer to the main model, not ablation variants

**Critical**: When extracting training details (batch size, epochs, etc.), verify the context:

- Ensure values refer to the **main model**, not comparison baselines or ablations
- Check if "each model" phrases include comparison methods trained for fair evaluation
- Distinguish between pretraining settings and downstream task settings

### Step 3: Check the GitHub Repository

If the paper mentions a GitHub URL:

1. Fetch the repository README to find:
   - Model weights availability (checkmark or x)
   - Hugging Face links
   - Additional technical details not in paper
   - First commit date (for "Released" date)

2. Look for model config files that may specify:
   - Embedding dimensions
   - Architecture variants
   - Input sizes

> **Tip**: If information is missing from the paper, use web search to check additional sources:
>
> - **Hugging Face**: Model cards often include architecture details, embedding dimensions, and input sizes
> - **GitHub**: README, config files, and model code may have details not in the paper
> - **Press releases**: Company/institution announcements sometimes include dataset sizes or release dates
> - **arXiv versions**: Check if newer versions of the paper have additional details in appendices
> - **Blog posts**: Authors sometimes write accompanying blog posts with extra technical details
> - Any other sources you can find

### Step 4: Determine the Table

The README has two tables:

| Table                                  | Criteria                                                           |
| -------------------------------------- | ------------------------------------------------------------------ |
| **Patch-level models**                 | Produces patch/tile embeddings (most models)                       |
| **Slide-level / patient-level models** | Produces WSI-level or patient-level embeddings without supervision |

### Step 5: Extract All Fields

For **patch-level models**, extract these fields:

| Field         | Description                     | Notes                                        |
| ------------- | ------------------------------- | -------------------------------------------- |
| Name          | Model name with paper link      | Use `**bold**` if >100K WSIs                 |
| Group         | Research group/institution      | Link to lab website if available             |
| Weights       | `:white_check_mark:` or `:x:`   | Check GitHub/HuggingFace                     |
| Released      | Date + link to first release    | Format: `Mon YYYY[*](link)`                  |
| SSL           | Self-supervised learning method | Link to paper if novel method                |
| WSIs          | Number of whole-slide images    | Use `**bold**` if >100K; round to 2 sig figs |
| Tiles         | Number of patches/tiles         | Round to 2 sig figs                          |
| Patients      | Number of patients/cases        | Leave blank if not reported                  |
| Batch size    | Training batch size             | Leave blank if not reported                  |
| Iterations    | Training iterations or epochs   | Use "X epochs" or "XK" for iterations        |
| Architecture  | Model architecture              | e.g., ResNet-50, ViT-B, ViT-L                |
| Parameters    | Number of parameters            | e.g., 86M, 632M                              |
| Embed dim     | Output embedding dimension      | e.g., 768, 1024, 2048                        |
| Input size    | Input image size                | Usually 224                                  |
| Magnification | Effective magnification         | See "Inferring Magnification" section below  |
| Dataset       | Training dataset names          | e.g., TCGA, PAIP, proprietary                |
| Links         | GitHub and/or HuggingFace icons | See format below                             |

For **slide-level models**, the fields differ slightly (no Tiles column, has Patch size instead).

### Step 6: Format the Row

Use this format for links:

```markdown
[<img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/svgs/brands/github.svg" width="20">](GITHUB_URL)
[<img src="https://huggingface.co/datasets/huggingface/brand-assets/resolve/main/hf-logo.svg" width="25">](HF_URL)
```

Mark vision-language models with `(VL)` after the name.

### Step 7: Insert in Chronological Order

Models are ordered by release date. Find the correct position and insert the new row.

### Step 8: Verify Accuracy

Cross-check extracted values:

1. Re-read relevant paper sections to confirm numbers
2. Verify GitHub README matches paper claims
3. Ensure batch size/epochs refer to main model training, not ablations
4. Check that patient counts are for pretraining data, not evaluation sets

### Inferring Magnification

Magnification is the **effective magnification** at which the model sees tissue during pretraining. This is often not directly stated and must be calculated. The README explains:

> If patches are obtained at 20x with patch size 1024 but resized to 224 before being fed to the model, the effective magnification is 20x × (224/1024) ≈ 4.4x.

#### When Magnification CANNOT Be Determined

**Critical**: Before attempting to calculate magnification, verify that the training data comes from **standardized WSI patches at known magnifications**. Magnification **cannot** be meaningfully calculated when:

- Training images are **published figures** from papers, textbooks, or educational materials (unknown original magnifications)
- Training data is **image-caption pairs** scraped from PubMed, educational resources, or similar sources
- The paper explicitly states images come from **diverse sources** without controlled extraction parameters
- Training uses **natural images** mixed with pathology (e.g., some vision-language models)

**Example**: CONCH is trained on 1.17M image-caption pairs from educational resources and PubMed Central figures—these are published images at unknown/variable magnifications, not WSI patches extracted at controlled magnifications. Even though the model uses iBOT with known crop scales, the source image magnifications are undocumented, making effective magnification impossible to calculate.

In such cases:

1. **Leave the magnification field blank** in README.md
2. **Document in NOTES.md** why magnification cannot be determined, including what data sources the model uses

#### When Magnification CAN Be Calculated

Magnification can only be calculated when all of the following are known:

1. **Patch extraction magnification** (e.g., 20x, or convert from MPP: 0.5 MPP = 20x, 1 MPP = 10x)
2. **Patch size** at extraction (e.g., 1024×1024)
3. **Input size** to the model (e.g., 224×224)
4. **Data augmentation details**, especially random crop parameters

**Important**: Be thorough when investigating augmentations. Check the **underlying SSL framework's repository**, not just the model's paper:

- If a model is "built on MoCo v2", check [MoCo's main_moco.py](https://github.com/facebookresearch/moco/blob/main/main_moco.py) for `RandomResizedCrop` parameters
- If "similar to SimCLR", check [SimCLR's data_util.py](https://github.com/google-research/simclr/blob/master/data_util.py) for `area_range`
- MoCo v1/v2 uses `scale=(0.2, 1.0)`, SimCLR uses `scale=(0.08, 1.0)`

**For models with random crops**, the effective magnification is a range:

- At `scale=1.0` (full image): `base_mag × (input_size / patch_size)`
- At `scale=0.2`: `base_mag × (input_size / (√0.2 × patch_size))`

Example for 1024px patches at 20x with MoCo v2 augmentation to 224px:

- At scale=1.0: 20x × (224/1024) ≈ 4.4x
- At scale=0.2: 20x × (224/458) ≈ 9.8x
- Report as: **~4-10x**

**Important**: Do not perform calculations mentally. Use bash Python or another tool to perform the calculations.

### Step 9: Document Inferred Values in NOTES.md

For values that required inference or calculation (not directly stated in paper/code), add a brief explanation to `NOTES.md`. This provides transparency for how difficult-to-find values were derived.

Only document values that:

- Required calculation (e.g., magnification from patch size + augmentation)
- Were inferred from multiple sources
- Involved checking upstream repositories (e.g., SSL framework code)

The order of models in `NOTES.md` should match their order in `README.md` (chronological by release date).

Keep notes concise—one bullet point per inferred value. Example:

```markdown
## ModelName

- **Magnification (~4-10x)**: Patches are 1024×1024 at 20x. Built on MoCo v2 which uses `RandomResizedCrop(224, scale=(0.2, 1.0))`. At scale=1.0: 20x × (224/1024) ≈ 4.4x; at scale=0.2: 20x × (224/458) ≈ 9.8x.
```

### Step 10: Report Findings to User

After adding the row, provide the user with a detailed summary of your findings. For **every column** in the row, include:

1. **Value**: The value you added (or state that you couldn't find it)
2. **Source quote**: A direct quote from the PDF or GitHub that supports this value
3. **Reasoning**: Brief explanation of how you determined this value from the quote

Format each field like this:

```
**Field Name**: [value]
- Quote: "[exact quote from paper/GitHub]" (Section X.X / GitHub README)
- Reasoning: [explanation of how you derived the value from the quote]
```

If a value was not found, explain:

- What sections you checked
- Why the information appears to be unreported

If a value required inference or calculation (e.g., computing tiles from WSIs × tiles-per-WSI), show your work.

This transparency helps the user verify accuracy and catch any misinterpretations.

## Example Row

```markdown
| [ModelName](https://paper-url) | [Lab Name](https://lab-url) | :white_check_mark: | Jan 2024[\*](https://arxiv.org/abs/XXXX.XXXXXv1) | DINOv2 | 50K | 100M | 10K | 1024 | 100 epochs | ViT-B | 86M | 768 | 224 | TCGA | [<img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/svgs/brands/github.svg" width="20">](https://github.com/org/repo) |
```

## Conventions

- Round WSIs, tiles, patients to 2 significant figures (e.g., 14,325,848 → 14M)
- Use `K` for thousands, `M` for millions, `B` for billions
- Bold model name and WSI count if trained on >100K slides
- Use `INE` suffix for "ImageNet epochs" if applicable
- Leave cells blank (not "N/A") for unreported values
- Add `**` note in row if a value was inferred from other numbers
