---
name: read-paper
description: Find and thoroughly read a pathology foundation model paper from the papers/ directory. Use as a prerequisite before adding model information or magnification to the README.
---

# Read Paper

Find and thoroughly read a pathology foundation model paper PDF from the `papers/` directory, and gather supplementary information from GitHub and other sources.

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
