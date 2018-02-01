
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
data("chorley", package = "spatstat.data")
sc_object(chorley) %>% slice(2L)
#> # A tibble: 1 x 2
#>   object_  mark  
#>   <chr>    <fct> 
#> 1 93b18381 larynx

data("nbfires", package= "spatstat.data")
sc_path(spatstat::as.owin(nbfires))
#> # A tibble: 6 x 4
#>   object_ type      ncoords_ path_   
#>   <chr>   <chr>        <int> <chr>   
#> 1 1       polygonal      500 e3fa5d01
#> 2 2       polygonal       54 750dce73
#> 3 3       polygonal       92 8473c6e7
#> 4 4       polygonal       79 d339ae80
#> 5 5       polygonal       66 619e2045
#> 6 6       polygonal       80 590ebdd7

print(sc_coord(spatstat::as.owin(nbfires)), n = 5)
#> # A tibble: 871 x 2
#>       x     y
#>   <dbl> <dbl>
#> 1   412   123
#> 2   415   124
#> 3   415   124
#> 4   416   123
#> 5   419   122
#> # ... with 866 more rows
```

With these three components working `sc_coord`, `sc_object` and `sc_path`, and using the framework in `sc`, the parent package can use these *in generic form*. We can already convert to `PATH` and then on to other models for these polygonal forms in `spatstat`.

``` r
library(scspatstat)
str(nbfires_path <- silicate::PATH(spatstat::as.owin(nbfires)))
#> List of 4
#>  $ object          :Classes 'tbl_df', 'tbl' and 'data.frame':    1 obs. of  5 variables:
#>   ..$ type      : chr "polygonal"
#>   ..$ singular  : chr "km"
#>   ..$ plural    : chr "km"
#>   ..$ multiplier: num 0.404
#>   ..$ object_   : chr "a03120f9"
#>  $ path            :Classes 'tbl_df', 'tbl' and 'data.frame':    6 obs. of  4 variables:
#>   ..$ object_ : chr [1:6] "1" "2" "3" "4" ...
#>   ..$ type    : chr [1:6] "polygonal" "polygonal" "polygonal" "polygonal" ...
#>   ..$ ncoords_: int [1:6] 500 54 92 79 66 80
#>   ..$ path_   : chr [1:6] "9029371a" "cc508bdf" "649fd705" "74cc44ea" ...
#>  $ path_link_vertex:Classes 'tbl_df', 'tbl' and 'data.frame':    871 obs. of  2 variables:
#>   ..$ path_  : chr [1:871] "9029371a" "9029371a" "9029371a" "9029371a" ...
#>   ..$ vertex_: chr [1:871] "803ce52e" "cbe70647" "e3e059ac" "dc1adfe2" ...
#>  $ vertex          :Classes 'tbl_df', 'tbl' and 'data.frame':    871 obs. of  3 variables:
#>   ..$ x      : num [1:871] 412 415 415 416 419 ...
#>   ..$ y      : num [1:871] 123 124 124 123 122 ...
#>   ..$ vertex_: chr [1:871] "803ce52e" "cbe70647" "e3e059ac" "dc1adfe2" ...
#>  - attr(*, "class")= chr [1:2] "PATH" "sc"
#>  - attr(*, "join_ramp")= chr [1:4] "object" "path" "path_link_vertex" "vertex"

SC(nbfires_path)
#> $object
#> # A tibble: 1 x 5
#>   type      singular plural multiplier object_ 
#>   <chr>     <chr>    <chr>       <dbl> <chr>   
#> 1 polygonal km       km          0.404 a03120f9
#> 
#> $object_link_edge
#> # A tibble: 865 x 2
#>    edge_    object_
#>    <chr>    <chr>  
#>  1 9af05d8c 1      
#>  2 a3aa5a4b 1      
#>  3 c717aff4 1      
#>  4 26827710 1      
#>  5 76f55d42 1      
#>  6 ce933960 1      
#>  7 74035c99 1      
#>  8 151cfa9f 1      
#>  9 5f23185d 1      
#> 10 dbafa8ae 1      
#> # ... with 855 more rows
#> 
#> $edge
#> # A tibble: 865 x 3
#>    .vertex0 .vertex1 edge_   
#>    <chr>    <chr>    <chr>   
#>  1 803ce52e cbe70647 9af05d8c
#>  2 cbe70647 e3e059ac a3aa5a4b
#>  3 e3e059ac dc1adfe2 c717aff4
#>  4 dc1adfe2 f0b92282 26827710
#>  5 f0b92282 916115bf 76f55d42
#>  6 916115bf 1e06a473 ce933960
#>  7 1e06a473 e3f8d802 74035c99
#>  8 e3f8d802 e7e9da37 151cfa9f
#>  9 e7e9da37 3dee1ea0 5f23185d
#> 10 3dee1ea0 c875483e dbafa8ae
#> # ... with 855 more rows
#> 
#> $vertex
#> # A tibble: 871 x 3
#>        x     y vertex_ 
#>    <dbl> <dbl> <chr>   
#>  1   412   123 803ce52e
#>  2   415   124 cbe70647
#>  3   415   124 e3e059ac
#>  4   416   123 dc1adfe2
#>  5   419   122 f0b92282
#>  6   424   123 916115bf
#>  7   430   125 1e06a473
#>  8   431   133 e3f8d802
#>  9   436   132 e7e9da37
#> 10   436   128 3dee1ea0
#> # ... with 861 more rows
#> 
#> attr(,"class")
#> [1] "SC" "sc"
```

(Note that `owin` is supported only on its own, and points `ppp` and line segments `psp` are supported separately. We need a way to intermingle structured "windows" and the underlying patterns, but for now I consider that a higher specialization than silicate itself.

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
