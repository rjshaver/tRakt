#' Get all the show data
#'
#' \code{trakt.get_full_showdata} is a combination function of multiple
#' functions in this package. The idea is to easily execute all major functions
#' required to get a full show dataset.
#'
#' @param query Keyword used for \link{trakt.search}. Optional.
#' @param slug Used if \code{query} is not specified. Optional, but gives exact results.
#' @param dropunaired If \code{TRUE}, episodes which have not aired yet are dropped.
#' @return A \code{list} containing multiple \code{lists} and \code{data.frames} with show info.
#' @export
#' @importFrom stats sd
#' @note This is primarily intended to be a convenience function for the case where you
#' really want all that data. If you're just derping around, maybe you should consider interactively
#' calling the other functions.
#' @family show data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' # Use the search within the function
#' breakingbad <- trakt.get_full_showdata("Breaking Bad")
#' # Alternatively, us a slug for explicit results
#' breakingbad <- trakt.get_full_showdata(slug = "breaking-bad")
#' }
trakt.get_full_showdata <- function(query = NULL, slug = NULL, dropunaired = TRUE){

  # Construct show object
  show        <- list()
  if (!is.null(query)) {
    show$info <- trakt.search(query)
    slug      <- show$info$ids$slug
  } else if (is.null(query) & is.null(slug)) {
    stop("You must provide either a search query or a trakt.tv slug")
  }
  show$summary  <- trakt.show.summary(slug, extended = "full")
  show$seasons  <- trakt.seasons.summary(slug, extended = "full", dropspecials = TRUE)
  show$episodes <- trakt.get_all_episodes(slug, show$seasons$season,
                                        dropunaired = dropunaired, extended = "full")

  show$seasons$season  <- factor(show$seasons$season,
                                 levels = as.character(1:nrow(show$seasons)), ordered = T)
  show$episodes$series <- show$summary$title
  show$summary$tpulled <- lubridate::now(tzone = "UTC")

  return(show)
}
