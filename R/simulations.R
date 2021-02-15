library(tidyverse)

source(here::here("./dice_simulations_cod.R"))

set.seed(1776)
sim_10_10_01 <- run_simulation(n_dice = 10, again = 10, times = 10000, pb = TRUE)

s <- tibble(successes = sim_10_10_01)
s %>%
    ggplot(aes(x = successes)) +
    geom_bar(stat = "count") +
    scale_x_discrete(limits = seq(from = 0, to = max(sim_10_10_01)))

s %>%
    ggplot(aes(x = successes)) +
    geom_density(n = 10000, adjust = 4, fill = "lightblue", alpha = 0.3) +
    scale_x_continuous(breaks = seq(from = 0, to = max(sim_10_10_01)),
                       labels = seq(from = 0, to = max(sim_10_10_01)))



s2_10 <- run_multiple(from = 2, to = 10, times = 10000)


