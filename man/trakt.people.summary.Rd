% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trakt.people.R
\name{trakt.people.summary}
\alias{trakt.people.summary}
\title{Get a single person's details}
\usage{
trakt.people.summary(target, extended = "min")
}
\arguments{
\item{target}{The \code{id} of the person requested. Either the \code{slug}
(e.g. \code{"bryan-cranston"}), \code{trakt id} or \code{IMDb id}}

\item{extended}{Whether extended info should be provided.
Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}}
}
\value{
A \code{data.frame}s with person details.
}
\description{
\code{trakt.people.summary} pulls show people data.
}
\details{
Get a single person's details, like their various ids. If \code{extended} is \code{"full"},
there will also be biographical data if available.
}
\note{
See \href{http://docs.trakt.apiary.io/reference/people/summary/get-a-single-person}{the trakt API docs for further info}
}
\examples{
\dontrun{
get_trakt_credentials() # Set required API data/headers
person <- trakt.people.summary("bryan-cranston")
}
}
\seealso{
Other people data: \code{\link{trakt.movie.people}},
  \code{\link{trakt.people.movies}},
  \code{\link{trakt.people.shows}},
  \code{\link{trakt.show.people}}
}

