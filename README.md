
<!-- README.md is generated from README.Rmd. Please edit that file -->

## minilocate

[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/coolbutuseless/minilocate?branch=master&svg=true)](https://ci.appveyor.com/project/coolbutuseless/minilocate)
[![Travis build
status](https://travis-ci.org/coolbutuseless/minilocate.svg?branch=master)](https://travis-ci.org/coolbutuseless/minilocate)
[![Coverage
status](https://codecov.io/gh/coolbutuseless/minilocate/branch/master/graph/badge.svg)](https://codecov.io/github/coolbutuseless/minilocate?branch=master)

The goal of minilocate is to provide a way to search for a vector within
another vector i.e. to find a needle in a haystack.

As far as I know, there’s no base function for finding one sequence
inside another sequence.

The core code was originally written by [Jonathan
Carroll](https://twitter.com/carroll_jono) in a response to [this
post](https://coolbutuseless.github.io/2018/04/03/finding-a-length-n-needle-in-a-haystack/).

I’ve adapted the code to suit my needs:

  - Support for the `bit` class from the `bit` package.
  - Support for aligned searches

## Installation

You can install minilocate from github with:

``` r
# install.packages("devtools")
devtools::install_github("coolbutuseless/minilocate")
```

## Examples

``` r
locate(c('m', 'n'), letters)
#> [1] 13
locate(c(0, 0, 1), sample(c(0, 1), 100, replace=TRUE))
#>  [1]  1 11 27 30 33 47 56 63 66 74 83 91 97
locate(c(T, F, F), c(T, F, F, T, F, T, F, F))
#> [1] 1 6
locate(as.raw(10:11), 1:100)
#> [1] 10
locate(c('5', '6'), 1:10)
#> [1] 5
locate(c(0, 1), c(0, 0, 1, 0, 0, 1), alignment = 2)
#> [1] 5
```
