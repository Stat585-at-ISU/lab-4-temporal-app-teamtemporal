#' Function to run the shiny app
#'
#' @param x shiny app to run
#'
#' @importFrom shiny runApp
#'
#' @export
runExample <- function(x) {
  appDir <- system.file("shiny_examples", "myapp",
                        package = "AmesPD")
  if (appDir == "") {
    stop(paste0("Could not find example directory. ",
                "Try re-installing `AmesPD`."), call. = FALSE)
  }
  # the first app will be called
  shiny::runApp(appDir[1], display.mode = "normal")
}
