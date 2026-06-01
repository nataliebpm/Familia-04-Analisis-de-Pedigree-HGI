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

- Peippo, M., & Ignatius, J. (2011). Pitt-Hopkins syndrome. Molecular Syndromology, 2(3–5), 171–180. https://pmc-ncbi-nlm-nih-gov.translate.goog/articles/PMC3366706/?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc

- Online Mendelian Inheritance in Man (OMIM). (s. f.). Pitt-Hopkins syndrome; PTHS (Entry No. 610954). Johns Hopkins University. Recuperado el 1 de junio de 2026, de https://www.omim.org/entry/610954?search=TCF4

- Dong, C., Wei, P., Jian, X., Gibbs, R., Boerwinkle, E., Wang, K., & Liu, X. (2014). Comparison and integration of deleteriousness prediction methods for nonsynonymous SNVs in whole exome sequencing studies. https://pmc.ncbi.nlm.nih.gov/articles/PMC4375422/

- Ioannidis, N. M., Rothstein, J. H., Pejaver, V., Middha, S., McDonnell, S. K., Baheti, S., Musolf, A., Li, Q., Holzinger, E., Karyadi, D., Cannon-Albright, L. A., Teerlink, C. C., Stanford, J. L., Isaacs, W. B., Xu, J., Cooney, K. A., Lange, E. M., Schleutker, J., Carpten, J. D., ... Sieh, W. (2016). REVEL: An ensemble method for predicting the pathogenicity of rare missense variants. https://pmc.ncbi.nlm.nih.gov/articles/PMC5065685/

- Sweatt, J. D. (2013). Pitt–Hopkins syndrome: Intellectual disability due to loss of TCF4-regulated gene transcription. Experimental & Molecular Medicine, 45(5), e21. https://www-nature-com.translate.goog/articles/emm201332?error=cookies_not_supported&code=c200c891-0b50-4abe-8cdf-f428264847dc&_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc

- National Organization for Rare Disorders (NORD). (s. f.). Pitt-Hopkins syndrome. Recuperado el 1 de junio de 2026, de https://rarediseases.org/es/rare-diseases/pitt-hopkins-syndrome/

- NCBI MedGen. (s. f.). Pitt-Hopkins syndrome (Concept ID: C1970431). National Center for Biotechnology Information, U.S. National Library of Medicine. Recuperado el 1 de junio de 2026, de https://www.ncbi.nlm.nih.gov/medgen/C1970431

- Online Mendelian Inheritance in Man (OMIM). (s. f.). Transcription factor 4; TCF4 (Entry No. 602272). Johns Hopkins University. Recuperado el 1 de junio de 2026, de https://omim.org/entry/602272

- National Center for Biotechnology Information (NCBI). (s. f.). VCV000381549.12: NM_001083962.2(TCF4):c.1727G>A (p.Arg576Gln). ClinVar. Recuperado el 1 de junio de 2026, de https://www.ncbi.nlm.nih.gov/clinvar/variation/381549/
