## 🧬 Análisis de Pedigree de la Familia 04

---

### 👥 Autor

| Nombre | Usuario GitHub |
|--------|:---------------:|
| Pineda Morán Natalie Berenice | [@npineda](https://github.com/nataliebpm) |

---

### 📋 Información del Curso

| Datos | Información |
|-------|:---------:|
| 📅 **Fecha** | 29 Mayo 2026 |
| 📚 **Materia** | Genética y Genómica I |
| 🎓 **Semestre** | 4° Semestre |
| 🏫 **Institución** | *ENESJ Lic. Ciencias Genómicas* |

---


## Introducción

Este proyecto presenta un análisis del pedigree de la familia. 

***Enlace al reporte renderizado***: https://nataliebpm.github.io/Analisis-de-RNA-seq-BEII/

---

## Pipeline

1. Script:`download_RNAdata.sh`

	- a) Descargar datos de NCBI en SRA, b) Descargar metadatos
	
	- Se descargaron los archivos de secuencia cruda FASTQ de las 8 muestras en el cluster utilizando la página de SRA del BioProject donde se almacenan los datos del artículo, se descargaron un total de 16 archivos de SRA ya que eran PE-reads. 

2. Script: `quality1.sh`

	- a) Análisis de control de calidad de datos crudos utilizando FASTQC

3. Script: `quality2.sh`

	- a) Análisis de control de calidad de datos crudos utilizando MultiQC
	
4. Script: `trimm_adapters.sh`

	- a) Eliminar adaptadores y realizar filtrado de los archivos crudos de SRA utilizando Trimmomatic (trimmomatic/0.33)
	
	- Durante este análisis se generaron 32 archivos FASTQ de las secuencias procesadas, ya que Trimmomatic genera 2 archivos procesados `(*_trimmed.fq.gz, *_unpaired.fq.gz)` por cada archivo FASTQ de secuencias crudas

5. Script: `qc2_trimmed.sh`

	- a) Análisis de control de calidad de secuencias filtradas utilizando FASTQC, b) Análisis de control de calidad utilizando MultiQC

6. Script: `reference.sh`

	- a) Descargar transcriptoma de referencia de *Mus musculus* (cdna, ncrna) de NCBI

7. Script: `genome_index.sh`

	- a) Indexar genoma de *Mus musculus* utilizando Kallisto (kallisto/0.45.0)

8. Script: `pseudoalineamiento.sh`

	- a) Realizar alineamiento de las secuencias utilizando Kallisto (kallisto/0.45.0)

9. Script: `RNA_seq_analisis.Rmd`

	- a) Carga de datos (tximport + anotación GTF), b) Normalización (rlog, z-score), c) Visualización exploratoria (PCA), d) Evaluación de batch effect, e) Expresión diferencial (DESeq2 + apeglm), f) Volcano Plot, g) Análisis funcional (gPRofiler)

### 📁 Estructura del Repositorio en GitHub

- `out_logs`: reportes de todos los out logs de los jobs de slurm utilizados para el análisis 

- `scripts`: archivos de R para análisis de variantes raras. 

- `results`: contiene las matrices de conteos y los archivos de formato necesarios para el análisis de expresión diferencial de genes, así como los gráficos generados a partir de dicho análisis.

- `README.md` 

- `Final_Bioproject_Report`: reporte final en formato Rmd

- `index.html`: reporte renderizado en formato html

## 📦 Requisitos y Dependencias

### Software

| Herramienta | Versión | Uso |
|-------------|---------|-----|
| R | - | Análisis estadístico |

## 📚 Referencias

- Lafront, C., Germain, L., & Audet-Walsh, É. (2024). Bulk mRNA-seq data from wild-type and prostate cancer-developing mice reveal a reprogramming of the estrogen and androgen responses after carcinogenesis. *Data in Brief*, *57*, 110870. https://doi.org/10.1016/j.dib.2024.110870

- Ramírez-de-Arellano, A., Pereira-Suárez, A. L., Rico-Fuentes, C., López-Pulido, E. I., Villegas-Pineda, J. C., & Sierra-Diaz, E. (2022). Distribution and effects of estrogen receptors in prostate cancer: Associated molecular mechanisms. Frontiers in Endocrinology, 12, 811578. https://doi.org/10.3389/fendo.2021.811578

- Belluti, S., Imbriano, C., & Casarini, L. (2023). Nuclear estrogen receptors in prostate cancer: From genes to function. Cancers, 15(18), 4653. https://doi.org/10.3390/cancers15184653

- Richter, C. A., Taylor, J. A., Ruhlen, R. L., Welshons, W. V., & Vom Saal, F. S. (2007). Estradiol and bisphenol A stimulate androgen receptor and estrogen receptor gene expression in fetal mouse prostate mesenchyme cells. Environmental Health Perspectives, 115(6), 902–908. https://pmc.ncbi.nlm.nih.gov/articles/PMC1892114/

- Dobbs, R.W., Malhotra, N.R., Greenwald, D.T. et al. Estrogens and prostate cancer. Prostate Cancer Prostatic Dis 22, 185–194 (2019). https://doi.org/10.1038/s41391-018-0081-6
