# this app lets you choose a point in the x axis ("sliderMPG") and computes
# two linear models for the relationship between hp and mpg in the mtcars dataset

# it includes delayed reactivity with the submitButton and reactive functions in the server


library(shiny)

fluidPage(

    # Application title
    titlePanel("Robustness of Linear Regression"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            textInput("function_form", "R Function (argument x)", "x"),
            numericInput("n", "Number of Observations", 20),
            numericInput("min_x", "Minimum x", 0),
            numericInput("max_x", "Maximum x", 100),
            numericInput("intercept", "Intercept", 0),
            numericInput("slope", "Slope", 1),
            numericInput("error_var", "Variance", 5),
            # submitButton("Submit")
            actionButton("update", "Update")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("plot", click="click"),
            h4("Linear Model:"),
            textOutput("result"),
            h4("Slope p-value:"),
            textOutput("pval")
        )
    )
)
