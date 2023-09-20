#' @title A function to build cancer dataset using BE1 sparse matrices.
#' @description This function extract from BE1 experiment a set of cells on the basis of the user requirement
#' @param cell.lines, a vector indicating the cell lines to be included in the dataset. Seven options:
#' @param n.cells, a vector indicating the number of cell for each cell line. If the number of cell exceed the number of available cell in a data set the full dataset is used.
#' @param output.folder, a character string indicating the path where to save the data.
#' @param input.folder, a character string indicating the path where BE1run12.zip from figshare https://figshare.com/articles/dataset/BE1_10XGenomics_count_matrices/23939481 has been downloaded.
#' @author Raffaele Calogero, raffaele.calogero [at] unito [dot] it, University of Torino, Italy
#' @return  A 10XGenomics sparse matrix
#'
#' @examples
#' \dontrun{
#'
#' #download https://figshare.com/articles/dataset/BE1_10XGenomics_count_matrices/23939481
#' #the downloade file is named BE1run12.zip
#' unzip("BE1run12.zip")
#' makeDataset(input.folder="/Users/raffaelecalogero/Desktop/BE1run12",
#'               output.folder="/Users/raffaelecalogero/Desktop/tmp",
#'               cell.lines = c("A549", "CCL-185-IG", "CRL5868", "DV90", "HCC78", "HTB178", "PC9", "PBMCs"),
#'               n.cells=c(100,100,100,100,100,100,100,10))
#'
#' }
#'
#' @export


makeDataset <- function(input.folder, output.folder, cell.lines = c("A549", "CCL-185-IG", "CRL5868", "DV90", "HCC78", "HTB178", "PC9", "PBMCs"),
                        n.cells=c(100,100,100,100,100,100,100,10)){

  matrix_dir = paste(input.folder, cell.lines[1], sep="/")
  if(!file.exists(matrix_dir)){
    cat("\nError the folder where BE1 data should be located does not exist! Please download it from figshare, see makeDataset help parameter input.folder\n")
  }
  if(!file.exists(output.folder)){
    file.create(output.folder)
  }
  barcode.path <- paste(matrix_dir, "barcodes.tsv.gz", sep="/")
  features.path <- paste(matrix_dir, "features.tsv.gz", sep="/")
  matrix.path <- paste(matrix_dir, "matrix.mtx.gz", sep="/")
  mat <- Matrix::readMM(file = matrix.path)
  mat.out <- MatrixExtra::emptySparse(nrow=dim(mat)[1], ncol=sum(n.cells), format="C")
  feature.names = utils::read.delim(features.path, header = FALSE, stringsAsFactors = FALSE)
  #barcode.names = read.delim(barcode.path, header = FALSE, stringsAsFactors = FALSE)
  rownames(mat.out) = feature.names$V1

  start=1
  end=NULL
  col.mat.out = NULL
  for (i in 1:length(cell.lines)){
    matrix_dir = paste(input.folder, cell.lines[i], sep="/")
    barcode.path <- paste(matrix_dir, "barcodes.tsv.gz", sep="/")
    features.path <- paste(matrix_dir, "features.tsv.gz", sep="/")
    matrix.path <- paste(matrix_dir, "matrix.mtx.gz", sep="/")
    mat <- Matrix::readMM(file = matrix.path)
    feature.names = utils::read.delim(features.path,
                             header = FALSE,
                             stringsAsFactors = FALSE)
    barcode.names = utils::read.delim(barcode.path,
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

  Matrix::writeMM(mat.out, file=file.path(output.folder, "matrix.mtx"))
  write(as.character(col.mat.out), file=file.path(output.folder, "barcodes.tsv"))
  utils::write.table(feature.names, file=file.path(output.folder, "features.tsv"), row.names=FALSE, col.names=FALSE, quote=FALSE, sep="\t")

  R.utils::gzip(file.path(output.folder, "matrix.mtx"))
  R.utils::gzip(file.path(output.folder, "barcodes.tsv"))
  R.utils::gzip(file.path(output.folder, "features.tsv"))
  return(NULL)

}
