context("test-spatstat.R")
library(spatstat)
# polygon with hole
ho <- owin(poly=list(list(x=c(0,1,1,0), y=c(0,0,1,1)),
                     list(x=c(0.6,0.4,0.4,0.6), y=c(0.2,0.2,0.4,0.4))))

Xln <- psp(runif(10), runif(10), runif(10), runif(10), window=owin())
# some arbitrary coordinates in [0,1]
x <- runif(20)
y <- runif(20)

# the following are equivalent
Xpt <- ppp(x, y, c(0,1), c(0,1))

test_that("PATH interpretation works", {
  PATH(ho) %>% expect_s3_class("PATH")
})

skip("skipping worker tests for now")
test_that("worker verbs work for owin", {
  sc_object(ho)
  sc_path(ho)
  sc_arc(ho)
  sc_coord(ho)
  sc_vertex(ho)
  sc_node(ho)
  sc_edge(ho)
  sc_segment(ho)
})
test_that("worker verbs work for ppp", {
  sc_object(Xpt)
  sc_path(Xpt)
  sc_arc(Xpt)
  sc_coord(Xpt)
  sc_vertex(Xpt)
  sc_node(Xpt)
  sc_edge(Xpt)
  sc_segment(Xpt)
})
test_that("worker verbs work for psp", {
  sc_object(Xln)
  sc_path(Xln)
  sc_arc(Xln)
  sc_coord(Xln)
  sc_vertex(Xln)
  sc_node(Xln)
  sc_edge(Xln)
  sc_segment(Xln)
})

