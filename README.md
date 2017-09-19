
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/hypertidy/scspatstat.svg?branch=master)](https://travis-ci.org/hypertidy/scspatstat) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/hypertidy/scspatstat?branch=master&svg=true)](https://ci.appveyor.com/project/hypertidy/scspatstat) [![Coverage Status](https://img.shields.io/codecov/c/github/hypertidy/scspatstat/master.svg)](https://codecov.io/github/hypertidy/scspatstat?branch=master)

scspatstat
==========

The goal of `scspatstat` is to convert `spatstat` data structures to a generic common form that that can be used for conversion a wide variety of data structures.

This is work in progress and at a very early stage. More to come.

Example
-------

This is a basic example showing the component decomposition of a spatstat point pattern.

``` r
library(scspatstat)
#> Loading required package: silicate
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
#> # A tibble: 1 x 2
#>     object   mark
#>      <chr> <fctr>
#> 1 850967e8 larynx

data("nbfires", package= "spatstat")
sc_path(spatstat::as.owin(nbfires))
#> # A tibble: 6 x 2
#>   ncoords_     path
#>      <int>    <chr>
#> 1      500 6d5aeb48
#> 2       54 d4a347ab
#> 3       92 bc954f25
#> 4       79 014fb261
#> 5       66 cc7246b3
#> 6       80 302fbbe0

print(sc_coord(spatstat::as.owin(nbfires)), n = 5)
#> # A tibble: 871 x 2
#>          x        y
#>      <dbl>    <dbl>
#> 1 411.6245 122.5687
#> 2 415.3799 123.7937
#> 3 415.2395 123.7442
#> 4 415.5546 122.7946
#> 5 419.1725 122.3231
#> # ... with 866 more rows
```

With these three components working `sc_coord`, `sc_object` and `sc_path`, and using the framework in `sc`, the parent package can use these *in generic form*. We can already convert to `PATH` and then on to `PRIMITIVE` for these polygonal forms in `spatstat`.

``` r
library(scspatstat)
str(nbfires_path <- silicate::PATH(spatstat::as.owin(nbfires)))
#> List of 4
#>  $ object          :Classes 'tbl_df', 'tbl' and 'data.frame':    1 obs. of  5 variables:
#>   ..$ type      : chr "polygonal"
#>   ..$ singular  : chr "km"
#>   ..$ plural    : chr "km"
#>   ..$ multiplier: num 0.404
#>   ..$ object    : chr "113218fe"
#>  $ path            :Classes 'tbl_df', 'tbl' and 'data.frame':    6 obs. of  2 variables:
#>   ..$ ncoords_: int [1:6] 500 54 92 79 66 80
#>   ..$ path    : chr [1:6] "928744f7" "5246c1ca" "6ed02ab8" "36a6a050" ...
#>  $ vertex          :Classes 'tbl_df', 'tbl' and 'data.frame':    871 obs. of  3 variables:
#>   ..$ x      : num [1:871] 412 415 415 416 419 ...
#>   ..$ y      : num [1:871] 123 124 124 123 122 ...
#>   ..$ vertex_: chr [1:871] "80da2a90" "4af905d5" "073a3592" "2e7a3ff3" ...
#>  $ path_link_vertex:Classes 'tbl_df', 'tbl' and 'data.frame':    871 obs. of  2 variables:
#>   ..$ path   : chr [1:871] "928744f7" "928744f7" "928744f7" "928744f7" ...
#>   ..$ vertex_: chr [1:871] "80da2a90" "4af905d5" "073a3592" "2e7a3ff3" ...
#>  - attr(*, "class")= chr [1:2] "PATH" "sc"
#>  - attr(*, "join_ramp")= chr [1:4] "object" "path" "path_link_vertex" "vertex"

PRIMITIVE(nbfires_path)
#> $object
#> # A tibble: 1 x 5
#>        type singular plural multiplier   object
#>       <chr>    <chr>  <chr>      <dbl>    <chr>
#> 1 polygonal       km     km   0.403716 113218fe
#> 
#> $path
#> # A tibble: 6 x 2
#>   ncoords_     path
#>      <int>    <chr>
#> 1      500 928744f7
#> 2       54 5246c1ca
#> 3       92 6ed02ab8
#> 4       79 36a6a050
#> 5       66 0acda5b9
#> 6       80 4e42ee2e
#> 
#> $vertex
#> # A tibble: 871 x 3
#>           x        y  vertex_
#>       <dbl>    <dbl>    <chr>
#>  1 411.6245 122.5687 80da2a90
#>  2 415.3799 123.7937 4af905d5
#>  3 415.2395 123.7442 073a3592
#>  4 415.5546 122.7946 2e7a3ff3
#>  5 419.1725 122.3231 0083f33b
#>  6 423.8916 122.6374 dc5ef813
#>  7 429.8691 124.8375 30fd0615
#>  8 430.6556 133.0094 5f94e0ff
#>  9 435.8466 132.0665 e970f786
#> 10 436.1612 127.6663 e84524d1
#> # ... with 861 more rows
#> 
#> $path_link_vertex
#> # A tibble: 871 x 2
#>        path  vertex_
#>       <chr>    <chr>
#>  1 928744f7 80da2a90
#>  2 928744f7 4af905d5
#>  3 928744f7 073a3592
#>  4 928744f7 2e7a3ff3
#>  5 928744f7 0083f33b
#>  6 928744f7 dc5ef813
#>  7 928744f7 30fd0615
#>  8 928744f7 5f94e0ff
#>  9 928744f7 e970f786
#> 10 928744f7 e84524d1
#> # ... with 861 more rows
#> 
#> $segment
#> # A tibble: 865 x 4
#>    .vertex0 .vertex1     path segment_
#>       <chr>    <chr>    <chr>    <chr>
#>  1 c0f37c6b 9456a314 0acda5b9 3f5906af
#>  2 9456a314 5e24d5eb 0acda5b9 b7bac35c
#>  3 5e24d5eb 359e541a 0acda5b9 61db5b62
#>  4 359e541a 8f1be03d 0acda5b9 c70f4069
#>  5 8f1be03d 13ba8b46 0acda5b9 fe836cbd
#>  6 13ba8b46 a88543ad 0acda5b9 76f27084
#>  7 a88543ad 100e764b 0acda5b9 8c1cc85f
#>  8 100e764b 1161f71b 0acda5b9 2ede26fa
#>  9 1161f71b fb9a7f98 0acda5b9 5ead5264
#> 10 fb9a7f98 482d3184 0acda5b9 1b774341
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
