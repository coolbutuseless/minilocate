context("locate")


test_that("locate works", {
  expect_equal(locate(c('m', 'n'), letters), 13)
  expect_equal(locate(c('a', 'b'), letters), 1)
  expect_equal(locate(c('y', 'z'), letters), 25)
  expect_equal(locate(c('y'     ), letters), 25)
  expect_equal(locate(c(     'z'), letters), 26)
  expect_true(is.na(locate(c('UGH'   ), letters)))
  expect_true(is.na(locate(c('Z'     ), letters)))


  expect_equal(4, locate(as.integer  (4:5), as.integer  (1:10)))
  expect_equal(4, locate(as.character(4:5), as.character(1:10)))
  expect_equal(4, locate(as.numeric  (4:5), as.numeric  (1:10)))
  expect_equal(4, locate(as.complex  (4:5), as.complex  (1:10)))
  expect_equal(4, locate(as.raw      (4:5), as.raw      (1:10)))


  expect_equal(4, locate(as.integer  (4:5), as.character(1:10)))
  expect_equal(4, locate(as.character(4:5), as.integer  (1:10)))
  expect_equal(4, locate(as.integer  (4:5), as.numeric  (1:10)))
  expect_equal(4, locate(as.numeric  (4:5), as.integer  (1:10)))

})



test_that("locate works at beginning/end of haystack", {
  expect_equal(1, locate(1:4, 1:10))
  expect_equal(7, locate(7:10, 1:10))
})

test_that("locate with alignment works", {
  # Y       Y       Y      alignment=4 locations
  # 1 2 3 4 5 6 7 8 9 10   haystack
  # 1 2 3 4                needle aligned
  #         5 6 7          needle aligned
  #   2 3                  needle not aligned
  #                 9 10   needle aligned
  expect_equal(1          , locate( 1:4, 1:10, alignment=4))
  expect_equal(5          , locate( 5:7, 1:10, alignment=4))
  expect_equal(NA_integer_, locate( 2:3, 1:10, alignment=4))
  expect_equal(9          , locate(9:10, 1:10, alignment=4))
})



test_that("NA if needle longer than haystack", {
  expect_identical(locate(1:10, 1:3), NA_integer_)
})



test_that("'bit' searches initialised correctly", {
  needle   <- bit::as.bit(c(TRUE, FALSE))
  haystack <- bit::as.bit(c(FALSE, TRUE, FALSE))
  res <- locate(needle, haystack)
  expect_identical(res, 2L)
})



test_that("locate_next works", {

  haystack <- c(T, T, F, T, F, F, T, T, F, T, T)
  needle   <- c(TRUE, FALSE, TRUE)

  expect_identical(locate_next(needle, haystack, start = 1), 2L)
  expect_identical(locate_next(needle, haystack, start = 3), 8L)
  expect_identical(locate_next(needle, haystack, start = 9), NA_integer_)

})



