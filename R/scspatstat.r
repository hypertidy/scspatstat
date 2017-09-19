#' Coord
#'
#' sc coord
#' @inheritParams silicate::sc_coord
#' @examples
#' irreg_data <- c("chorley", "clmfires", "demopat", "gordon", "gorillas", "humberside",
#' "murchison", "nbfires", "urkiola", "vesicles")
#' ## all are ppp, but murchison  "solist"  "anylist" "listof"  "list"
#' library(spatstat)
#' data(list = irreg_data, package = "spatstat")
#' for (i in seq_along(irreg_data)) {
#' x <- get(irreg_data[i])
#'  #plot(x, main = irreg_data[i])
#'  # title(sub = paste(class(x), collapse = " "))
#'    if (inherits(x, "solist")) {
#'    next;
#'   }
#'    #print(sc_coord(as.owin(x)))
#'    #print(sc_path(as.owin(x)))
#'    #print(sc_object(as.owin(x)))
#'    print(sc_object(x))
#' }
#' x <- as.owin(x)
#' sc_path(x)
#' @importFrom silicate sc_coord sc_object sc_path
#' @importFrom tibble tibble as_tibble
#' @importFrom dplyr bind_cols bind_rows
#' @name sc_coord
#' @export
sc_coord.owin <- function(x, ...) {
  switch(sc_spst_type(x),
         polygonal = dplyr::bind_rows(lapply(x[["bdry"]], function(bdry_ring) tibble::as_tibble(bdry_ring[c("x", "y")])))
  )
}

#' Path
#'
#' sc path
#' @name sc_path
#' @export
#' @inheritParams sc::sc_coord
sc_path.owin <- function(x, ...) {
  ## note that the ... is being ignored here, in very early version first use
  ## of PATH sees
  #sc::PATH(as.owin(nbfires))
  #Error in sc_path.owin(x, ids = o[["object_"]]) :
  #  unused argument (ids = o[["object_"]])

  sc_list_owin(x)
}

#' Object
#'
#' sc object
#' @name sc_object
#' @export
#' @inheritParams silicate::sc_coord
sc_object.owin <- function(x, ...) {
  dplyr::bind_cols(tibble::tibble(type = sc_spst_type(x)),
                   tibble::as_tibble(unclass(x$units)))
}

#' @name sc_object
#' @export
sc_object.solist <- function(x, ...) {
  stop("sc_object not yet implemented for `solist`")
}
#' Object
#'
#' sc object for spatstat is the marks, which might be a vector, data.frame or NULL.
#' @name sc_object
#' @export
#' @importFrom dplyr mutate
#' @importFrom tibble tibble
#' @importFrom spatstat marks
#' @inheritParams silicate::sc_coord
#' @importFrom silicate sc_uid
sc_object.ppp <- function(x, ...) {
  mm <- spatstat::marks(x)
  mf <- x$markformat
  n <- x$n
  if (is.null(n)) stop(sprintf("not implemented sc_object(%s)", class(x)))
  tib <- tibble::tibble(object = silicate::sc_uid(n))
  switch(mf,
         vector = dplyr::mutate(tib, mark = mm),
         data.frame = dplyr::bind_cols(tib, tibble::as_tibble(mm)),
         none = tib

         )
}
## atom and list workers for spatstat
sc_spst_type <- function(x) x$type
sc_bdry_atom <- function(x, ...) tibble::tibble(ncoords_ = length(x$x), path = silicate::sc_uid())
sc_list_owin <- function(x, ...) {
  dplyr::bind_rows(lapply(x[["bdry"]], sc_bdry_atom))
}



