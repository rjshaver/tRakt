#' Get a single person's details
#'
#' \code{trakt.people.summary} pulls show people data.
#'
#' Get a single person's details, like their various ids. If \code{extended} is \code{"full"},
#' there will also be biographical data if available.
#' @param target The \code{id} of the person requested. Either the \code{slug}
#' (e.g. \code{"bryan-cranston"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{data.frame}s with person details.
#' @export
#' @importFrom purrr flatten
#' @importFrom purrr map_df
#' @note See \href{http://docs.trakt.apiary.io/reference/people/summary/get-a-single-person}{the trakt API docs for further info}
#' @family people data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' person <- trakt.people.summary("bryan-cranston")
#' }
trakt.people.summary <- function(target, extended = "min"){

  if (length(target) > 1) {
    response <- purrr::map_df(target, function(t){
      response <- trakt.people.summary(target = t, extended = extended)
      response$person <- t
      return(response)
    })
    return(response)
  }

  # Construct URL, make API call
  url      <- build_trakt_url("people", target, extended = extended)
  response <- trakt.api.call(url = url)

  # Flatten the data.frame
  response <- purrr::flatten(response)

  return(response)
}

#' Get a single person's movie credits
#'
#' \code{trakt.people.movies} pulls show people data.
#'
#' Returns all movies where this person is in the cast or crew.
#' @param target The \code{id} of the person requested. Either the \code{slug}
#' (e.g. \code{"bryan-cranston"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{data.frame}s with person details.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/people/movies/get-movie-credits}{the trakt API docs for further info}
#' @family people data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' person <- trakt.people.movies("bryan-cranston")
#' }
trakt.people.movies <- function(target, extended = "min"){

  response <- trakt.people.credits("movies", target, extended = "min")

  return(response)
}

#' Get a single person's show credits
#'
#' \code{trakt.people.shows} pulls show people data.
#'
#' Returns all shows where this person is in the cast or crew.
#' @param target The \code{id} of the person requested. Either the \code{slug}
#' (e.g. \code{"bryan-cranston"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{data.frame}s with person details.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/people/shows/get-show-credits}{the trakt API docs for further info}
#' @family people data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' person <- trakt.people.shows("bryan-cranston")
#' }
trakt.people.shows <- function(target, extended = "min"){

  response <- trakt.people.credits("shows", target, extended = "min")

  return(response)
}

#' @keywords internal
trakt.people.credits <- function(type, target, extended = "min"){

  # Construct URL, make API call
  url      <- build_trakt_url("people", target, type , extended = extended)
  response <- trakt.api.call(url = url)

  if (identical(response, list())) {
    return(NULL)
  }

  # Flattening cast
  if ("show" %in% names(response$cast)) {
    response$cast$show  <- cbind(response$cast$show[names(response$cast$show) != "ids"],
                                 response$cast$show$ids)
    response$cast       <- cbind(response$cast[names(response$cast) != "show"],
                                 response$cast$show)
  } else if ("movie" %in% names(response$cast)){
    response$cast$movie <- cbind(response$cast$movie[names(response$cast$movie) != "ids"],
                                 response$cast$movie$ids)
    response$cast       <- cbind(response$cast[names(response$cast) != "movie"],
                                 response$cast$movie)
  }
  response$cast       <- convert_datetime(response$cast)

  return(response)
}

#' Get the cast and crew of a show
#'
#' \code{trakt.show.people} pulls show people data.
#'
#' Returns all cast and crew for a show, depending on how much data is available.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"game-of-thrones"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{list} containing \code{data.frame}s for cast and crew.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/people/get-all-people-for-a-show}{the trakt API docs for further info}
#' @family show data
#' @family people data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.people <- trakt.show.people("breaking-bad")
#' }
trakt.show.people <- function(target, extended = "min"){

  # Construct URL, make API call
  response <- trakt.media.people("shows", target = target, extended = extended)

  return(response)
}

#' Get the cast and crew of a movie
#'
#' \code{trakt.movie.people} pulls movie people data.
#'
#' Returns all cast and crew for a movie, depending on how much data is available.
#' @param target The \code{id} of the movie requested. Either the \code{slug}
#' (e.g. \code{"tron-legacy-2010"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{list} containing \code{data.frame}s for cast and crew.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/movies/people/get-all-people-for-a-movie}{the trakt API docs for further info}
#' @family movie data
#' @family people data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' tron.people <- trakt.movie.people("tron-legacy-2010")
#' }
trakt.movie.people <- function(target, extended = "min"){

  response <- trakt.media.people("movies", target = target, extended = extended)

  return(response)
}

#' @keywords internal
trakt.media.people <- function(type, target, extended = "min"){

  # Construct URL, make API call
  url      <- build_trakt_url(type, target, "people", extended = extended)
  response <- trakt.api.call(url = url)

  if (identical(response, list())) {
    return(NULL)
  }

  # Flatten the data.frame
  response$cast  <- cbind(response$cast[names(response$cast) != "person"], response$cast$person)
  response$cast  <- cbind(response$cast[names(response$cast) != "ids"],    response$cast$ids)

  return(response)
}
