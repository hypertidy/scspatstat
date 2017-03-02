<!-- README.md is generated from README.Rmd. Please edit that file -->
\[![Travis-CI Build Status](https://travis-ci.org/mdsumner/scspatstat.svg?branch=master)\](<https://travis-ci.org/mdsumner/scspatstat> [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/mdsumner/scspatstat?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/scspatstat) [![Coverage Status](https://img.shields.io/codecov/c/github/mdsumner/scspatstat/master.svg)](https://codecov.io/github/mdsumner/scspatstat?branch=master)

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
#> 1 a5aa7a25 larynx

data("nbfires", package= "spatstat")
sc_path(spatstat::as.owin(nbfires))
#> # A tibble: 6 × 2
#>   ncoords_    path_
#>      <int>    <chr>
#> 1      500 c3db7b61
#> 2       92 1ff61ceb
#> 3       80 30329d01
#> 4       54 4ce61fe1
#> 5       66 7e14a776
#> 6       79 e87e1794

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
#> 1 polygonal     unit  units          1 deb1addb
#> 
#> $path
#> # A tibble: 6 × 2
#>   ncoords_    path_
#>      <int>    <chr>
#> 1      500 7831ecaa
#> 2       92 f3978f59
#> 3       80 45386d83
#> 4       54 fe330216
#> 5       66 ffada0d8
#> 6       79 525e5e3b
#> 
#> $vertex
#> # A tibble: 871 × 3
#>           x        y  vertex_
#>       <dbl>    <dbl>    <chr>
#> 1  415.2395 123.7442 a9af7163
#> 2  415.5546 122.7946 9edbb397
#> 3  419.1725 122.3231 bc05829c
#> 4  423.8916 122.6374 40ebcf09
#> 5  429.8691 124.8375 8d078d53
#> 6  430.6556 133.0094 b540e46a
#> 7  435.8466 132.0665 62406e69
#> 8  436.1612 127.6663 bf981e74
#> 9  438.2062 126.8805 a47b820c
#> 10 445.7567 130.0235 c2f19a7c
#> # ... with 861 more rows
#> 
#> $path_link_vertex
#> # A tibble: 871 × 2
#>       path_  vertex_
#>       <chr>    <chr>
#> 1  7831ecaa a9af7163
#> 2  7831ecaa 9edbb397
#> 3  7831ecaa bc05829c
#> 4  7831ecaa 40ebcf09
#> 5  7831ecaa 8d078d53
#> 6  7831ecaa b540e46a
#> 7  7831ecaa 62406e69
#> 8  7831ecaa bf981e74
#> 9  7831ecaa a47b820c
#> 10 7831ecaa c2f19a7c
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
