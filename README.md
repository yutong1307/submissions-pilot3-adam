<!-- badges: start -->

[![R-CMD-check](https://github.com/RConsortium/submissions-pilot1/workflows/R-CMD-check/badge.svg)](https://rconsortium.github.io/submissions-pilot1/)
<!-- badges: end -->

## Overview

The objective of the R Consortium R submission Pilot 1 Project is to 
test the concept that a R-language based submission package can meet 
the needs and the expectations of the FDA reviewers, 
including assessing code review and analyses reproducibility. 
All submission materials and communications from this pilot are publicly available, 
with the aim of providing a working example for future R language based FDA submissions.
This is a FDA-industry collaboration through the non-profit organization R consortium.

The [working group website](https://rconsortium.github.io/submissions-wg/).

The [RConsortium/submissions-pilot1](https://github.com/RConsortium/submissions-pilot1) repo demonstrates an approach to organize internal developed R function and 
table, listing, figure generation program using an R package. 

The [RConsortium/submissions-pilot1-to-fda](https://github.com/RConsortium/submissions-pilot1-to-fda)
repo demonstrates the eCTD submission package based on the [RConsortium/submissions-pilot1](https://github.com/RConsortium/submissions-pilot1) repo.  

## FDA Response 

- Response to initial submission
  + response letter <
## Running Environment 

The project is developed and tested in the environment below:

- OS: Ubuntu 20.04
- R version: R4.1.2
- Snapshot date: 2021-08-31
- Snapshot repository: https://mran.microsoft.com/snapshot/2021-08-31

## Folder Structure 

The work in this repo is organized as an R package following the concepts discussed in:

- [Marwick, B., Boettiger, C., & Mullen, L. (2018). Packaging data analytical work reproducibly using R (and friends). The American Statistician, 72(1), 80-88.](https://peerj.com/preprints/3192/)
- [Wu, P., Palukuru, U. P., Luo, Y., Nepal, S., & Zhang, Y. (2021) Analysis and reporting in regulated clinical trial environment using R. PharmaSUG 2021](https://www.pharmasug.org/proceedings/2021/AD/PharmaSUG-2021-AD-079.pdf)

### R function and Analysis Scripts 

In short, the project is organized as an R package. 

- `pilot1wrappers.Rproj`: RStudio project file used to open RStudio project.
- `DESCRIPTION`: Metadata for a package including authors, license, dependency etc.
- `vignettes/`: Analysis scripts using Rmarkdown.
- `R/`: Project specific R functions.
- `man/`: Manual of project specific R functions. 

### Datasets

The source dataset is in `adam\` folder. The original data is from [the PHUSE Github Repository](https://github.com/phuse-org/phuse-scripts/blob/master/data/adam/TDF_ADaM_v1.0.zip)

### Startup file 
- `.Rprofile`: Project startup file to setup running environment including R version, repository, folder path etc. 
  - We further use `inst/startup.R` and `R/zzz.R` to allow the startup file is executed while running. `devtools::load_all()` and RStudio build panel. 
  
### Results 

- `output\`: TLFs output generated by Rmarkdown files in `vignettes\` folder. 

### Reproducibility

The original code is prepared and executed on Ubuntu 20.04.3 LTS.
We use `renv` to ensure reproducibility for R version and R package version. 

- `renv.lock` and `renv\` folder: R package management using `renv` package. ([Introduction](https://rstudio.github.io/renv/articles/renv.html))

### Utilities

- `_pkgdown.yml`: [pkgdown](https://pkgdown.r-lib.org/articles/pkgdown.html) configuration file.

