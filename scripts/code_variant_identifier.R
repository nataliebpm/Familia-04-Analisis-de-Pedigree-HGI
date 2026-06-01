###########################################################################################################################################
# Pineda Morán Natalie Berenice
# 24 mayo 2026
# Genómica Humana 1

rm(list = ls())
# ------------------------1. Librerías--------------------------------------------------
library(readxl)
library(dplyr)
library(ggplot2)

D <- read_excel("/home/user/Ciencias_Genómicas_LCGEJ/Genomica_Humana_I/Proyecto_Pedigree/data/FAM4.xlsx")

# -----------------------2. Ver tipo de herencia---------------------------------------------------
D <- D %>%
  dplyr::mutate(inheritance = case_when(
    # De novo: probando tiene variante, padres sin dato
    `Proband:ZYG` %in% c("Proband:het","Proband:hom") &
      `Father:ZYG` == "Father:na" & `Mother:ZYG` == "Mother:na"     ~ "de_novo",
    # AR: probando HOM, padres HET
    `Proband:ZYG` == "Proband:hom" &
      `Father:ZYG` == "Father:het" & `Mother:ZYG` == "Mother:het"   ~ "AR",
    # AR compuesta: probando HET, cada padre aporta un alelo distinto
    `Proband:ZYG` == "Proband:het" &
      `Father:ZYG` == "Father:het" & `Mother:ZYG` == "Mother:na"    ~ "AR_compuesta",
    `Proband:ZYG` == "Proband:het" &
      `Father:ZYG` == "Father:na" & `Mother:ZYG` == "Mother:het"    ~ "AR_compuesta",
    # AD: probando HET, un padre HET
    `Proband:ZYG` == "Proband:het" &
      (`Father:ZYG` == "Father:het" | `Mother:ZYG` == "Mother:het") ~ "AD",
    # Ligada al X
    `#CHR` == "X" & `Proband:ZYG` %in% c("Proband:het","Proband:hom") &
      `Mother:ZYG` == "Mother:het" & `Father:ZYG` == "Father:na"    ~ "XL_recesiva",
    TRUE ~ "otro"
  ))

table(D$inheritance)

# -----------------------3. Pasar a valores numéricos---------------------------------------------------
D <- D %>%
  dplyr::mutate(
    TGP_FREQ_num = suppressWarnings(as.numeric(ifelse(TGP_FREQ == "na", NA, TGP_FREQ))),
    ESP_FREQ_num = suppressWarnings(as.numeric(ifelse(ESP_FREQ == "na", NA, ESP_FREQ)))
  )

# Verificar conversión
summary(D$TGP_FREQ_num)
summary(D$ESP_FREQ_num)

# -----------------------3b. Filtro de calidad--------------------------------------------------

# Primero convertir columnas a numérico (pueden venir como character)
D <- D %>%
  dplyr::mutate(
    TR_num   = suppressWarnings(as.numeric(TR)),
    VR_num   = suppressWarnings(as.numeric(VR)),
    RR_num   = suppressWarnings(as.numeric(RR)),
    RATIO_num = suppressWarnings(as.numeric(RATIO)),
    GQ_num   = suppressWarnings(as.numeric(GQ)),
    QUAL_num = suppressWarnings(as.numeric(QUAL))
  )

# Ver distribución de métricas de calidad
summary(D[, c("TR_num", "VR_num", "RATIO_num", "GQ_num", "QUAL_num")])

# Cuántas variantes pasan cada filtro individualmente
cat("Variantes totales:", nrow(D), "\n")
cat("TR >= 10:    ", sum(D$TR_num >= 10, na.rm = TRUE), "\n")
cat("VR >= 3:     ", sum(D$VR_num >= 3,  na.rm = TRUE), "\n")
cat("GQ >= 20:    ", sum(D$GQ_num >= 30, na.rm = TRUE), "\n")
cat("QUAL >= 30:  ", sum(D$QUAL_num >= 30, na.rm = TRUE), "\n")
cat("FILTER=PASS: ", sum(D$FILTER == "PASS", na.rm = TRUE), "\n")

# Aplicar filtro de calidad
D_filt <- D %>%
  dplyr::filter(
    FILTER == "PASS",          # pasó filtros del llamador
    TR_num  >= 10,             # cobertura mínima 10x
    VR_num  >=  3,             # al menos 3 lecturas soportan la variante
    GQ_num  >= 30,             # calidad de genotipo aceptable
    QUAL_num >= 30,            # calidad de la variante (Phred)
    # Balance alélico: het esperado ~0.2–0.8, hom > 0.8
    !(ZYG == "het" & (RATIO_num < 0.20 | RATIO_num > 0.80)),
    !(ZYG == "hom" &  RATIO_num < 0.80)
  )

cat("\nVariantes que pasan control de calidad:", nrow(D_filt), 
    "(de", nrow(D), "totales )\n")
# ----------------4. Ver variantes candidatas----------------------------------------------------------
candidatas <- D_filt %>%
  dplyr::filter(
    inheritance != "otro",
    (TGP_FREQ_num < 0.01 | is.na(TGP_FREQ_num)),
    (ESP_FREQ_num < 0.01 | is.na(ESP_FREQ_num)),
    ANNOTATION %in% c("nonsynonymous SNV", "stopgain SNV", "stoploss SNV",
                      "frameshift insertion", "frameshift deletion",
                      "nonframeshift insertion", "nonframeshift deletion",
                      "splicing", "exonic;splicing")
  ) %>%
  dplyr::select(`#CHR`, START, END, GENE, GENE_NAME, AA_CHANGE, NT_CHANGE,
                ANNOTATION, inheritance, TGP_FREQ, ESP_FREQ,
                SIFT_PRED, PPH2_PRED,
                `Proband:ZYG`, `Father:ZYG`, `Mother:ZYG`, contains("UASib"))

nrow(candidatas)

# ------------------------5. Ver genes candidatos--------------------------------------------------
# Ver genes candidatos
candidatas %>%
  dplyr::arrange(TGP_FREQ) %>%
  dplyr::select(GENE, GENE_NAME, AA_CHANGE, inheritance, TGP_FREQ) %>%
  print(n = 20)

# ---------------------6. Graficar las variantes por patrón de herencia----------------------------
# Gráfica
ggplot(D_filt, aes(x = inheritance, fill = SIFT_PRED)) +
  geom_bar() +
  theme_minimal() +
  labs(title = "Variantes por patrón de herencia",
       x = "Herencia", y = "N variantes")

# ----------------7. Score de patogenicidad----------------------------------------------------------
candidatas <- D_filt %>%
  dplyr::filter(
    inheritance != "otro",
    (TGP_FREQ_num < 0.01 | is.na(TGP_FREQ_num)),
    (ESP_FREQ_num < 0.01 | is.na(ESP_FREQ_num)),
    ANNOTATION %in% c("nonsynonymous SNV", "stopgain SNV", "stoploss SNV",
                      "frameshift insertion", "frameshift deletion",
                      "nonframeshift insertion", "nonframeshift deletion",
                      "splicing", "exonic;splicing")
  ) %>%
  dplyr::select(`#CHR`, START, END, GENE, GENE_NAME, AA_CHANGE, NT_CHANGE,
                ANNOTATION, inheritance, TGP_FREQ, TGP_FREQ_num, ESP_FREQ, ESP_FREQ_num,
                SIFT_PRED, PPH2_PRED, MTT_PRED, MTT_SCORE, LRT_PRED, LRT_SCORE,
                `Proband:ZYG`, `Father:ZYG`, `Mother:ZYG`, contains("UASib"))

top_candidatas <- candidatas %>%
  dplyr::mutate(
    score_patogenicidad =
      (SIFT_PRED == "damaging") +
      (PPH2_PRED %in% c("probably_damaging", "possibly_damaging")) +
      (MTT_PRED  %in% c("disease_causing", "A")) +
      (LRT_PRED  %in% c("D", "deleterious")) +
      (ANNOTATION %in% c("stopgain SNV", "frameshift insertion", "frameshift deletion"))
  ) %>%
  dplyr::arrange(desc(score_patogenicidad), TGP_FREQ_num)

# ----------------8. Ver top candidatas----------------------------------------------------------
top_candidatas %>%
  dplyr::filter(score_patogenicidad >= 3) %>%
  dplyr::select(`#CHR`, GENE, GENE_NAME, AA_CHANGE, ANNOTATION,
                inheritance, score_patogenicidad,
                SIFT_PRED, PPH2_PRED, MTT_PRED, LRT_PRED,
                TGP_FREQ, `Proband:ZYG`, `Father:ZYG`, `Mother:ZYG`) %>%
  print(n = 50)

# Resumen por gen
top_candidatas %>%
  dplyr::filter(score_patogenicidad >= 3) %>%
  dplyr::count(GENE, GENE_NAME, inheritance, score_patogenicidad) %>%
  dplyr::arrange(desc(score_patogenicidad))

# --------------------------------------------------------------------------
# Filtrar solo score 4 o 5 (los más fuertes)
top_candidatas %>%
  dplyr::filter(score_patogenicidad >= 4) %>%
  dplyr::select(`#CHR`, GENE, GENE_NAME, AA_CHANGE, ANNOTATION,
                inheritance, score_patogenicidad,
                SIFT_PRED, PPH2_PRED, MTT_PRED, LRT_PRED,
                TGP_FREQ, `Proband:ZYG`, `Father:ZYG`, `Mother:ZYG`) %>%
  print(n = 50)

# Ver cigosidad de los UASib en las top candidatas
top_candidatas %>%
  dplyr::filter(score_patogenicidad >= 3) %>%
  dplyr::select(GENE, inheritance, score_patogenicidad,
                `Proband:ZYG`, `Father:ZYG`, `Mother:ZYG`,
                `UASib:ZYG...51`, `UASib:ZYG...52`) %>%
  dplyr::arrange(desc(score_patogenicidad)) %>%
  print(n = 30)


# --------------------------------------------------------------------------
# Variantes candidatas donde los UASib NO tienen la variante (na en ambos)
candidatas_exclusivas <- top_candidatas %>%
  dplyr::filter(
    score_patogenicidad >= 3,
    `UASib:ZYG...51` == "UASib:na",
    `UASib:ZYG...52` == "UASib:na"
  ) %>%
  dplyr::select(GENE, GENE_NAME, AA_CHANGE, ANNOTATION,
                inheritance, score_patogenicidad,
                SIFT_PRED, PPH2_PRED, MTT_PRED, LRT_PRED,
                TGP_FREQ, `Proband:ZYG`, `Father:ZYG`, `Mother:ZYG`,
                `UASib:ZYG...51`, `UASib:ZYG...52`)

print(candidatas_exclusivas, n = 50)
cat("\nTotal genes exclusivos del probando:", nrow(candidatas_exclusivas), "\n")

# --------------------------------------------------------------------------
# Lista final para buscar en OMIM
candidatas_exclusivas %>%
  dplyr::select(GENE, AA_CHANGE, ANNOTATION, inheritance, TGP_FREQ) %>%
  dplyr::arrange(inheritance, GENE) %>%
  print(n = 17)

# --------------------------------------------------------------------------
