# ---- server ----

library(shiny)
library(ggplot2)
# Define server logic
function(input, output) {

    #### simulate data ####
    simulate <- reactive({
        input$update
        isolate({
            set.seed(seed = NULL)  # reinitialise seed
            set.seed(1234)
            # parsing function
            function_text <- paste0("function (x) {", input$function_form, "}")
            function_form <- eval(parse(text=function_text))
            x <- runif(input$n, input$min_x, input$max_x)
            u <- rnorm(input$n, 0, input$error_var)
            y <- input$intercept + input$slope * function_form(x) + u
            # flush source_coords
            source_coords$x <- NULL
            source_coords$y <- NULL
        })
        return(data.frame(x = x, y = y, Source = 'Original'))
    })

    ### data ###
    source_coords <- reactiveValues(x = NULL, y = NULL)

    ### saving clicks ###
    observe({
        input$click
        isolate({
            source_coords$x <- c(source_coords$x, input$click$x)
            source_coords$y <- c(source_coords$y, input$click$y)
        })
    })

    ### update dataframe with new clicks
    update_df <- reactive({
        df <- simulate()
        if (!is.null(source_coords$x)) {
            # transform source coords to df
            source_df <- data.frame(x = source_coords$x,
                                    y = source_coords$y,
                                    Source = 'Click')
            # binding with initial df
            df <- rbind(df, source_df)
        }
        return(df)
    })

    ### set up Plot
    setup_plot <- function(df) {
        ggplot(df, aes(x = x, y = y)) +
            geom_point(aes(color = Source)) +
            coord_cartesian(xlim = c(min(df$x) - 0.2 * max(df$x), 1.2 * max(df$x)),
                            ylim = c(min(df$y) - 0.2 * max(df$y), 1.2 * max(df$y))) +
            geom_smooth(method = "lm")
    }
    ### render Plot
    output$plot <- renderPlot({
        df <- update_df()
        setup_plot(df)
    })

    ### Get Data from regression
    output$result <- renderText({
        df <- update_df()
        model <- lm(df$y~df$x)
        intercept <- summary(model)$coefficients[, 1][1]
        slope <- summary(model)$coefficients[, 1][2]
        paste0("Intercept: ", intercept, "; Slope: ", slope)
    })

    output$pval <- renderText({
        df <- update_df()
        model <- lm(df$y~df$x)
        summary(model)$coefficients[, 4][2]
    })
}
