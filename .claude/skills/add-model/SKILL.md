---
name: add-model
description: Add a new pathology foundation model to the README (excluding magnification). Use when the user asks to add a model, paper, or feature extractor to the list, or mentions a new paper in the papers/ directory.
---

# Add Model to README

Add a new pathology foundation model row to `README.md` by extracting information from its paper PDF and associated GitHub repository. This skill covers all fields **except magnification**, which is handled separately by the `add-magnification` skill.

## Prerequisites

First, follow the **`read-paper`** skill (`.claude/skills/read-paper/SKILL.md`) to find and thoroughly read the paper. Then return here to add the model row.

## Workflow

### Step 1: Determine the Table

The README has two tables:

| Table                                  | Criteria                                                           |
| -------------------------------------- | ------------------------------------------------------------------ |
| **Patch-level models**                 | Produces patch/tile embeddings (most models)                       |
| **Slide-level / patient-level models** | Produces WSI-level or patient-level embeddings without supervision |

### Step 2: Extract All Fields

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
| Magnification | **Leave blank**                 | Will be added separately via `add-magnification` skill |
| Dataset       | Training dataset names          | e.g., TCGA, PAIP, proprietary                |
| Links         | GitHub and/or HuggingFace icons | See format below                             |

For **slide-level models**, the fields differ slightly (no Tiles column, has Patch size instead).

### Step 3: Format the Row

Use this format for links:

```markdown
[<img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/svgs/brands/github.svg" width="20">](GITHUB_URL)
[<img src="https://huggingface.co/datasets/huggingface/brand-assets/resolve/main/hf-logo.svg" width="25">](HF_URL)
```

Mark vision-language models with `(VL)` after the name.

### Step 4: Insert in Chronological Order

Models are ordered by release date. Find the correct position and insert the new row.

### Step 5: Verify Accuracy

Cross-check extracted values:

1. Re-read relevant paper sections to confirm numbers
2. Verify GitHub README matches paper claims
3. Ensure batch size/epochs refer to main model training, not ablations
4. Check that patient counts are for pretraining data, not evaluation sets

### Step 6: Document Inferred Values in NOTES.md

For values that required inference or calculation (not directly stated in paper/code), add a brief explanation to `NOTES.md`. This provides transparency for how difficult-to-find values were derived.

Only document values that:

- Were inferred from multiple sources
- Required combining information from different parts of the paper
- Involved checking upstream repositories or external sources

The order of models in `NOTES.md` should match their order in `README.md` (chronological by release date).

Keep notes concise—one bullet point per inferred value.

### Step 7: Report Findings to User

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

**Note**: Remind the user that magnification was left blank and can be added using the `add-magnification` skill.

## Example Row

```markdown
| [ModelName](https://paper-url) | [Lab Name](https://lab-url) | :white_check_mark: | Jan 2024[\*](https://arxiv.org/abs/XXXX.XXXXXv1) | DINOv2 | 50K | 100M | 10K | 1024 | 100 epochs | ViT-B | 86M | 768 | 224 | | TCGA | [<img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/svgs/brands/github.svg" width="20">](https://github.com/org/repo) |
```

## Conventions

- Round WSIs, tiles, patients to 2 significant figures (e.g., 14,325,848 → 14M)
- Use `K` for thousands, `M` for millions, `B` for billions
- Bold model name and WSI count if trained on >100K slides
- Use `INE` suffix for "ImageNet epochs" if applicable
- Leave cells blank (not "N/A") for unreported values
- Add `**` note in row if a value was inferred from other numbers
