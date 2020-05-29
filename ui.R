# this app lets you choose a point in the x axis ("sliderMPG") and computes
# two linear models for the relationship between hp and mpg in the mtcars dataset

# it includes delayed reactivity with the submitButton and reactive functions in the server


library(shiny)

shinyUI(fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("sliderMPG",
                        "What is the MPG of the car?",
                        min = 10,
                        max = 35,
                        value = 20),
            checkboxInput("showModel1", "Show/Hide Model 1", value = T),
            checkboxInput("showModel2", "Show/Hide Model 2", value = T),
            # introducing delayed Reactivity with submitButton
            submitButton("Submit!")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("plot1"),
            h3("Predicted Horsepower from Model 1:"),
            textOutput("pred1"),
            h3("Predicted Horsepower from Model 2:"),
            textOutput("pred2")
        )
    )
))
