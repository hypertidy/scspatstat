<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/mdsumner/scspatstat.svg?branch=master)](https://travis-ci.org/mdsumner/scspatstat) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/mdsumner/scspatstat?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/scspatstat) [![Coverage Status](https://img.shields.io/codecov/c/github/mdsumner/scspatstat/master.svg)](https://codecov.io/github/mdsumner/scspatstat?branch=master)

scspatstat
==========

The goal of `scspatstat` is to convert `spatstat` data structures to a generic common form that that can be used for conversion a wide variety of data structures.

This is work in progress and at a very early stage. More to come.

Example
-------

This is a basic example showing the component decomposition of a spatstat point pattern.

``` r
library(scspatstat)
#> Loading required package: sc
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
data("chorley", package = "spatstat")
sc_object(chorley) %>% slice(2L)
#> # A tibble: 1 × 2
#>    object_   mark
#>      <chr> <fctr>
#> 1 93e831e6 larynx

data("nbfires", package= "spatstat")
sc_path(spatstat::as.owin(nbfires))
#> # A tibble: 6 × 2
#>   ncoords_    path_
#>      <int>    <chr>
#> 1      500 f11ade8e
#> 2       92 a9fbc5c7
#> 3       80 c58f7e1b
#> 4       54 04434ee3
#> 5       66 52260cc4
#> 6       79 313bf035

print(sc_coord(spatstat::as.owin(nbfires)), n = 5)
#> # A tibble: 871 × 2
#>          x        y
#>      <dbl>    <dbl>
#> 1 415.2395 123.7442
#> 2 415.5546 122.7946
#> 3 419.1725 122.3231
#> 4 423.8916 122.6374
#> 5 429.8691 124.8375
#> # ... with 866 more rows
```

With these three components working `sc_coord`, `sc_object` and `sc_path`, and using the framework in `sc`, the parent package can use these *in generic form*. We can already convert to `PATH` and then on to `PRIMITIVE` for these polygonal forms in `spatstat`.

``` r
library(sc)
str(nbfires_path <- sc::PATH(spatstat::as.owin(nbfires)))
#> List of 4
#>  $ object          :Classes 'tbl_df', 'tbl' and 'data.frame':    1 obs. of  5 variables:
#>   ..$ type      : chr "polygonal"
#>   ..$ singular  : chr "unit"
#>   ..$ plural    : chr "units"
#>   ..$ multiplier: num 1
#>   ..$ object_   : chr "b24f3831"
#>  $ path            :Classes 'tbl_df', 'tbl' and 'data.frame':    6 obs. of  2 variables:
#>   ..$ ncoords_: int [1:6] 500 92 80 54 66 79
#>   ..$ path_   : chr [1:6] "5599aa70" "61c416e4" "685ab943" "3bd3459e" ...
#>  $ vertex          :Classes 'tbl_df', 'tbl' and 'data.frame':    871 obs. of  3 variables:
#>   ..$ x      : num [1:871] 415 416 419 424 430 ...
#>   ..$ y      : num [1:871] 124 123 122 123 125 ...
#>   ..$ vertex_: chr [1:871] "1820d2e4" "d0009468" "d7034c5b" "1da209dc" ...
#>  $ path_link_vertex:Classes 'tbl_df', 'tbl' and 'data.frame':    871 obs. of  2 variables:
#>   ..$ path_  : chr [1:871] "5599aa70" "5599aa70" "5599aa70" "5599aa70" ...
#>   ..$ vertex_: chr [1:871] "1820d2e4" "d0009468" "d7034c5b" "1da209dc" ...
#>  - attr(*, "class")= chr [1:2] "PATH" "sc"
#>  - attr(*, "join_ramp")= chr [1:4] "object" "path" "path_link_vertex" "vertex"

PRIMITIVE(nbfires_path)
#> $object
#> # A tibble: 1 × 5
#>        type singular plural multiplier  object_
#>       <chr>    <chr>  <chr>      <dbl>    <chr>
#> 1 polygonal     unit  units          1 b24f3831
#> 
#> $path
#> # A tibble: 6 × 2
#>   ncoords_    path_
#>      <int>    <chr>
#> 1      500 5599aa70
#> 2       92 61c416e4
#> 3       80 685ab943
#> 4       54 3bd3459e
#> 5       66 1341cbc4
#> 6       79 03afac82
#> 
#> $vertex
#> # A tibble: 871 × 3
#>           x        y  vertex_
#>       <dbl>    <dbl>    <chr>
#> 1  415.2395 123.7442 1820d2e4
#> 2  415.5546 122.7946 d0009468
#> 3  419.1725 122.3231 d7034c5b
#> 4  423.8916 122.6374 1da209dc
#> 5  429.8691 124.8375 f9e7c883
#> 6  430.6556 133.0094 18d8926e
#> 7  435.8466 132.0665 d511fc2e
#> 8  436.1612 127.6663 3341588f
#> 9  438.2062 126.8805 653b9e99
#> 10 445.7567 130.0235 654ac680
#> # ... with 861 more rows
#> 
#> $path_link_vertex
#> # A tibble: 871 × 2
#>       path_  vertex_
#>       <chr>    <chr>
#> 1  5599aa70 1820d2e4
#> 2  5599aa70 d0009468
#> 3  5599aa70 d7034c5b
#> 4  5599aa70 1da209dc
#> 5  5599aa70 f9e7c883
#> 6  5599aa70 18d8926e
#> 7  5599aa70 d511fc2e
#> 8  5599aa70 3341588f
#> 9  5599aa70 653b9e99
#> 10 5599aa70 654ac680
#> # ... with 861 more rows
#> 
#> $segment
#> # A tibble: 865 × 4
#>    .vertex0 .vertex1    path_ segment_
#>       <chr>    <chr>    <chr>    <chr>
#> 1  52473e5b ec79904a 03afac82 d7f5d60e
#> 2  ec79904a 74c509ac 03afac82 b6c9d4b4
#> 3  74c509ac 49f9efff 03afac82 0e375463
#> 4  49f9efff e010ca4e 03afac82 5cb7c357
#> 5  e010ca4e e44c5d73 03afac82 74f35445
#> 6  e44c5d73 7a9eb055 03afac82 7bf2f23a
#> 7  7a9eb055 84c9fb30 03afac82 72ba9a56
#> 8  84c9fb30 ec5a5874 03afac82 d442dbab
#> 9  ec5a5874 7e051889 03afac82 f227baec
#> 10 7e051889 81223305 03afac82 ceaa65ea
#> # ... with 855 more rows
#> 
#> attr(,"class")
#> [1] "PRIMITIVE" "PATH"      "sc"       
#> attr(,"join_ramp")
#> [1] "object"           "path"             "path_link_vertex"
#> [4] "vertex"
```

(Note that only owin is supported so far, we need a way to intermingle structured "windows" and the underly patterns. The patterns may be points and or lines. )

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
