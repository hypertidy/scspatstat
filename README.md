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
#> 1 33ed2959 larynx

data("nbfires", package= "spatstat")
sc_path(spatstat::as.owin(nbfires))
#> # A tibble: 6 × 2
#>   ncoords_    path_
#>      <int>    <chr>
#> 1      500 66ebf3ea
#> 2       92 d2340bba
#> 3       80 5a7b221b
#> 4       54 ec2c12c5
#> 5       66 d2d8b5f3
#> 6       79 f7025177

sc_coord(spatstat::as.owin(nbfires)) %>% summarize(n())
#> # A tibble: 1 × 1
#>   `n()`
#>   <int>
#> 1   871
```

With these three components working `sc_coord`, `sc_object` and `sc_path`, and using the framework in `sc`, the parent package can use these *in generic form*. We can already convert to `PATH` and then on to `PRIMITIVE` for these polygonal forms in `spatstat`.

``` r
library(sc)
sc::PATH(spatstat::as.owin(nbfires))
#> $object
#> # A tibble: 1 × 5
#>        type singular plural multiplier  object_
#>       <chr>    <chr>  <chr>      <dbl>    <chr>
#> 1 polygonal     unit  units          1 52e1c246
#> 
#> $path
#> # A tibble: 6 × 2
#>   ncoords_    path_
#>      <int>    <chr>
#> 1      500 118d3985
#> 2       92 94aade55
#> 3       80 900e80de
#> 4       54 f9d6ca5f
#> 5       66 0a756d95
#> 6       79 da2e4c6b
#> 
#> $vertex
#> # A tibble: 871 × 3
#>           x        y  vertex_
#>       <dbl>    <dbl>    <chr>
#> 1  415.2395 123.7442 5ad31232
#> 2  415.5546 122.7946 f78d01db
#> 3  419.1725 122.3231 b1339073
#> 4  423.8916 122.6374 3914810b
#> 5  429.8691 124.8375 fb65597a
#> 6  430.6556 133.0094 c22d5305
#> 7  435.8466 132.0665 d1fe859e
#> 8  436.1612 127.6663 e39a1c8e
#> 9  438.2062 126.8805 e9d47987
#> 10 445.7567 130.0235 0dba38c2
#> # ... with 861 more rows
#> 
#> $path_link_vertex
#> # A tibble: 871 × 2
#>       path_  vertex_
#>       <chr>    <chr>
#> 1  118d3985 5ad31232
#> 2  118d3985 f78d01db
#> 3  118d3985 b1339073
#> 4  118d3985 3914810b
#> 5  118d3985 fb65597a
#> 6  118d3985 c22d5305
#> 7  118d3985 d1fe859e
#> 8  118d3985 e39a1c8e
#> 9  118d3985 e9d47987
#> 10 118d3985 0dba38c2
#> # ... with 861 more rows
#> 
#> attr(,"class")
#> [1] "PATH" "sc"  
#> attr(,"join_ramp")
#> [1] "object"           "path"             "path_link_vertex"
#> [4] "vertex"
```

(Note that only owin is supported so far, we need a way to intermingle structured "windows" and the underly patterns. The patterns may be points and or lines. )

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
