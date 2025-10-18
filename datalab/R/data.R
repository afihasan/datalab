#' Sample Agriculture Dataset
#'
#' A dataset containing crop yield and soil nitrogen content measurements.
#'
#' @format A data frame with 50 rows and 2 variables:
#' \describe{
#'   \item{nitrogen_content}{Soil nitrogen content in mg/kg}
#'   \item{crop_yield}{Crop yield in kg per hectare}
#' }
#' @examples
#' \dontrun{
#' data(agriculture_data)
#' linechart(nitrogen_content, crop_yield)
#' }
"agriculture_data"

#' Sample Heart Disease Dataset
#'
#' A dataset containing patient information and heart disease indicators.
#'
#' @format A data frame with 200 rows and 5 variables:
#' \describe{
#'   \item{age}{Patient age in years}
#'   \item{sex}{Patient sex (Male/Female)}
#'   \item{chest_pain_type}{Type of chest pain (A/B/C/D)}
#'   \item{resting_bp}{Resting blood pressure in mm Hg}
#'   \item{cholesterol}{Serum cholesterol in mg/dl}
#' }
#' @examples
#' \dontrun{
#' data(heart_data)
#' piechart(chest_pain_type, sex)
#' }
"heart_data"