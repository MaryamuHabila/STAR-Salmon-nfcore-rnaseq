# STAR-Salmon-nfcore-rnaseq
Transcript abundance based RNA-seq pipeline
Below is a **comprehensive README** suitable for a repository, project directory, or supplementary methods. It explains the pipeline, files, inputs, execution, and outputs clearly.

---

# README

## HAoSMC RNA-seq Processing Pipeline using nf-core/rnaseq (Nextflow)

This directory contains scripts and configuration files used to run the **nf-core/rnaseq pipeline (v3.22.2)** for RNA-seq processing of **Human Aortic Smooth Muscle Cell (HAoSMC)** samples comparing **Control vs Knockdown (KD)** conditions.

The pipeline was executed on a Linux HPC server using **Nextflow** and **Singularity containers**, and the workflow was run inside a **tmux session** to allow the job to continue running in the background.

---

# Overview of the Pipeline

The **nf-core/rnaseq** pipeline performs standard RNA-seq preprocessing and analysis steps, including:

1. **Quality control**

   * FastQC
   * MultiQC summary reports

2. **Adapter trimming**

   * Trim Galore / Cutadapt

3. **Read alignment**

   * STAR aligner

4. **Transcript quantification**

   * Salmon

5. **Gene-level count generation**

6. **Comprehensive QC reporting**

The pipeline produces both **alignment-based outputs (STAR)** and **transcript quantification outputs (Salmon)**.

---

# Directory Contents

The following files were used to run the workflow.

```
Scripts/
│
├── nextflow.sh
├── nfcore_params.yml
├── Samplesheet_HAoSMCs.csv
```

Each file is described below.

---

# 1. nextflow.sh

This script launches the **nf-core RNA-seq pipeline** using Nextflow.

### Script contents

```bash
NXF_OPTS='-Xms20g -Xmx40g'

nextflow run nf-core/rnaseq \
  --input Samplesheet_HAoSMCs.csv \
  -params-file nfcore_params.yml \
  -r 3.22.2 \
  -profile singularity \
  --igenomes_base /tmp \
  -with-dag \
  -with-timeline \
  -with-trace \
  -with-report \
  --outdir results \
  -resume
```

### Explanation of parameters

| Parameter                         | Description                                   |
| --------------------------------- | --------------------------------------------- |
| `NXF_OPTS`                        | Allocates Java memory for Nextflow (20–40 GB) |
| `nextflow run nf-core/rnaseq`     | Runs the nf-core RNA-seq pipeline             |
| `--input Samplesheet_HAoSMCs.csv` | Sample metadata and FASTQ file locations      |
| `-params-file nfcore_params.yml`  | Pipeline parameter configuration file         |
| `-r 3.22.2`                       | Specific nf-core/rnaseq pipeline version      |
| `-profile singularity`            | Use Singularity containers                    |
| `--igenomes_base /tmp`            | Location for reference genome resources       |
| `-with-dag`                       | Generate pipeline DAG (workflow diagram)      |
| `-with-timeline`                  | Execution timeline                            |
| `-with-trace`                     | Resource usage trace                          |
| `-with-report`                    | Pipeline execution report                     |
| `--outdir results`                | Output directory                              |
| `-resume`                         | Resume from previous run if interrupted       |

---

# 2. nfcore_params.yml

This file defines key pipeline parameters.

```
fasta: "/home/s2451842/GTF/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
gtf: "/home/s2451842/GTF/Homo_sapiens.GRCh38.112.gtf"
aligner: "star_salmon"
skip_biotype_qc: true
```

### Parameter explanations

| Parameter         | Description                                           |
| ----------------- | ----------------------------------------------------- |
| `fasta`           | Reference genome FASTA file (GRCh38 primary assembly) |
| `gtf`             | Gene annotation file (Ensembl v112)                   |
| `aligner`         | Alignment and quantification method                   |
| `skip_biotype_qc` | Skips gene biotype QC step                            |

### Alignment strategy

The pipeline uses:

**STAR + Salmon**

This means:

1. STAR performs **genome alignment**
2. Salmon performs **transcript quantification**

This combination provides both:

* accurate genome alignment
* efficient transcript-level quantification

---

# 3. Samplesheet_HAoSMCs.csv

This file lists all samples used in the RNA-seq analysis.

### Format

```
sample,fastq_1,fastq_2,strandedness
```

| Column       | Description               |
| ------------ | ------------------------- |
| sample       | Sample name               |
| fastq_1      | Path to read 1 FASTQ file |
| fastq_2      | Path to read 2 FASTQ file |
| strandedness | Library strandedness      |

All samples are **paired-end** and **reverse stranded**.

---

# Experimental Design

The dataset contains **Control and Knockdown samples** from multiple experiments.

### Control samples

Examples:

* CTR1_Z20_T
* CTR2_Z30_T
* Z350Ctr
* Z950Ctr


### Knockdown samples

Examples:

* KD1_Z20_T
* KD2_Z30_T
* Z650KD
* Z1250KD

These represent HAoSMC samples in which **LINC02398 knockdown** experiments were performed.

---

# Running the Pipeline

All scripts were placed in the same directory on the HPC server.

The workflow was executed using **tmux** to allow the job to run in the background.

### Starting the tmux session

```bash
tmux new -s HAoSMC_RNA-seq
```

### Running the pipeline

```bash
bash nextflow.sh
```

This allowed the pipeline to continue running even if the SSH session disconnected.

### Reconnecting to the session

```
tmux attach -t HAoSMC_RNA-seq
```

---

# Output Directory

The pipeline writes results to:

```
results/
```

Key outputs include:

### Quality Control

```
results/multiqc/
```

Contains:

* MultiQC summary report
* aggregated FastQC results

### Alignment results

```
results/star/
```

Includes:

* sorted BAM files
* alignment statistics

### Transcript quantification

```
results/salmon/
```

Includes:

* transcript abundance estimates
* TPM values
* counts

### Gene counts

```
results/featureCounts/
```

Gene-level read counts used for downstream analysis.

---

# Pipeline Reports

Because the pipeline was run with additional reporting options, the following files were generated:

| File          | Description                |
| ------------- | -------------------------- |
| timeline.html | Execution timeline         |
| report.html   | Pipeline execution summary |
| trace.txt     | Resource usage             |
| dag.svg       | Workflow DAG diagram       |

These files help document pipeline execution and resource use.

---

# Reference Data

The pipeline used the following genome resources:

| Resource        | Source                  |
| --------------- | ----------------------- |
| Genome FASTA    | GRCh38 primary assembly |
| Gene annotation | Ensembl release 112     |

Paths used:

```
/home/s2451842/GTF/Homo_sapiens.GRCh38.dna.primary_assembly.fa
/home/s2451842/GTF/Homo_sapiens.GRCh38.112.gtf
```

---

# Reproducibility

Key aspects ensuring reproducibility:

* **nf-core pipeline version:** 3.22.2
* **Containerization:** Singularity
* **Explicit reference genome and annotation**
* **Pipeline execution reports**

The `-resume` flag allows interrupted runs to continue from the last completed step.

---

# Summary

This pipeline processes HAoSMC RNA-seq datasets using the **nf-core/rnaseq Nextflow workflow**. It performs quality control, trimming, alignment with STAR, transcript quantification with Salmon, and produces gene-level counts for downstream analysis.

The workflow was executed on an HPC server using **Singularity containers** and managed within a **tmux session** to ensure reliable long-running execution.

The outputs generated by this pipeline were subsequently used for **downstream analyses such as differential gene expression and exon usage analysis (DEXSeq)**.

