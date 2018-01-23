
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
#> 1 c8761c28 larynx

data("nbfires", package= "spatstat.data")
sc_path(spatstat::as.owin(nbfires))
#> # A tibble: 6 x 4
#>   object_ type      ncoords_ path_   
#>   <chr>   <chr>        <int> <chr>   
#> 1 1       polygonal      500 293d7515
#> 2 2       polygonal       54 a78cfbf7
#> 3 3       polygonal       92 a9d65a78
#> 4 4       polygonal       79 eb42a1e2
#> 5 5       polygonal       66 4c62667c
#> 6 6       polygonal       80 85e68ff2

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
#>   ..$ object_   : chr "44582f20"
#>  $ path            :Classes 'tbl_df', 'tbl' and 'data.frame':    6 obs. of  4 variables:
#>   ..$ object_ : chr [1:6] "1" "2" "3" "4" ...
#>   ..$ type    : chr [1:6] "polygonal" "polygonal" "polygonal" "polygonal" ...
#>   ..$ ncoords_: int [1:6] 500 54 92 79 66 80
#>   ..$ path_   : chr [1:6] "0967809c" "c68cee2d" "d78b2864" "854f8601" ...
#>  $ path_link_vertex:Classes 'tbl_df', 'tbl' and 'data.frame':    871 obs. of  2 variables:
#>   ..$ path_  : chr [1:871] "0967809c" "0967809c" "0967809c" "0967809c" ...
#>   ..$ vertex_: chr [1:871] "22609df3" "8b89b657" "3fce0e96" "795a57bc" ...
#>  $ vertex          :Classes 'tbl_df', 'tbl' and 'data.frame':    871 obs. of  3 variables:
#>   ..$ x      : num [1:871] 412 415 415 416 419 ...
#>   ..$ y      : num [1:871] 123 124 124 123 122 ...
#>   ..$ vertex_: chr [1:871] "22609df3" "8b89b657" "3fce0e96" "795a57bc" ...
#>  - attr(*, "class")= chr [1:2] "PATH" "sc"
#>  - attr(*, "join_ramp")= chr [1:4] "object" "path" "path_link_vertex" "vertex"

SC(nbfires_path)
#> $object
#> # A tibble: 1 x 5
#>   type      singular plural multiplier object_ 
#>   <chr>     <chr>    <chr>       <dbl> <chr>   
#> 1 polygonal km       km          0.404 44582f20
#> 
#> $object_link_edge
#> # A tibble: 865 x 2
#>    edge_    object_
#>    <chr>    <chr>  
#>  1 0c064171 1      
#>  2 42196a73 1      
#>  3 cc8b2cc6 1      
#>  4 8540d02b 1      
#>  5 a5969bd7 1      
#>  6 e471f1b6 1      
#>  7 8df7dfcd 1      
#>  8 669a076e 1      
#>  9 94cc0ffc 1      
#> 10 9842c4a9 1      
#> # ... with 855 more rows
#> 
#> $edge
#> # A tibble: 865 x 3
#>    .vertex0 .vertex1 edge_   
#>    <chr>    <chr>    <chr>   
#>  1 22609df3 8b89b657 0c064171
#>  2 8b89b657 3fce0e96 42196a73
#>  3 3fce0e96 795a57bc cc8b2cc6
#>  4 795a57bc 720d2a60 8540d02b
#>  5 720d2a60 70bf02a2 a5969bd7
#>  6 70bf02a2 8ece6cb3 e471f1b6
#>  7 8ece6cb3 9551e64c 8df7dfcd
#>  8 9551e64c a9f6ee60 669a076e
#>  9 a9f6ee60 6ea09904 94cc0ffc
#> 10 6ea09904 cac53ca7 9842c4a9
#> # ... with 855 more rows
#> 
#> $vertex
#> # A tibble: 871 x 3
#>        x     y vertex_ 
#>    <dbl> <dbl> <chr>   
#>  1   412   123 22609df3
#>  2   415   124 8b89b657
#>  3   415   124 3fce0e96
#>  4   416   123 795a57bc
#>  5   419   122 720d2a60
#>  6   424   123 70bf02a2
#>  7   430   125 8ece6cb3
#>  8   431   133 9551e64c
#>  9   436   132 a9f6ee60
#> 10   436   128 6ea09904
#> # ... with 861 more rows
#> 
#> attr(,"class")
#> [1] "SC" "sc"
```

(Note that `owin` is supported only on its own, and points `ppp` and line segments `psp` are supported separately. We need a way to intermingle structured "windows" and the underlying patterns, but for now I consider that a higher specialization that silicate itself.

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
