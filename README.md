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
| 📅 **Fecha** | 01 Junio 2026 |
| 📚 **Materia** | Genética y Genómica I |
| 🎓 **Semestre** | 4° Semestre |
| 🏫 **Institución** | *ENESJ Lic. Ciencias Genómicas* |

---


## Introducción

Este proyecto presenta un análisis del pedigree de la Familia 04. 

***Enlace al reporte en Google Drive***:  [GHI_Proyecto_Final](https://docs.google.com/document/d/1r7sVipL6qnkB8JmlQ0gQZ5pwVh-4o9OFOSSj556zUU0/edit?usp=sharing)

***El archivo en formato PDF se encuentra al inicio de este repositorio con el nombre "Proyecto_Final_GHI.pdf"***

---

## Pipeline

1. Script:`code_variant_identifier.R`

	- Cargar librerías
	
	- Ver tipo de herencia: De novo, autosómica recesiva (AR), AR compuesta, autosómica dominante (AD) o ligada al cromosoma X, y "otro"
	
	- Realizar filtrado de variantes: Cobertura mínima de 10×, al menos 3 lecturas soportando la variante, GQ ≥ 30 y QUAL (Phred) ≥ 30. Adicionalmente, se evaluó el balance alélico, esperando una proporción entre 0.20 y 0.80 para variantes heterocigotas y >0.80 para homocigotas
	
	- Guardar las variantes candidatas en otro vector: `candidatas`
	
	- Asociar variantes a genes y realizar filtrado poblacional: UtilizandoThe 1K Genomes Project (TGP) y Exome Sequencing Project (ESP)
	
	- Estimar su score patogenicidad utilizando diferentes algoritmos: SIFT, MIT, LTR, PPH2
	
	- Guardar aquellas con un mayor score: `top_candidatas`
	
	- Identitifcar variantes no compartidas entre los parientes y el probando: `candidatas_exclusivas`
	
	- Contrastar la información de las variantes filtradas con bases de datos públicas (OMIM y ClinVar)
	
### 📁 Estructura del Repositorio en GitHub

- `data`: pedigrí de las diferentes familias, además de los datos en formato `*.xlsx` de la familia 04 para realizar el análisis. 

- `scripts`: archivos de R para análisis de variantes raras. 

- `results`: contiene las tablas generadas con R y la infografía sobre la metodología

- `README.md` 

- `Proyecto_Final_GHI.pdf`: reporte final en formato pdf

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
