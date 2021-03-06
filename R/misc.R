#' Easy episode id padding
#'
#' Simple function to ease the creation of \code{sXXeYY} episode ids.
#' @param s Input season number, coerced to \code{character}.
#' @param e Input episode number, coerced to \code{character}.
#' @param width The length of the padding. Defaults to 2.
#' @return A \code{character} in standard \code{sXXeYY} format
#' @family utility functions
#' @export
#' @note I like my sXXeYY format, okay?
#' @examples
#' pad(2, 4) # Returns "s02e04"
pad <- function(s = "0", e = "0", width = 2){
  s <- as.character(s)
  e <- as.character(e)
  season <- sapply(s, function(x){
              if (nchar(x, "width") < width){
                missing <- width - nchar(x, "width")
                x.pad   <- paste0(rep("0", missing), x)
                return(x.pad)
              } else {
                return(x)
              }
            })
  episode <- sapply(e, function(x){
                if (nchar(x, "width") < width){
                  missing <- width - nchar(x, "width")
                  x.pad   <- paste0(rep("0", missing), x)
                  return(x.pad)
                } else {
                  return(x)
                }
              })
  epstring <- paste0("s", season, "e", episode)
  return(epstring)
}

#' Get info from a show URL
#'
#' \code{parse_trakt_url} extracts some info from a show URL
#' @param url Input URL. must be a \code{character}, but not a valid URL.
#' @param epid Whether the episode ID (\code{sXXeYY} format) should be extracted.
#' Defaults to \code{FALSE}.
#' @param getslug Whether the \code{slug} should be extracted. Defaults to \code{FALSE}.
#' @return A \code{list} containing at least the show name.
#' @family utility functions
#' @export
#' @importFrom stringr str_split
#' @note This is pointless.
#' @examples
#' parse_trakt_url("http://trakt.tv/show/fargo/season/1/episode/2", TRUE, TRUE)
#' parse_trakt_url("http://trakt.tv/show/breaking-bad", TRUE, FALSE)
parse_trakt_url <- function(url, epid = FALSE, getslug = FALSE){
  showname <- stringr::str_split(url, "/")[[1]][5]
  ret <- list("show" = showname)
  if (epid){
    season   <- stringr::str_split(url, "/")[[1]][7]
    episode  <- stringr::str_split(url, "/")[[1]][9]
    if(is.na(season) | is.na(episode)){
      ret$epid <- NA
    } else{
      epid     <- pad(season, episode)
      ret$epid <- epid
    }
  }
  if (getslug){
    slug <- stringr::str_split(url, "/", 5)
    ret$slug <- slug[[1]][5]
  }
  return(ret)
  # Most of this is pointless.
}

#' Quick datetime conversion
#'
#' Searches for datetime variables and converts them to \code{POSIXct} via \pkg{lubridate}.
#' @param object The input object. Must be \code{data.frame} or \code{list}
#' @return The same object with converted datetimes
#' @importFrom lubridate parse_date_time
#' @keywords internal
convert_datetime <- function(object){
  if (!(class(object) %in% c("data.frame", "list"))){
    stop("Object type not supported")
  } else if (is.null(object) | identical(object, list())){
    warning("Object is empty, returning without action")
    return(objects)
  }

  datevars <- c("first_aired", "updated_at", "listed_at", "last_watched_at",
                "rated_at", "friends_at", "followed_at", "collected_at", "joined_at")

  for (i in names(object)){
    if (i %in% datevars & !("POSIXct" %in% class(object[[i]]))){
      newdates    <- lubridate::parse_date_time(object[[i]],
                                  "%y-%m-%d %H-%M-%S%z*!", truncated = 3, tz = "UTC")
      object[[i]] <- newdates
    } else if (i %in% c("released", "release_date")){
      object[[i]] <- as.POSIXct(object[[i]], tz = "UTC")
    }
  }
  return(object)
}

#' Assemble a trakt.tv API URL
#'
#' \code{build_trakt_url} assembles a trakt.tv API URL from different arguments.
#' The result should be fine for use with \link{trakt.api.call}, since that's what this
#' function was created for.
#' @param section The section of the API methods, like \code{shows} or \code{movies}.
#' @param target1,target2,target3,target4 The target object, usually a show or
#' movie \code{slug} or something like \code{trending} and \code{popular}.
#' Will be concatenated after \code{section} to produce
#' a URL fragment like \code{movies/tron-legacy-2012/releases}.
#' @param extended Whether extended info should be returned. Defaults to \code{min}.
#' @param ... Other params used as \code{queries}. Must be named arguments like \code{name = value}.
#' @return A \code{character} of class \code{url}.
#' @family utility functions
#' @export
#' @note Please be aware that the result of this function is not verified to be a working trakt.tv
#' API URL. See \href{http://docs.trakt.apiary.io/#introduction/pagination}{the trakt.tv API docs for
#' more information}.
#' @examples
#' build_trakt_url("shows", "breaking-bad", extended = "full")
#' build_trakt_url("shows", "popular", page = 3, limit = 5)
build_trakt_url <- function(section, target1 = NULL, target2 = NULL, target3 = NULL,
                            target4 = NULL, extended = "min", ...){
  # Set base values required for everything
  url        <- list(scheme = "https", hostname = "api-v2launch.trakt.tv")
  # Set other values
  url$path   <- paste(section, target1, target2, target3, target4, sep = "/")
  url$query  <- list(..., extended = extended)
  # Append class 'url' for httr
  class(url) <- "url"
  # Assemble url
  url        <- httr::build_url(url)
  return(url)
}
