# tRakt 0.13.2

- Migrate from `plyr` to `purrr` and `dplyr`

# tRakt 0.13.1

* Handle `NULL` cases for user functions (return `NULL` instead of failing on `list()`s).
* Fix ids in `trakt.shows.trending` not being moved properly.
* Make `convert_datetime` (internal) not fail on `NULL` or empty list input.
* Improve consistency of "season" variable, now always an ordered factor.
* `trakt.api.call` doesn't throw an error but only a warning on trakt availability
  * Idea is to not completely fail if trakt throws a 5xx error
* Fix up `trakt.stats` since it's now functional.
* Drop episodes numbered as `0`

# tRakt 0.13.0

* **Rename** `trakt.getEpisodeData` -> `trakt.get_all_episodes`
    * Expand handling of `season_nums` argument to make it easier to get all episodes of a show.
    * Vectorize to enable multiple target input
* **Rename** `trakt.getFullShowData` -> `trakt.get_full_showdata`

# tRakt 0.12.1

* Vectorize `trakt.seasons.summary`
* Fix some bugs
* Improve tests

# tRakt 0.12.0

## API changes, functional fixes

* **Add** `dropunaired` param to `trakt.seasons.summary` (defaults to `TRUE`).
    * Requires `extended` to be more than `min` since the required `aired_episodes` field
    is only present with higher levels of detail.
* **Add** `extended` param to `trakt.user.f*`
* **Fix** `trakt.user.f*` now return `NULL` when the user is private instead of failing.

## Internal changes

* User internal, generalized functions to reduce duplicate code for the following:
    * `trakt.*.popular`
    * `trakt.*.related`
    * `trakt.*.trending`
    * `trakt.*.summary`
    * `trakt.*.ratings`

## Vectorization improvements

* **Add** multiple target input support (vectorization) for:
    * `trakt.user.f*` functions: Results will be `rbind`ed together and a `source_user` column is appended.
    * `trakt.seasons.season`: Soon to make `trakt.getEpisodeData` obsolete.
    * `trakt.*.summary`: Forces `force_data_frame` to `TRUE` to enable `rbind`ing.
    * `trakt.*.related`: Appends `source` column containing respective input `id`.
    * `trakt.*.ratings`: Returns result as a `list` with each entry containing data for each
    show or movie to accommodate the `distribution` variable (`data.frame`)
    * `trakt.people.summary`: Appends `person` column with `target` id.
    * `trakt.*.watching`: Returns `data.frame` with `source` column containing each `target`.

# tRakt 0.11.3

## API changes, functional fixes

* **Add** `build_trakt_url` to ease trakt API URL assembly and reduce duplicate code.
* **Add** `force_data_frame` option to `trakt.*.summary`: Forces unnesting.
* **Rename** `trakt.show.stats` to `trakt.stats`, will work with both movies and shows
as soon as the API endpoint actually works.

## Minor changes

* Expand `@family` tags in docs a little

# tRakt 0.11.2

## API changes, functional fixes

* **Add** `trakt.movie.watching` and `trakt.show.watching`: Get trakt.tv users watching.
* **Add** `trakt.movie.releases`: Gets release dates & certifications per movie.
* **Fix** `trakt.search.byid`: Used to only work on shows, now actually works on movies.
* **Fix** `convert_datetime` (internal): improve reliability.

## Minor changes

* Fix documentation error in `*.movie.*` functions.
* Added tests for new functions

# tRakt 0.11.1

* Internal restructuring (moving functionally similar functions together)
    * **TODO**: Create generic functions for both movie and show functions to reduce duplicate code
* **Add** `extended` param to `trakt.user.watchlist`
* Improve consistency between `trakt.user.watched` and `trakt.user.collection`
    * Rename `slug` to `id.slug`
    * Ensure proper datetime conversion
* **Fix** error in `trakt.user.watchlist` when `type = shows` was ignored by accident


# tRakt 0.11.0

* **Rename** `trakt.getSeasons  -> trakt.seasons.summary` for consistency with the trakt API.
* **Rename** `trakt.show.season -> trakt.seasons.season` for consistency with the trakt API.
* **Rename** `getNameFromUrl    -> parse_trakt_url` to be more descriptive. Also, de-camelCasezation.
* Update vignette to reflect the above changes
* **Add** some `people` functions:
    * `trakt.people.summary`
    * `trakt.people.movies`
    * `trakt.people.shows`
* Unify output of `trakt.show.people` and `trakt.movie.people`
* **Add** `extended` argument to `trakt.movies.related` and `trakt.shows.related` (defaults to `min`)
* **Add** `page` param to [paginated](http://docs.trakt.apiary.io/#introduction/pagination) functions:
    * `trakt.shows.popular`
    * `trakt.shows.trending`
    * `trakt.movies.popular`
    * `trakt.movies.trending`
* The usual bug fixes

# tRakt 0.10.3

* `trakt.user.stats`:  
    * Tidy up rating distribution
    * **Remove** `to.data.frame` option because the output is too messy
* Add another `@family` tag to docs for aggregation functions (`.popular`, `.trending`, `.related`)
* Individual functions don't have to warn about missing headers, that's `trakt.api.call`'s job.
* `trakt.getEpisodeData`:
    * Explicitly drop episodes with `NA` firstaired fields
    * The `episode_abs` field is usually `NA`, so let's dump `epnum` on it
* Use `extended = "min"` as default across functions for consistency with the trakt API

# tRakt 0.10.2

* Add `year` parameter to `trakt.search`
* If `query` in `trakt.search` ends with a 4 digit number, this will be used as `year` parameter and stripped from the original `query`
* Minor internal fixes

# tRakt 0.10.1

* Add `testthat` tests
* Internal changes to how/where datetime variables are converted (user doesn't see any of that)
    * If `lubridate::parse_date_time` fails, `as.POSIXct` is used as a fallback
* Various bug fixes

# tRakt 0.10.0

* **Add** movie functions:
    * `trakt.movies.popular`: Analogous to `trakt.shows.popular`
    * `trakt.movies.trending`: Analogous to `trakt.shows.trending`
    * `trakt.movie.summary`: Get a single movie's details, analogous to `trakt.show.summary`
    * `trakt.movies.related`: Get related movies
    * `trakt.movie.people`: Analogous to `trakt.show.people`
* **Add** both `trakt.show.ratings` and `trakt.movie.ratings` to receive just the ratings and distribution for a single show or movie
* **Rename** `trakt.show.related` -> `trakt.shows.related` for consistency with `.trending` and `.popular`
* Expand allowed `target` params in accordance with changed trakt API docs

# tRakt 0.9.0

* Specified more exclusive package version requirements to avoid unforseen errors
* Add `trakt.user.ratings`: Currently supported types: `shows`, `movies`, `episodes`
* Add `extended` option to `trakt.shows.popular` and `.trending`
* Make code in vignette a little more robust

# tRakt 0.8.1

* Fix a whole bunch of typos I only found *after* the CRAN release, naturally
* Improve consistency across functions
    * The date fields ending in `.posix` have been removed and the existing date fiels are now converted to `POSIXct` to remove cluttering
    * `firstaired.posix` -> `first_aired` etc
* Update vignette for the above change

# tRakt 0.8.0

* Added more user-facing functions (`trakt.user.following` / `.followers` / `.friends`) because maybe I want to throw [networkD3](https://github.com/christophergandrud/networkD3) at my people
* Improve consistency with date variables: The `.posix` variables should be removed and the existing date variables should just be properly converted to `POSIXct`
* Improve documentation: Added `@family` tags to all functions to group them together
* Add a package vignette
* Minor fixes and non-breaking additions
* Trying to keep things organized and all I got was this inconsistently header'd NEWS.md

# tRakt 2015-02-16

I've been working on some user-specific methods, so you can now use the `trakt.user.*` family of functions to get a user's…

* Collection: `trakt.user.collection()`
* Watched items: `trakt.user.watched()`
* Stats: `trakt.user.stats()`

All of them default to the username set in `getOption("trakt.username")`, but any publicly viewable user should work. Note that OAuth2 is not implemented, so private users can't be accessed.

# tRakt 2015-02-11

As of today, all the functions are updated to use the new APIv2, except for `trakt.show.stats`,
which is currently not yet implemented at trakt.tv, see [their docs](http://docs.trakt.apiary.io/reference/shows/stats/get-show-stats)

Now the package is usable again, and I can continue to work on bug fixes and enhancements. Yay.

# tRakt 2015-02-10

I am now trying to migrate everything to the [new trakt.tv APIv2](http://docs.trakt.apiary.io/).
Since I mostly don't know what I'm doing, I have to make this up as I go along, but oh well.
Now the search function `trakt.search` should be working fine, as it is the only function
that is tested/built with the new API in mind. Others to come.
