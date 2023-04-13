#' The Ames Police Department Press Log data set
#'
#' @format A data frame of past Ames Police Department Press Logs.
#' \describe{
#'  \item{Call Received Date/Time}{when the service call was received}
#'  \item{Incident ID}{incident id}
#'  \item{How Call was Rec'd}{the medium used to contact Ames PD}
#'  \item{Nature Code Description}{description of the incident}
#'  \item{Location Address}{where the incident occured}
#'  \item{Report Number Assigned to Event}{report number if a report was generated}
#'  \item{Closing Disposition or Cancel Code}{short acronym describing the type of incident}
#' }
#' @source Ames Police Department
#'
#' @examples
#' head(presslog_ames)
#' dim(presslog_ames)
"presslog_ames"


#' The ISU Police Department Press Log data set
#'
#' @format A data frame of past ISU Police  Press Logs.
#' \describe{
#'  \item{Case.Number}{case number}
#'  \item{Date.Time.Reported}{date of report}
#'  \item{Earliest.Occurrence}{date of earliest occurrence}
#'  \item{Latest.Occurrence}{date of latest occurrence}
#'  \item{General.Location}{description of the location}
#'  \item{Disposition}{is it closed?}
#'  \item{Classification}{on the report. so many ways to spell things}
#'  \item{longitude}{in degree}
#'  \item{latitude}{in degree}
#' }
#' @source ISU Police Department
#' @examples
#' head(presslog_isu)
#' dim(presslog_isu)
"presslog_isu"
