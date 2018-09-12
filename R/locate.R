



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Locate all occurrences of a vector (needle) within another vector of values (haystack)
#'
#' This will return all starting locations of the needle found within the haystack -
#' even overlapping ones.
#'
#' The routine is pretty relaxed about types so you can search for an integer vector
#' within a character vector if you so choose.
#'
#' Supported types:
#' \itemize{
#'   \item{all built-in atomic types in R i.e. integer, numeric, real, character,
#'         complex, raw}{}
#'   \item{\code{bit} type from the \code{bit} package}{ - Note: in order to
#'         search for the matches, 'bit' objects are basically extracted to
#'         their equivalent logical vector causing higher memory usage
#'         and negating any memory savings of using 'bit'.}
#' }
#'
#' \code{locate} is the core location function. There is no cacheing, so identical searches
#' are started from scratch each time.
#'
#' \code{cached_locate} is a memoised version of \code{locate}. Because calling
#' \code{locate} can be quite an expensive operation, searches for a given
#' sequence in a haystack are cached to save time on subsequent calls.
#'
#' \code{locate_next} gives the first index on, or after, the given \code{start} index.
#'
#' Adapted from code originally written by carroll_jono - https://twitter.com/carroll_jono
#'
#' @param needle vector of values
#' @param haystack vector of values
#' @param start lowest index to accept
#' @param alignment search must start at a multiple of this index location (+1). Useful for
#'        byte-aligned searches of bit vectors i.e. \code{alignment=8}. Default: NA (no alignment).
#'
#' @return Indices of the start of all occurrences of needle in haystack, or NA if no matches found.
#'
#' @importFrom memoise memoise
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
locate <- function(needle, haystack, alignment=NA_integer_) {

  stopifnot(length(needle)   > 0)
  stopifnot(length(haystack) > 0)

  if (length(needle) > length(haystack)) { return(NA_integer_) }

  if (!is.na(alignment)) {
    alignment <- as.integer(alignment)
    stopifnot(alignment > 0L)
    locations <- seq(1L, length(haystack) - length(needle) + 1, alignment)
    locations <- locations[haystack[locations] == needle[1L]]
  } else if (inherits(needle, 'bit') || inherits(haystack, 'bit')) {
    locations <- which(as.logical(haystack) == needle[1L])
  } else {
    locations <- which(haystack == needle[1L])
  }

  if (length(needle) > 1L) {
    for (i in seq.int(1L, length(needle) - 1L)) {
      locations <- locations[haystack[locations + i] == needle[i + 1L]]
    }
  }

  locations <- locations[!is.na(locations)]

  if (length(locations) == 0L) {
    NA_integer_
  } else {
    locations
  }
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname locate
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cached_locate <- memoise::memoise(locate)



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname locate
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
locate_next <- function(needle, haystack, start=1L, alignment=NA) {

  locations <- cached_locate(needle, haystack, alignment)
  locations <- locations[locations >= start]

  if (length(locations) == 0L) {
    NA_integer_
  } else {
    locations[1L]
  }
}



























