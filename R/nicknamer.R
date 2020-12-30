#' Get citations for CSPP variables
#'
#' \code{nicknamer} generates a dataframe of common nicknames matched to first
#' names. The resulting dataframe can be in wide or long format.
#'
#' @name names
#'
#' @param format Default is long. Takes either "long" or "wide". The long
#'   version contains one row per name-nickname match. The wide format contains
#'   one row per name, with all possible nicknames in individual columns.
#' @param transform Default is NULL, resulting in no string transformation to
#'   names. Options are "to_upper" or "to_lower", resulting in lower case or
#'   uppercase transformations respectively.
#' @param reverse Default is FALSE. If set to true, the nickname and names are
#'   switched. This will result in different output when the format is set to
#'   "wide" as it will now be one row per nickname as opposed to one row per
#'   name. E.g.: "Alex" as a nickname will now be associated with "Alexander"
#'   and "Alexandra".
#' @param opt_function Default is NULL. Allows the user to pass custom functions
#'   to the name and nickname columns, such as \code{stringr::str_sub} or
#'   any user-written function that parses strings.
#'
#' @importFrom dplyr "%>%"
#'
#' @return dataframe
#'
#' @export
#'
#' @examples
#'
#' # standard long dataframe
#' names <- nicknamer()
#'
#' # wide dataframe transformed to lower case
#' names.wide <- nicknamer(format="wide", transform = "to_lower")
#'
#' # wide dataframe with nickname as the row
#' names.wide <- nicknamer(format="wide", transform = "to_lower", reverse=T)
#'
#' # optional function applied to names:
#' short.names <- nicknamer(
#'   format="wide",
#'   transform = "to_lower",
#'   opt_function = function(x) { str_sub(x, 1, 3) }
#' )


nicknamer <- function(format = "long", transform = NULL, reverse = FALSE, opt_function = NULL){

  if(format != "long" & format != "wide"){
    warning("Format must be one of 'long' or 'wide'. Outputting data in long format.")
    format <- "long"
  }

  if(reverse == TRUE){
    names(nicknames) <- c("nickname", "name")
  }

  if(!is.null(transform)) {
    if(transform == "to_upper") {
      nicknames$name <- stringr::str_to_upper(nicknames$name)
      nicknames$nickname <- stringr::str_to_upper(nicknames$nickname)
    }
    if(transform == "to_lower") {
      nicknames$name <- stringr::str_to_lower(nicknames$name)
      nicknames$nickname <- stringr::str_to_lower(nicknames$nickname)
    }
  }

  if(!is.null(opt_function)) {
    if(!is.function(opt_function)){
      stop("The 'opt_function' parameter only takes a function as a value.")
    }
    #opt_function <- function(x){ str_replace_all(x, "A", "Z") }
    nicknames$name <- opt_function(nicknames$name)
    nicknames$nickname <- opt_function(nicknames$nickname)
  }

  if(format == "long") {
    return(nicknames)
  }

  if(format == "wide") {
    # most is 16 names
    nicknames <- nicknames %>%
      dplyr::group_by(name) %>%
      tidyr::nest(data = nickname) %>%
      tidyr::unnest_wider(data) %>%
      tidyr::unnest_wider(nickname, names_sep = "_")
  }

  return(nicknames)

}

