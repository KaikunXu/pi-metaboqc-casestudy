## 📦 Datasets Overview

To comprehensively evaluate the robustness, reproducibility, and correction efficacy of the `pi-metaboqc` pipeline, this case study utilizes multiple independent, previously published benchmark metabolomics datasets. These datasets were specifically selected for their complex analytical variations, including severe intra-batch signal drift and distinct inter-batch effects.

---

### pi-metaboqc Dataset

**Link:**

+ [pi-metaboqc GitHub Repository](https://github.com/KaikunXu/pi-metaboqc)
+ [pi-metaboqc Demo Data GitHub Repository](https://github.com/KaikunXu/pi-metaboqc-casestudy)

**Data Characteristics:** This dataset is the demo data of the `pi-metaboqc` module, acquired in **positive** ionization mode, comprising a total of **376** detected mass spectral features across **466** injections. To ensure quantification fidelity and monitor system stability, a suite of **5** internal standards (including CA-d4, CDCA-d4, Choline-d4, Phenylalanine-d5, Carnitine C10:0-d3) was systematically incorporated into the experimental design. The sample cohort is strategically distributed across **3** analytical batches, processed in the sequential order of **B1 → B2 → B3**. Specifically, the cohort consists of **398** actual biological samples, **44** pooled Quality Control (QC) samples, and **24** blank samples, establishing a robust foundation for downstream noise removal.

| Batch | Total |  QC  | Blank | Sample | Inject Order |
| :---: | :---: | :--: | :---: | :----: | :----------: |
|  B1   |  154  |  14  |   8   |  132   |   1 ~ 169    |
|  B2   |  155  |  14  |   8   |  133   |  170 ~ 338   |
|  B3   |  157  |  16  |   8   |  133   |  339 ~ 541   |

---

### MetNormalizer Dataset

**Source:** Normalization and integration of large-scale metabolomics data using support vector regression (***Metabolomics***, 2016)

**Link:**

+ [MetNormalizer GitHub Repository](https://github.com/jaspershen/MetNormalizer)
+ [demoData GitHub Repository](https://github.com/jaspershen/demoData/tree/master/inst/MetNormalizer)

**Data Characteristics:** This dataset originates from the study developing MetNormalizer, an R package utilizing Support Vector Regression (SVR) for large-scale metabolomics data normalization. The dataset comprises a total of **1351** detected mass spectral features across **177** injections. The sample cohort is distributed within **1** analytical batch. Specifically, the cohort consists of **154** actual biological samples and **23** pooled QC samples.

|  Batch  | Total |  QC  | Sample | Inject Order |
| :-----: | :---: | :--: | :----: | :----------: |
| Batch-1 |  177  |  23  |  154   |   1 ~ 177    |

---

### SERRF Dataset

**Source:** Systematic Error Removal Using Random Forest for Normalizing Large-Scale Untargeted Lipidomics Data (***Anal. Chem.***, 2019)

**Link:** [SERRF Online Tool & Data](https://slfan2013.github.io/SERRF-online/#)

**Data Characteristics:** This dataset is derived from a large-scale untargeted metabolomics study acquired in **negative ion mode**. The dataset comprises a total of **268** detected mass spectral features across **1299** injections. The sample cohort is strategically distributed across **4** analytical batches, processed in the sequential order of **Batch-A → Batch-B → Batch-C → Batch-D**.  Specifically, the cohort consists of **1174** actual biological samples and **125** pooled QC samples.

|  Batch  | Total |  QC  | Sample | Inject Order |
| :-----: | :---: | :--: | :----: | :----------: |
| Batch-A |  335  |  32  |  303   |   1 ~ 335    |
| Batch-B |  336  |  33  |  303   |  336 ~ 671   |
| Batch-C |  335  |  32  |  303   |  672 ~ 1006  |
| Batch-D |  293  |  28  |  265   | 1007 ~ 1299  |

---

### notame Dataset

**Source:** "Notame": Workflow for Non-Targeted LC–MS Metabolic Profiling (***Metabolites***, 2020)

**Link:** [notame GitHub Repository](https://github.com/hanhineva-lab/notame)

**Data Characteristics:** The `toy_notame_set` is a representative dataset provided within the `notame` R/Bioconductor package ecosystem. It comprises a total of **80** detected mass spectral features across **50** injections. The sample cohort is strategically distributed across **2** analytical batches, processed in the sequential order of **Batch-1 → Batch-2**.  Specifically, the cohort consists of **40** actual biological samples and **10** pooled QC samples.

|  Batch  | Total |  QC  | Sample | Inject Order |
| :-----: | :---: | :--: | :----: | :----------: |
| Batch-1 |  25   |  5   |   20   |    1 ~ 25    |
| Batch-2 |  26   |  5   |   20   |   26 ~ 50    |

---

### WaveICA 2.0 Dataset

**Source:** WaveICA 2.0: a novel batch effect removal method for untargeted metabolomics data without using batch information (***Metabolomics***, 2021)

**Link:** [WaveICA 2.0 GitHub Repository](https://github.com/dengkuistat/WaveICA_2.0)

**Data Characteristics:** This dataset features complex, non-linear instrumental signal drift. The original WaveICA 2.0 algorithm was designed to extract and remove these complex technical variations using wavelet analysis without explicitly relying on batch labels. The dataset comprises a total of **6402** detected mass spectral features across **729** injections. The sample cohort is strategically distributed across **4** analytical batches, processed in the sequential order of **Batch-1 → Batch-2 → Batch-3 → Batch-4**.  Specifically, the cohort consists of **644** actual biological samples and **85** pooled QC samples.

|  Batch  | Total |  QC  | Sample | Inject Order |
| :-----: | :---: | :--: | :----: | :----------: |
| Batch-1 |  217  |  25  |  192   |   1 ~ 217    |
| Batch-2 |  217  |  25  |  192   |  218 ~ 434   |
| Batch-3 |  208  |  24  |  184   |  435 ~ 642   |
| Batch-4 |  87   |  11  |   76   |  643 ~ 733   |

---

### 📂 Data Organization Notes

Following data science best practices for reproducibility (Data Immutability), the datasets in this repository are strictly separated:

+ `data/raw/`: Contains the original files exactly as downloaded from the sources above. **These files are absolutely immutable and should never be modified manually.**
+ `data/processed/`: Contains the formatted `project_meta.csv`, `project_intensity.csv` and `pipeline_parameters.toml` of each dataset, which are ready for `pi-metaboqc` ingestion. 
+ `scripts/`
	+ `data_preparation/`: Contains the reproducible Python scripts used to map and standardize the original data formats into the required `pi-metaboqc` schema.