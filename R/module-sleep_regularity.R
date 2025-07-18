sleep_regularity_module <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::HTML("Click on metrics names for more information.<br>"),
    shiny::tableOutput(ns("sleep_regularity_table")),
    shiny::HTML("Metrics based on <a href='https://doi.org/10.1093/sleep/zsab103' target='_blank'> Fischer et al. (2021)</a>.")
  )
}

sleep_regularity_server <- function(id, sessions, epochs, sessions_colnames, epochs_colnames) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    sessions_in <- sessions
    epochs_in <- epochs

    sessions <- shiny::reactive({
      shiny::req(sessions_in())
      sessions_in()[sessions_in()$display, ]
    })

    epochs <- shiny::reactive({
      shiny::req(epochs_in())
      epochs_in()[epochs_in()$display, ]
    })

    metric_names <- c(
      "Mid-sleep Standard Deviation",
      "Interdaily Stability",
      "Social Jet Lag",
      "Composite Phase Deviation",
      "Sleep Regularity Index",
      "Chronotype"
    )
    metric_ids <- c(
      "msd", "is", "sjl", "cpd", "sri", "chronotype"
    )

    metric_values <- shiny::reactive({
      c(
        sd_time(sessions()[[sessions_colnames()$time_at_midsleep]], unit = "hour"),
        interdaily_stability(epochs(), col_names = epochs_colnames()),
        social_jet_lag(sessions(), col_names = sessions_colnames()),
        composite_phase_deviation(sessions(), col_names = sessions_colnames()),
        sleep_regularity_index(epochs(), col_names = epochs_colnames()),
        chronotype(sessions(), col_names = sessions_colnames())
      )
    })

    output$sleep_regularity_table <- shiny::renderUI({
      shiny::tags$table(
        class = "table",
        style = "width: auto;",
        shiny::tags$thead(
          shiny::tags$tr(
            shiny::tags$th("Metric"),
            shiny::tags$th("Value")
          )
        ),
        shiny::tags$tbody(
          lapply(seq_along(metric_names), function(i) {
            shiny::tags$tr(
              shiny::tags$td(
                shiny::actionLink(ns(paste0("metric_", metric_ids[i])), metric_names[i])
              ),
              shiny::tags$td(
                round(metric_values()[i], 2)
              )
            )
          })
        )
      )
    })

    shiny::observeEvent(input$metric_msd, {
      show_metric_modal("Mid-sleep_Standard_Deviation")
    })
    shiny::observeEvent(input$metric_is, {
      show_metric_modal("Interdaily_Stability")
    })
    shiny::observeEvent(input$metric_sjl, {
      show_metric_modal("Social_Jet_Lag")
    })
    shiny::observeEvent(input$metric_cpd, {
      show_metric_modal("Composite_Phase_Deviation")
    })
    shiny::observeEvent(input$metric_sri, {
      show_metric_modal("Sleep_Regularity_Index")
    })
    shiny::observeEvent(input$metric_chronotype, {
      show_metric_modal("Chronotype")
    })

    show_metric_modal <- function(metric_name) {
      if (FALSE) markdown::markdownToHTML() # Added to avoid R CMD check warning about unused function
      shiny::showModal(
        shiny::modalDialog(
          title = gsub("_", " ", metric_name),
          size = "l",
          shiny::includeMarkdown(system.file(paste0("resources/", metric_name, ".md"), package = "AmbientViewer")),
          easyClose = TRUE,
          footer = shiny::modalButton("Close")
        )
      )
    }
  })
}
