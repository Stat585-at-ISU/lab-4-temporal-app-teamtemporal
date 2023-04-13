#' Download the current presslog
#'
#' @importFrom utils download.file
#' @importFrom utils write.csv
#' @importFrom utils tail
#'
#' @param url  url to download a press log from
#' @param save_as file path to save press log to
#'
#' @return Character of the location of the saved pdf file.
#' @export
get_pd_presslog <- function(url = "https://data.city.ames.ia.us/publicinformation/PressLog.pdf",
                            save_as = sprintf("presslog_amespd_%s.pdf", lubridate::today())) {

  if (!file.exists(save_as)) {
    download.file(url = url,
                  destfile = save_as,
                  mode="wb")
  }

  return(save_as)
}
