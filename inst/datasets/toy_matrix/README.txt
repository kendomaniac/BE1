The toy_matrix was generated from the BE1 experiment (https://figshare.com/ndownloader/files/42312711) using the folllwing code from BE1 package:
#devtools::install_git("https://github.com/kendomaniac/BE1")
library(BE1)
makeDataset(input.folder="/Users/raffaelecalogero/Desktop/BE1run12", 
            output.folder="/Users/raffaelecalogero/Desktop/BE1run12/tmp", 
            cell.lines = c("A549", "CCL-185-IG", "CRL5868", "DV90", "HCC78", "HTB178", "PC9", "PBMCs"), 
            n.cells=c(200,200,200,200,200,200,200,50))

