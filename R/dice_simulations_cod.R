# simulations with cod dice

library(progress)

source(here::here("./src/cod_dice.R"))

run_simulation <- function(n_dice = 10, again = 10, times = 1000, pb = FALSE, ...) {
    if (pb) {
        # set up progress bar
        pb <- progress_bar$new(total = times,
                               format = " running [:bar] :percent eta: :eta",
                               clear = FALSE,
                               width = 60)
        pb$tick(0)
    }
    
    outs <- vector(mode = "integer", length = times)
    
    for (i in seq(from = 1, to = times)) {
        if (pb) pb$tick(1)
        outs[i] <- count_success(roll_n(n_dice, again))
    }
    
    return(outs)
}

run_multiple <- function(from = 2, to = 10, progress = TRUE, ...) {
    times = to - from + 1
    if (progress) {
        progressBar <- progress_bar$new(total = times,
                               format = " running [:bar] :percent eta: :eta",
                               clear = FALSE,
                               width = 60)
        progressBar$tick(0)
    }
    
    big_outs <- list()
    
    for (i in seq(from = from, to = to)) {
        big_outs[[i]] <- run_simulation(...)
        if (progress) progressBar$tick(1)
    }
    
    return(big_outs)
    
}
