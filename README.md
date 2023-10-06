# BE1
Supporting code for the analysis of a single cell RNAseq (10XGenomics platform) benchmark dataset, named BE1, providing a 
controlled heterogeneity environment using lung cancer cell lines characterised by expressing seven different driver genes 
(EGFR, ALK, MET, ERBB2, KRAS, BRAF, ROS1). BE1 is part of the WP3 of [Elixir Single Cell Omics](https://www.singlecellomics.org/pages/tools/index#be1) 
implementation study. 
BE1 fastq data have been loaded on GEO: GSE243665 (access under embargo till Sept 1st 2024). 10XGenomics count matrices and annotated derivatives are available at  [*10.6084/m9.figshare.23939481*](https://figshare.com/ndownloader/files/42312711).
Further supporting information on genomics and transcriptomis data (CCLE) and on the drive genes targets (see below BE1 structure) are available at [*10.6084/m9.figshare.23284748*](https://doi.org/10.6084/m9.figshare.23284748.v1).
BE1 includes scRNAseq for the following lung cancer cell lines:
-  PC9, 4492 sequenced cells (EGFR Del19, activating mutation, PMID: [*Simonetti et al. (2010)*](https://pubmed.ncbi.nlm.nih.gov/21167064/) 
-  A549, 6898 sequenced cells (KRAS p.G12S, growth and proliferation,  PMID: [*Yoon et al. (2010)*](https://pubmed.ncbi.nlm.nih.gov/20358631/) 
-  NCI-H596 (HTB178), 2965 sequenced cells (MET Del14 , enhanced protection from apoptosis and cellular migration PMID: [*Cerqua et al. (2022)*](https://pubmed.ncbi.nlm.nih.gov/35636967/) 
-  NCI-H1395 (CRL5868), 2673 sequenced cells (BRAF p.G469A, gain of function, resistant to all tested MEK +/− BRAF inhibitors, PMID: [*Negrao et al. (2020)*](https://pubmed.ncbi.nlm.nih.gov/32540409/)) 
-  DV90, 2998 sequenced cells (ERBB2 p.V842I, increases kinase activity, PMID: [*Boese et al. (2013)*](https://pubmed.ncbi.nlm.nih.gov/23220880/) 
-  HCC78, 2748 sequenced cells (SLC34A2-ROS1 Fusion, ROS1 inhibitors have antiproliferative effect PMID: [*Davies et al. (2012)*](https://pubmed.ncbi.nlm.nih.gov/22919003/) 
-  CCL.185.IG, 6354 sequenced cells [*EML4-ALK Fusion-A549 Isogenic Cell*](https://www.atcc.org/products/ccl-185ig) 

## Package installation

```
install.packages("devtools")
devtools::install_git("https://github.com/kendomaniac/BE1")
```

