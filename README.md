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
#> 1 95570613 larynx

data("nbfires", package= "spatstat")
sc_path(spatstat::as.owin(nbfires))
#> # A tibble: 6 × 2
#>   ncoords_    path_
#>      <int>    <chr>
#> 1      500 d744106a
#> 2       92 c8013427
#> 3       80 1b44ffd7
#> 4       54 d5419107
#> 5       66 d715d149
#> 6       79 2aa028b7

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
#>   ..$ object_   : chr "30824768"
#>  $ path            :Classes 'tbl_df', 'tbl' and 'data.frame':    6 obs. of  2 variables:
#>   ..$ ncoords_: int [1:6] 500 92 80 54 66 79
#>   ..$ path_   : chr [1:6] "31da0514" "58e0fde5" "ef4cd11e" "054b5ade" ...
#>  $ vertex          :Classes 'tbl_df', 'tbl' and 'data.frame':    871 obs. of  3 variables:
#>   ..$ x      : num [1:871] 415 416 419 424 430 ...
#>   ..$ y      : num [1:871] 124 123 122 123 125 ...
#>   ..$ vertex_: chr [1:871] "b62dc42c" "15e75bf5" "9ed6560f" "1a02128c" ...
#>  $ path_link_vertex:Classes 'tbl_df', 'tbl' and 'data.frame':    871 obs. of  2 variables:
#>   ..$ path_  : chr [1:871] "31da0514" "31da0514" "31da0514" "31da0514" ...
#>   ..$ vertex_: chr [1:871] "b62dc42c" "15e75bf5" "9ed6560f" "1a02128c" ...
#>  - attr(*, "class")= chr [1:2] "PATH" "sc"
#>  - attr(*, "join_ramp")= chr [1:4] "object" "path" "path_link_vertex" "vertex"

PRIMITIVE(nbfires_path)
#> $object
#> # A tibble: 1 × 5
#>        type singular plural multiplier  object_
#>       <chr>    <chr>  <chr>      <dbl>    <chr>
#> 1 polygonal     unit  units          1 30824768
#> 
#> $path
#> # A tibble: 6 × 2
#>   ncoords_    path_
#>      <int>    <chr>
#> 1      500 31da0514
#> 2       92 58e0fde5
#> 3       80 ef4cd11e
#> 4       54 054b5ade
#> 5       66 689e18b5
#> 6       79 6095e043
#> 
#> $vertex
#> # A tibble: 871 × 3
#>           x        y  vertex_
#>       <dbl>    <dbl>    <chr>
#> 1  415.2395 123.7442 b62dc42c
#> 2  415.5546 122.7946 15e75bf5
#> 3  419.1725 122.3231 9ed6560f
#> 4  423.8916 122.6374 1a02128c
#> 5  429.8691 124.8375 e9a2e307
#> 6  430.6556 133.0094 d990d7d7
#> 7  435.8466 132.0665 88c968bb
#> 8  436.1612 127.6663 df188553
#> 9  438.2062 126.8805 86f984b4
#> 10 445.7567 130.0235 8a1f95ea
#> # ... with 861 more rows
#> 
#> $path_link_vertex
#> # A tibble: 871 × 2
#>       path_  vertex_
#>       <chr>    <chr>
#> 1  31da0514 b62dc42c
#> 2  31da0514 15e75bf5
#> 3  31da0514 9ed6560f
#> 4  31da0514 1a02128c
#> 5  31da0514 e9a2e307
#> 6  31da0514 d990d7d7
#> 7  31da0514 88c968bb
#> 8  31da0514 df188553
#> 9  31da0514 86f984b4
#> 10 31da0514 8a1f95ea
#> # ... with 861 more rows
#> 
#> $segment
#> # A tibble: 865 × 4
#>    .vertex0 .vertex1    path_ segment_
#>       <chr>    <chr>    <chr>    <chr>
#> 1  2f63a6a3 ba32353d 054b5ade 1458ae10
#> 2  ba32353d cf0695f2 054b5ade e9967549
#> 3  cf0695f2 c2188593 054b5ade 018630fb
#> 4  c2188593 f667cd69 054b5ade 0118d555
#> 5  f667cd69 cd930a3a 054b5ade bdd68540
#> 6  cd930a3a a9587e2b 054b5ade 3560c45e
#> 7  a9587e2b 0403bc78 054b5ade db7f2411
#> 8  0403bc78 111277ad 054b5ade 8e83114a
#> 9  111277ad ee2d3905 054b5ade 12814bb9
#> 10 ee2d3905 b8251060 054b5ade 379d0c27
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
