## ---- message = FALSE----------------------------------------------------------------------
# Initiate start-up file
source(file.path(rprojroot::find_root("DESCRIPTION"), "inst/startup.R"))


## ------------------------------------------------------------------------------------------
# Working directory requires write permission
if(file.access(".", 2) != 0){
  warning(
    "The working directory '", normalizePath("."), "' is not writable.\n",
    "Please change it to a location with write permission."
  )
}


## ----setup, message=FALSE------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

# CRAN package, please using install.packages() to install
library(dplyr)
library(haven)
library(r2rtf)
library(emmeans)

# Propitiatory Package, please refer appendix of ADRG to install 
library(pilot1wrappers)


## ------------------------------------------------------------------------------------------
adlb <- read_xpt(file.path(path$adam, "adlbc.xpt"))


## ------------------------------------------------------------------------------------------
adlb1 <- subset(adlb, TRTPN %in% c(0, 81) & PARAMCD == "GLUC" & !is.na(AVISITN)) %>%
  mutate(TRTPN = ifelse(TRTPN == 0, 99, TRTPN)) # change treatment order for pairwise comparison

## Fit data for linear model
gluc_lmfit <- adlb1 %>%
  filter(AVISITN == 20) %>%
  lm(CHG ~ BASE + TRTPN, data = .)

## Raw summary statistics
t10 <- adlb1 %>% 
  filter(AVISITN == 0) %>% 
  group_by(TRTPN,TRTP) %>% 
  summarise(
    N = n(),
    mean_bl = mean(BASE),
    sd_bl = sd(BASE)
  )

t11 <- adlb1 %>%
  filter(AVISITN == 20) %>%
  group_by(TRTPN, TRTP) %>%
  summarise(
    N_20 = n(),
    mean_chg = mean(CHG),
    sd_chg = sd(CHG),
    mean = mean(AVAL),
    sd = sd(AVAL)
  )

## Calculate LS mean
t12 <- emmeans(gluc_lmfit, "TRTPN")

## Merge and format data for reporting
apr0ancova1 <- merge(t10, t11)  %>% 
  merge(t12) %>% 
  mutate(emmean_sd = SE * sqrt(df)) %>%
  mutate(
    Trt = c("Study Drug", "Placebo"),
    N1 = N,
    Mean1 = pilot1wrappers::fmt_est(mean_bl, sd_bl),
    N2 = N_20,
    Mean2 = pilot1wrappers::fmt_est(mean, sd),
    N3 = N_20,
    Mean3 = pilot1wrappers::fmt_est(mean_chg, sd_chg),
    CI = pilot1wrappers::fmt_ci(emmean, lower.CL, upper.CL)
  ) %>%
  select(Trt:CI)

apr0ancova1


## ------------------------------------------------------------------------------------------
t2 <- data.frame(pairs(t12))

## Treatment Comparison
apr0ancova2 <- t2 %>%
  mutate(
    lower = estimate - 1.96 * SE,
    upper = estimate + 1.96 * SE
  ) %>%
  mutate(
    comp = "Study Drug vs. Placebo",
    mean = pilot1wrappers::fmt_ci(estimate, lower, upper),
    p = pilot1wrappers::fmt_pval(p.value)
  ) %>%
  select(comp:p)

apr0ancova2


## ------------------------------------------------------------------------------------------
### Calculate root mean square and save data in output folder
apr0ancova3 <- data.frame(rmse = paste0(
  "Root Mean Squared Error of Change = ",
  formatC(sd(gluc_lmfit$residuals), digits = 2, format = "f", flag = "0")
))

apr0ancova3


## ------------------------------------------------------------------------------------------
tbl_1 <- apr0ancova1 %>%
  rtf_title(
    title = "ANCOVA of Change from Baseline at Week 20"
  ) %>%
  rtf_colheader(
    colheader = " | Baseline{^a} | Week 20 | Change from Baseline",
    col_rel_width = c(3, 4, 4, 9)
  ) %>%
  rtf_colheader(
    colheader = "Treatment | N | Mean (SD) | N | Mean (SD) | N | Mean (SD) | LS Mean (95% CI){^b}",
    col_rel_width = c(3, 1, 3, 1, 3, 1, 3, 5)
  ) %>%
  rtf_body(
    col_rel_width = c(3, 1, 3, 1, 3, 1, 3, 5),
    text_justification = c("l", rep("c", 7)),
    last_row = FALSE
  ) %>%
  rtf_footnote(
    footnote = c(
      "{^a} Table is based on participants who have observable data at Baseline and Week 20.",
      "{^b} Based on an Analysis of covariance (ANCOVA) model with treatment and baseline value as covariates",
      "CI = Confidence Interval, LS = Least Squares, SD = Standard Deviation"
    )
  ) %>%
  rtf_source(
    source = "Source: [pilot1wrappers: adam-adlbc]",
    text_justification = "c"
  )


## ------------------------------------------------------------------------------------------
tbl_2 <- apr0ancova2 %>%
  rtf_colheader(
    colheader = "Pairwise Comparison | Difference in LS Mean (95% CI){^b} | p-Value",
    text_justification = c("l", "c", "c"),
    col_rel_width = c(8, 7, 5)
  ) %>%
  rtf_body(
    col_rel_width = c(8, 7, 5),
    text_justification = c("l", "c", "c"),
    last_row = FALSE
  )


## ------------------------------------------------------------------------------------------
tbl_3 <- apr0ancova3 %>%
  rtf_body(
    as_colheader = FALSE,
    text_justification = "l"
  )


## ------------------------------------------------------------------------------------------
tbl <- list(tbl_1, tbl_2, tbl_3)
tbl %>%
  rtf_encode() %>%
  write_rtf(file.path(path$output, "tlf-efficacy.rtf"))


## ---- out.width = "100%", out.height = "400px", echo = FALSE, fig.align = "center"---------
knitr::include_graphics("pdf/tlf-efficacy.pdf")

