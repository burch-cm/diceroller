library(shiny)
library(shinydashboard)
library(ggplot2)
library(scales)
library(magrittr)
library(dplyr)
source("roll_recursive.R")

# UI
ui <- dashboardPage(
    ##### header #####
    dashboardHeader(title = "Dice Roller App"),
    ##### sidebar #####
    dashboardSidebar(
        numericInput("n_dice",
                     "Number of dice to roll:",
                     min = 1,
                     max = 30,
                     step = 1,
                     value = 1),
        numericInput("k_sides",
                     "Number of sides/faces per die:",
                     min = 1,
                     max = 100,
                     step = 1,
                     value = 10),
        checkboxInput("roll_again_check",
                      "Roll-again: reroll dice over a specific value?"),
        conditionalPanel(condition = "input.roll_again_check == true",
                         numericInput("roll_again_value",
                                      "Roll values at or above this score again:",
                                      min = 0,
                                      max = 100,
                                      value = 0,
                                      step = 1)),
        
        checkboxInput("rote_quality",
                      "Rote quality: re-roll failed dice once?"),
        actionButton("button_roll_dice",
                     "Roll!")
    ),
    ##### body #####
    dashboardBody(
        # row 1
        fluidRow(
            box(title = "Dice Results", 
                width = 6, 
                textOutput("dice_results")),
            valueBoxOutput("total_sum", width = 3),
            valueBoxOutput("total_successes", width = 3)
        ),
        
        # row 2
        fluidRow(
            box(width = 12,
                sliderInput("success_cutoff",
                            "Success Cutoff Value",
                            min = 0,
                            max = 1,
                            value = 0,
                            step = 1)
                )
        ),
        
        # row 3
        fluidRow(
            box(width = 12,
                title = "Distribution of Dice Results",
                plotOutput("outcome_dist"))
        )
    )
    
) # end UI

# server
server <- function(input, output, session) {
    
    # init dice values to NULL
    dice_data <- reactiveValues(dice = NULL)
    
    # roll dice on button click
    observeEvent(input$button_roll_dice, {
        if (input$roll_again_check) {
            dice_data$dice <- roll_n(sides = input$k_sides,
                                     n = input$n_dice,
                                     again = input$roll_again_value)
        } else {
            dice_data$dice <- roll_n(sides = input$k_sides, 
                                     n = input$n_dice)
        }
        if (input$rote_quality) {
            dice_data$dice <- rote(dice_data$dice)
        }
    })
    
    ##### update UI components #####
    observeEvent(input$k_sides, {
        updateSliderInput(inputId = "success_cutoff",
                          max = input$k_sides,
                          value = floor(input$k_sides * .8))
    })
    
    observeEvent(input$k_sides, {
        updateNumericInput(inputId = "roll_again_value",
                           max = input$k_sides)
    })
    
    ##### outputs #####
    # show all dice values rolled
    output$dice_results <- renderText({
        if (is.null(dice_data$dice)) return()
        rev(dice_data$dice)
    })
    
    # show count of successes based on success cutoff score
    output$total_sum <- renderValueBox({
        valueBox(sum(dice_data$dice), 
                 "Dice Sum",
                 icon = icon("dice", lib = "font-awesome"))
    })
    
    output$total_successes <- renderValueBox({
        valueBox(sum(dice_data$dice >= input$success_cutoff),
                 "Total Successes",
                 icon = icon("check", lib = "font-awesome"))
        
    })
    
    # show distribution of dice roll outcomes
    output$outcome_dist <- renderPlot({
        if (is.null(dice_data$dice)) return()
        df <- data.frame(dice = dice_data$dice) %>%
            group_by(dice) %>%
            count()
        ybreaks <- c(1:max(df$n))
        df %>%
            mutate(success_cat = if_else(dice >= input$success_cutoff, "success", "failure"),
                   dice = factor(dice)) %>% 
            ggplot(aes(x = dice, y = n)) + 
            geom_bar(stat = "identity", aes(fill = success_cat), col = "black") + 
            scale_fill_manual(values = c("success" = "lightblue", "failure" = "lightgrey")) +
            scale_x_discrete(limits = factor(c(1:input$k_sides))) +
            scale_y_continuous(breaks = ybreaks, limits = c(0, max(ybreaks))) +
            guides(fill = FALSE) +
            labs(x = "die face rolled", y = "count") +
            theme_bw()
    })
}

# run this mofo
shinyApp(ui = ui, server = server)
