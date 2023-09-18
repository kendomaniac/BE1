#' @title A function to build cancer dataset using BE1 sparse matrices.
#' @description This function extract from BE1 experiment a set of cells on the basis of the user requirement
#' @param cell.lines, a vector indicating the cell lines to be included in the dataset. Seven options:
#' @param n.cells, a vector indicating the number of cell for each cell line. If the number of cell exceed the number of available cell in a data set the full dataset is used.
#' @param output.folder, a character string indicating the path where to save the data.
#' @param input.folder, a character string indicating the path where BE1run12.zip from figshare doi:10.6084/m9.figshare.23939481 has been downloaded.
#' @author Raffaele Calogero, raffaele.calogero [at] unito [dot] it, University of Torino, Italy
#' @return  A 10XGenomics sparse matrix
#'
#' @examples
#' \dontrun{
#'     #running deDetection
#' system("wget http://130.192.119.59/public/annotated_setPace_10000_noC5_clustering.output.txt")
#' system("wget http://130.192.119.59/public/annotated_setPace_10000_noC5.txt.zip")
#' unzip("annotated_setPace_10000_noC5.txt.zip")
#' anovaLike(group="docker", file=paste(getwd(),"annotated_setPace_10000_noC5.txt",sep="/"),
#'        sep="\t", cluster.file="annotated_setPace_10000_noC5_clustering.output.txt", ref.cluster=3,
#'        logFC.threshold=1, FDR.threshold=0.05, logCPM.threshold=4, plot=TRUE)
#'
#' }
#'
#' @export


makeDataset <- function(input.folder, output.folder, cell.lines = c("A549", "CCL-185-IG", "CRL5868", "DV90", "HCC78", "HTB178", "PC9", "PBMCs"),
                        n.cells=c(100,100,100,100,100,100,100,10)){



  matrix_dir = paste(input.folder, cell.lines[1], sep="/")
  barcode.path <- paste(matrix_dir, "barcodes.tsv.gz", sep="/")
  features.path <- paste(matrix_dir, "features.tsv.gz", sep="/")
  matrix.path <- paste(matrix_dir, "matrix.mtx.gz", sep="/")
  mat <- readMM(file = matrix.path)
  mat.out <- emptySparse(nrow=dim(mat)[1], ncol=sum(n.cells), format="C")
  rownames(mat.out) = feature.names$V1
  start=1
  end=NULL
  col.mat.out = NULL
  for (i in 1:length(cell.lines)){
    matrix_dir = paste(input.folder, cell.lines[i], sep="/")
    barcode.path <- paste(matrix_dir, "barcodes.tsv.gz", sep="/")
    features.path <- paste(matrix_dir, "features.tsv.gz", sep="/")
    matrix.path <- paste(matrix_dir, "matrix.mtx.gz", sep="/")
    mat <- readMM(file = matrix.path)
    feature.names = read.delim(features.path,
                             header = FALSE,
                             stringsAsFactors = FALSE)
    barcode.names = read.delim(barcode.path,
                             header = FALSE,
                             stringsAsFactors = FALSE)
    colnames(mat) = barcode.names$V1
    rownames(mat) = feature.names$V1
    #subsetting
    n.tmp = sample(x=seq(1,dim(mat)[2]), size=n.cells[i])
    col.mat.out = c(col.mat.out, barcode.names$V1[n.tmp])
    tmp.mat.s = mat[,n.tmp]
    end = start + n.cells[i] - 1
    mat.out[,start:end] = tmp.mat.s
    start = end + 1
  }
  colnames(mat.out) = col.mat.out
# writing borrowd from Write count data in the 10x format Aaron Lun

  writeMM(mat.out, file=file.path(output.folder, "matrix.mtx"))
  write(as.character(col.mat.out), file=file.path(output.folder, "barcodes.tsv"))
  write.table(feature.names, file=file.path(output.folder, "features.tsv"), row.names=FALSE, col.names=FALSE, quote=FALSE, sep="\t")

  gzip(file.path(output.folder, "matrix.mtx"))
  gzip(file.path(output.folder, "barcodes.tsv"))
  gzip(file.path(output.folder, "features.tsv"))
  return(NULL)

}