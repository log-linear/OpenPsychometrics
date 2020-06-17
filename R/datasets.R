#===============================================================================
# author: Victor Faner
# description: Functions for downloading datasets from 
#   https://openpsychometrics.org/_rawdata/
#===============================================================================

list_datasets <- function() {
  html <- xml2::read_html("https://openpsychometrics.org/_rawdata/")
  node <- rvest::html_nodes(html, "table")[[1]]
  d <- rvest::html_table(node, header = T)
  d <- transform(d, n = as.numeric(gsub(",", "", n)))
  
  return(d)
}

read_dataset <- function(dataset) {
  url <- paste0("https://openpsychometrics.org/_rawdata/", dataset, ".zip")
  td <- tempdir()
  tf <- tempfile(tmpdir = td)
  download.file(url, tf, quiet = T)
  fname <- paste(dataset, "data.csv", sep = "/")
  unzip(tf, files = fname, exdir = td, overwrite = T)
  f <- file.path(td, fname)
  d <- data.table::fread(f)
  
  return(d)
}
