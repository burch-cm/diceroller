
roll_die <- function(sides = 6, n = 1, ...) {
    # rolling a die is equivalent to drawing a sample
    # if the die is fair, the dist is uniform
    sample(seq(sides), size = n, replace = TRUE)
}


roll_recursive <- function(sides = 10, again = 10) {
    d <- sample(x = sides, size = 1)
    
    if (d < again) {
        return(d)
    } else {
        return(c(d, roll_recursive(sides, again)))
    }
}

roll_recursive(10, 10)
