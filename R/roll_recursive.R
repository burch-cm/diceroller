library(purrr)

roll_recursive <- function(sides = 10, again = 10) {
    d <- sample(x = sides, size = 1)
    
    if (d < again) {
        return(d)
    } else {
        return(c(d, roll_recursive(sides, again)))
    }
}

roll_n <- function(sides = 10, n = 1, ...) {
    if (n > 1 & length(sides) == 1) {
        sides <- rep(sides, n)
    }
    res <- purrr::map(sides, roll_recursive)
    unlist(res)
}

count_successes <- function(x, success = 8) {
    sum(x >= success)
}

rote <- function(x, reroll_under = 8, append = TRUE, ...) {
    n_rerolls <- length(x[x < reroll_under])
    rerolls <- roll_n(n = n_rerolls, ...)
    append(x, rerolls)
}
