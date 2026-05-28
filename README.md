# pi-metaboqc-casestudy
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)

**A Comprehensive Case Study Repository Validating the Robustness and Reproducibility of the `pi-metaboqc` Pipeline across Diverse High-Throughput Metabolomics Datasets.**

> 🔗 **Main Repository**: **[pi-metaboqc](https://github.com/KaikunXu/pi-metaboqc/)**

---

## 💡 Key Design Principles

To ensure that the results presented in our publication are completely transparent and easily reproducible, this repository contains:
- **Diverse Real-World & Benchmark Datasets**: Includes actual metabolomics datasets generated in-house and benchmark data from published tools. Both the originally downloaded raw datasets and the fully pre-processed versions are provided.
- **Transparent Data Preparation**: We provide all data cleaning and formatting scripts used to convert raw matrices into the standardized input formats required by `pi-metaboqc`. 
- **Highly Organized Project Structure**: All ready-to-run data is systematically categorized by project under the `data/processed/` directory. Each project directory is self-contained with its specific matrices, metadata, and a dedicated `pipeline_parameters.toml` configuration file.
- **Project-Specific Analytical Notebooks**: For every dataset, you will find a dedicated, interactive Jupyter Notebook that executes the complete `pi-metaboqc` analytical pipeline under the `scripts/evaluation` directory, providing step-by-step demonstrations and embedded diagnostic visualizations.

---

## 📁 Project Structure

```text
pi-metaboqc-casestudy/
├── README.md                 # Project documentation and quick-start guide
├── requirements.txt          # Explicitly pinned dependencies for reproducibility
├── data/                     # Data directory (structured by dataset)
│   ├── raw/                  # Original downloaded data from resouces
│   │   ├── MetNormalizer/
│   │   ├── SERFF/
│   │   ├── notame/
│   │   ├── WaveICA/
│   │   └── hRUV_BioHeart/
│   └── processed/            # Pre-processed input data ready for pi-metaboqc
│       ├── MetNormalizer/    -> Contains intensity and meta files & config file
│       │   ├───project_intensity.csv
│       │   ├───project_meta.csv
│       │   └───pipeline_parameters.toml
│       └── ...
├── scripts/                  # Source code for preparation and evaluation
│   ├── data_preparation/     # Scripts to clean and format raw data or each dataset
│   └── evaluation/           # Jupyter Notebooks executing the pi-metaboqc pipeline
└── results/                  # Empty placeholder. Local execution will populate this 
                              # with high-res figures and Markdown QC reports.
```

---

## 🚀 Getting Started & Reproduction Guide

Clone this repository and install the required dependencies (ensure you have installed the core `pi-metaboqc` module first).

### Step 1: Environment Setup

```bash
git clone https://github.com/KaikunXu/pi-metaboqc-casestudy.git
cd pi-metaboqc-casestudy

# We strongly recommend using an isolated virtual environment (e.g., conda)
pip install -r requirements.txt
```

### Step 2: Data Acquisition

**🎉 Out-of-the-box Ready:** To provide the smoothest experience possible, all required raw metabolomics datasets have been completely pre-packaged and included directly within this repository. 

You can find the original raw matrices (e.g., `.rda` files, unstructured CSVs) already organized in their respective project folders under the `data/raw/` directory. **No external downloading is required**, allowing you to seamlessly trace the entire workflow from the very beginning.

### Step 3: Data Preparation (Optional)

**🎉 Good news:** To provide a seamless, out-of-the-box experience, we have **already pre-processed** the raw matrices. The meticulously formatted `project_intensity.csv` and `project_meta.csv` are readily available inside each dataset's folder within `data/processed/`. **You can safely skip this step and proceed directly to Step 4.**

**For Absolute Transparency & Reproducibility:** If you wish to trace exactly how the raw data (e.g., `.rda` files or unstructured CSVs) were cleaned and converted into the standardized `pi-metaboqc` input format, you can review or re-execute the exact scripts/notebooks located in `scripts/data_preparation/`. Re-running these scripts will yield outputs identical to the pre-packaged files in the `processed` directory.

### Step 4: Pipeline Execution & Evaluation

Navigate to the `scripts/evaluation/` directory. Here you will find dataset-specific Jupyter Notebooks (e.g., `SERRF_pipeline.ipynb`).
The outputs of each pipeline execution will be saved in the `results/` directory.

---

## 📦 Datasets Overview

### 1. pi-metaboqc Dataset

**Link:**

+ [pi-metaboqc GitHub Repository](https://github.com/KaikunXu/pi-metaboqc)
+ [pi-metaboqc Demo Data GitHub Repository](https://github.com/KaikunXu/pi-metaboqc-casestudy)

**Data Characteristics:** This dataset is the demo data of the `pi-metaboqc` module, acquired in **positive** ionization mode, comprising a total of **376** detected mass spectral features across **466** injections. To ensure quantification fidelity and monitor system stability, a suite of **5** internal standards (including CA-d4, CDCA-d4, Choline-d4, Phenylalanine-d5, Carnitine C10:0-d3) was systematically incorporated into the experimental design. The sample cohort is strategically distributed across **3** analytical batches, processed in the sequential order of **B1 → B2 → B3**. Specifically, the cohort consists of **398** actual biological samples, **44** pooled Quality Control (QC) samples, and **24** blank samples, establishing a robust foundation for downstream noise removal.

| Batch | Total |  QC  | Blank | Sample | Inject Order |
| :---: | :---: | :--: | :---: | :----: | :----------: |
|  B1   |  154  |  14  |   8   |  132   |   1 ~ 169    |
|  B2   |  155  |  14  |   8   |  133   |  170 ~ 338   |
|  B3   |  157  |  16  |   8   |  133   |  339 ~ 541   |
|  All  |  466  |  44  |  24   |  398   |      /       |

### 2. MetNormalizer Dataset

**Source:** Normalization and integration of large-scale metabolomics data using support vector regression (***Metabolomics***, 2016)

**Link:**

+ [MetNormalizer GitHub Repository](https://github.com/jaspershen/MetNormalizer)
+ [demoData GitHub Repository](https://github.com/jaspershen/demoData/tree/master/inst/MetNormalizer)

**Data Characteristics:** This dataset originates from the study developing MetNormalizer, an R package utilizing Support Vector Regression (SVR) for large-scale metabolomics data normalization. The dataset comprises a total of **1351** detected mass spectral features across **177** injections. The sample cohort is distributed within **1** analytical batch. Specifically, the cohort consists of **154** actual biological samples and **23** pooled QC samples.

|  Batch  | Total |  QC  | Sample | Inject Order |
| :-----: | :---: | :--: | :----: | :----------: |
| Batch-1 |  177  |  23  |  154   |   1 ~ 177    |

### 3. SERRF Dataset

**Source:** Systematic Error Removal Using Random Forest for Normalizing Large-Scale Untargeted Lipidomics Data (***Anal. Chem.***, 2019)

**Link:** [SERRF Online Tool & Data](https://slfan2013.github.io/SERRF-online/#)

**Data Characteristics:** This dataset is derived from a large-scale untargeted metabolomics study acquired in **negative ion mode**. The dataset comprises a total of **268** detected mass spectral features across **1299** injections. The sample cohort is strategically distributed across **4** analytical batches, processed in the sequential order of **Batch-A → Batch-B → Batch-C → Batch-D**.  Specifically, the cohort consists of **1174** actual biological samples and **125** pooled QC samples.

|  Batch  | Total |  QC  | Sample | Inject Order |
| :-----: | :---: | :--: | :----: | :----------: |
| Batch-A |  335  |  32  |  303   |   1 ~ 335    |
| Batch-B |  336  |  33  |  303   |  336 ~ 671   |
| Batch-C |  335  |  32  |  303   |  672 ~ 1006  |
| Batch-D |  293  |  28  |  265   | 1007 ~ 1299  |
|   All   | 1299  | 125  |  1174  |      /       |

### 4. notame Dataset

**Source:** "Notame": Workflow for Non-Targeted LC–MS Metabolic Profiling (***Metabolites***, 2020)

**Link:** [notame GitHub Repository](https://github.com/hanhineva-lab/notame)

**Data Characteristics:** The `toy_notame_set` is a representative dataset provided within the `notame` R/Bioconductor package ecosystem. It comprises a total of **80** detected mass spectral features (**merged positive and negative ion modes**) across **50** injections. The sample cohort is strategically distributed across **2** analytical batches, processed in the sequential order of **Batch-1 → Batch-2**.  Specifically, the cohort consists of **40** actual biological samples and **10** pooled QC samples.

|  Batch  | Total |  QC  | Sample | Inject Order |
| :-----: | :---: | :--: | :----: | :----------: |
| Batch-1 |  25   |  5   |   20   |    1 ~ 25    |
| Batch-2 |  25   |  5   |   20   |   26 ~ 50    |
|   All   |  50   |  10  |   40   |      /       |

### 5. WaveICA 2.0 Dataset

**Source:** WaveICA 2.0: a novel batch effect removal method for untargeted metabolomics data without using batch information (***Metabolomics***, 2021)

**Link:** [WaveICA 2.0 GitHub Repository](https://github.com/dengkuistat/WaveICA_2.0)

**Data Characteristics:** This dataset features complex, non-linear instrumental signal drift. The original WaveICA 2.0 algorithm was designed to extract and remove these complex technical variations using wavelet analysis without explicitly relying on batch labels. The dataset comprises a total of **6402** detected mass spectral features across **729** injections. The sample cohort is strategically distributed across **4** analytical batches, processed in the sequential order of **Batch-1 → Batch-2 → Batch-3 → Batch-4**.  Specifically, the cohort consists of **644** actual biological samples and **85** pooled QC samples.

|  Batch  | Total |  QC  | Sample | Inject Order |
| :-----: | :---: | :--: | :----: | :----------: |
| Batch-1 |  217  |  25  |  192   |   1 ~ 217    |
| Batch-2 |  217  |  25  |  192   |  218 ~ 434   |
| Batch-3 |  208  |  24  |  184   |  435 ~ 642   |
| Batch-4 |  87   |  11  |   76   |  643 ~ 733   |
|   All   |  729  |  85  |  644   |      /       |

### 6. hRUV BioHeart Dataset

**Source:** A hierarchical approach to removal of unwanted variation for large-scale metabolomics data (***Nat Commun***, 2021)

**Link:** 

+ [hRUV GitHub Repository](https://sydneybiox.github.io/hRUV/)
+ [BioHEART Data GitHub Repository](https://github.com/SydneyBioX/BioHEART_metabolomics)

**Data Characteristics:** This dataset originates from the BioHEART-CT cohort and was utilized to demonstrate `hRUV` R package, a hierarchical algorithm designed to remove unwanted variation in large-scale metabolomics studies. Consequently, only pooled QC and actual biological samples were retained.

The dataset represents a massive analytical undertaking, comprising a total of **100** detected mass spectral features across **1166** injections. The sample cohort is strategically distributed across **15** analytical batches, processed in the sequential order from **Batch-1** → **Batch-15 **.  Specifically, the cohort consists of **1004** actual biological samples and **162** pooled QC samples.

**⚠️Tips: We excluded the sample replicates from the dataset to align with the standard injection protocols recommended by the mQACC, including single sample replicates (Replicate), short replicates (SR) and batch replicates (BR).**

| Batch ID | Total |  QC  | Sample | Inject Order |
| :------: | :---: | :--: | :----: | :----------: |
| Batch-01 |  83   |  10  |   73   |    1 ~ 89    |
| Batch-02 |  77   |  11  |   66   |   90 ~ 180   |
| Batch-03 |  73   |  11  |   62   |  181 ~ 267   |
| Batch-04 |  81   |  11  |   70   |  268 ~ 362   |
| Batch-05 |  76   |  10  |   66   |  363 ~ 452   |
| Batch-06 |  78   |  11  |   67   |  453 ~ 542   |
| Batch-07 |  77   |  11  |   66   |  543 ~ 632   |
| Batch-08 |  76   |  10  |   66   |  633 ~ 721   |
| Batch-09 |  77   |  11  |   66   |  722 ~ 812   |
| Batch-10 |  77   |  11  |   66   |  813 ~ 903   |
| Batch-11 |  78   |  11  |   67   |  904 ~ 994   |
| Batch-12 |  77   |  11  |   66   |  995 ~ 1085  |
| Batch-13 |  77   |  11  |   66   | 1086 ~ 1176  |
| Batch-14 |  77   |  11  |   66   | 1177 ~ 1267  |
| Batch-15 |  82   |  11  |   71   | 1268 ~ 1361  |
|   All    | 1166  | 162  |  1004  |      /       |
