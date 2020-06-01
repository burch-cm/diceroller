# Storytelling system from the Chronicles of Darkness role-playing games
count_success <- function(x) {
    sum(x >= 8)
}

roll_again <- function(again = 10) {
    x <- sample(1:10, 1)
    out <- x
    while(x >= again) {
        x <- sample(1:10, 1)
        out <- append(out, x)
    }
    return(out)
}

roll_d10 <- function(again = NA, rote = FALSE) {
    x <- sample(1:10, 1)
    if (rote & x <= 7) {
        x <- sample(1:10, 1)
    }
    if (!is.na(again)) {
        if (x >= again) {
            x <- append(x, roll_again(again))
        }
    }
    return(x)
}

roll_n <- function(n = 1, ...) {
    x <- vector(mode = "integer")
    for (i in seq(n)) {
        dice <- roll_d10(...)
        x <- append(x, dice)
    }
    return(x)
}
