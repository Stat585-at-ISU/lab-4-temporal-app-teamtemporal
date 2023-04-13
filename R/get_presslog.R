#' Get the presslog for Ames PD for an interval
#'
#' @importFrom utils download.file tail data
#' @importFrom lubridate as_date
#' @importFrom dplyr filter arrange `%>%` between
#' @importFrom rlang .data
#'
#' @param from date in YYYY-MM-DD format
#' @param to date in YYYY-MM-DD format
#'
#' @return data frame with call logs
#' @export
get_presslog_ames<-function(from=lubridate::today(), to=lubridate::today()){
  # activate the presslog data
  presslog_ames <- NULL
  data(presslog_ames, envir=environment())

  # convert to lubridate
  from <- lubridate::as_date(from)
  to <- lubridate::as_date(to)

  # filtering by input from and to dates
  presslog_ames_filter <- presslog_ames %>%
    dplyr::filter(between(.data$`Call Received Date/Time`, from, to)) %>%
    dplyr::arrange(dplyr::desc(.data$`Call Received Date/Time`))

  return(presslog_ames_filter)
}



#' Get the presslog for ISU PD for an interval
#'
#' @importFrom utils download.file tail data
#' @importFrom lubridate as_date
#' @importFrom dplyr filter arrange `%>%` between
#' @importFrom rlang .data
#'
#' @param from date in YYYY-MM-DD format
#' @param to date in YYYY-MM-DD format
#'
#' @return data frame with call logs
#' @export
get_presslog_isu<-function(from=lubridate::today(), to=lubridate::today()){
  # activate the presslog data
  presslog_isu <- NULL
  data(presslog_isu, envir=environment())

  # convert to lubridate
  from <- lubridate::as_date(from)
  to <- lubridate::as_date(to)

  # filtering by input from and to dates
  presslog_isu_filter <- presslog_isu %>%
    dplyr::filter(between(.data$`Date.Time.Reported`, from, to)) %>%
    dplyr::arrange(dplyr::desc(.data$`Date.Time.Reported`))

  return(presslog_isu_filter)
}
