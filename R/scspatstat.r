
#' @examples
#' irreg_data <- c("chorley", "clmfires", "demopat", "gordon", "gorillas", "humberside",
#' "murchison", "nbfires", "urkiola", "vesicles")
#' ## all are ppp, but murchison  "solist"  "anylist" "listof"  "list"
#' library(spatstat)
#' data(list = irreg_data, package = "spatstat")
#' for (i in seq_along(irreg_data)) {
#' x <- get(irreg_data[i])
#'  plot(x, main = irreg_data[i])
#'   title(sub = paste(class(x), collapse = " "))
#'    if (inherits(x, "solist")) {
#'    next;
#'    }
#'    print(sc_coord(as.owin(x)))
#'    print(sc_path(as.owin(x)))
#'    print(sc_object(as.owin(x)))
#' }
#' x <- as.owin(x)
#' sc_path(x)
#' @importFrom sc sc_path

sc_coord.owin <- function(x, ...) {
  switch(sc_spst_type(x),
         polygonal = dplyr::bind_rows(lapply(x[["bdry"]], function(bdry_ring) tibble::as_tibble(bdry_ring[c("x", "y")])))
  )
}

sc_path.owin <- function(x) {
  sc_list_owin(x)
}

## atom and list workers for spatstat
sc_spst_type <- function(x) x$type
sc_bdry_atom <- function(x, ...) tibble::tibble(ncoords_ = length(x$x), path = sc_rand())
sc_list_owin <- function(x, ...) {
  dplyr::bind_rows(lapply(x[["bdry"]], sc_bdry_atom))
}



