# helper function
duplicates <- function(string) {
  # find the first '\r', delete everything afterwards
  # str_locate(string, pattern='\r')
  stopifnot(length(string)==1)
  splitter <- strsplit(string, split="\r")
  res <- unique(splitter[[1]])
  if (length(res) > 1) warning(sprintf("Multiple different values found in string: %s", paste(res, collapse=",")))
  res[1]
}


# helper function
#' @importFrom purrr map_chr
#' @importFrom tibble as_tibble
#' @importFrom readr parse_number
#' @importFrom dplyr mutate
#' @importFrom rlang .data
one_page <- function(plogi) {
  # take one of the pages, make into a data frame

  # Variables are in the first data row:
  variables <- plogi[1,]
  # remove the '\r'
  variables <- gsub("\r"," ", variables)

  plogi <- plogi[-1,, drop=FALSE]

  for (i in 1:ncol(plogi))
    plogi[,i] <- plogi[,i] %>% purrr::map_chr(.f = duplicates)

  # remove empty columns
  idx <- which(variables == "")
  if (length(idx) > 0) {
    if (all(is.na(plogi[,idx]))) {
      plogi <- plogi[,-idx, drop=FALSE]
      variables <- variables[-idx]
    }
  }
  dframe <- as_tibble(plogi, .name_repair = "minimal")
  names(dframe) <- variables

  dframe <- dframe %>% mutate(
    `Incident ID` = parse_number(.data$`Incident ID`),
    `Report Number Assigned to Event` = parse_number(.data$`Report Number Assigned to Event`)
  )
  dframe
}

#' Convert pdf presslog into a csv table
#'
#' @importFrom utils download.file
#' @importFrom utils write.csv
#' @importFrom utils tail
#' @importFrom tabulizer extract_tables
#' @importFrom lubridate mdy_hm year month mday
#' @importFrom readr write_csv
#'
#' @param pdfs path(s) to a (set of) pdf file(s)
#'
#' @export
pdf_to_tbl <- function(pdfs) {
  for (pdf_file in pdfs) {
    plog <- extract_tables(pdf_file, output='matrix', method="lattice")

    all_pages <- plog %>% purrr::map_df(.f = one_page)
    date <- lubridate::mdy_hm(all_pages$`Call Received Date/Time`[1])
    write_csv(all_pages, file=sprintf("inst/data-raw/presslog-%s%02d%02d.csv",year(date),
                                      month(date), mday(date)))
  }
}
