
<!-- README.md is generated from README.Rmd. Please edit that file -->
tRakt
=====

[![Build Status](https://travis-ci.org/jemus42/tRakt.svg)](https://travis-ci.org/jemus42/tRakt) ![](http://www.r-pkg.org/badges/version/tRakt) ![](http://cranlogs.r-pkg.org/badges/grand-total/tRakt) [![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/0.1.0/active.svg)](http://www.repostatus.org/#active)

This is `tRakt` version `0.14.0`.
It contains functions to pull data from [trakt.tv](http://trakt.tv/).

It's an [R package](http://r-project.org) primarily used by (i.e. build for) [this webapp](http://trakt.jemu.name), but you can fiddle around with it if you like.
There might be some interesting things to play around with, and I've tried some of them [here](http://cran.r-project.org/web/packages/tRakt/vignettes/tRakt-Usage.html) (Also included as a package vignette).

Installation
============

Get the latest dev version from GitHub:

``` r
if (!("devtools" %in% installed.packages())){
  install.packages("devtools")
}

devtools::install_github("jemus42/tRakt")
```

Setting credentials
-------------------

The APIv2 requires at least a `client id` for the API calls.
Calling `get_trakt_credentials()` will set everything up for you, but you either have to manually plug your values in (see `?get_trakt_credentials()`), or have a `key.json` sitting either in the working directory or in `~/.config/trakt/key.json`.
It should look like this:

    {
      "username": "yourusername",
      "client.id": "<APIv2 client id>",
      "client.secret": "<APIv2 client secret>"
    }

-   `username` Optional. For functions that pull a user's watched shows or stats (`trakt.user.*`)
-   `client.id` Required. It's used in the HTTP headers for the API calls, which is kind of a biggie.
-   `client.secret` NYI. Is only required for `OAuth2` methods, and I don't really intend on using those unless I *really really* have to.

To get your credentials, [you have to have an (approved) app over at trakt.tv](http://trakt.tv/oauth/applications).
Don't worry, it's really easy to set up. Even I did it.

### Use my app's client.id as a fallback

As a convenience for you, and also to make automated testing a little easier, `get_trakt_credentials()` automatically sets my `client.id` as a fallback, so you theoretically never need to supply your own credentials. However, if you want to actually use this package for some project, I do not recommend relying on my credentials. That would make me a sad panda.
