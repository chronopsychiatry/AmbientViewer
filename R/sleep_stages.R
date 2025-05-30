#' Plot Sleep Stages
#'
#' @param epochs The epochs dataframe
#' @param col_names A list to override default column names. This function uses columns:
#' - `night`
#' - `sleep_stage`
#' @returns A ggplot object showing the proportion of sleep stages for each night
#' @importFrom rlang .data
#' @export
#' @family plot epochs
#' @seealso [plot_hypnogram()] to show the detailed sleep stages over time
plot_sleep_stages <- function(epochs, col_names = NULL) {
  col <- get_epoch_colnames(epochs, col_names)

  sleep_stage_labels <- c(
    "1" = "Deep",
    "2" = "Light",
    "3" = "REM",
    "4" = "Awake",
    "5" = "No presence"
  )
  sleep_stage_colors <- c(  # Colors picked from the VT website
    "Awake" = "#B81722",
    "Light" = "#7DC9D0",
    "Deep" = "#485D78",
    "REM" = "#FAC54E",
    "No presence" = "#D2D2D2"
  )

  stage_proportions <- epochs |>
    dplyr::group_by(.data[[col$night]], .data[[col$sleep_stage]]) |>
    dplyr::summarise(count = dplyr::n(), .groups = "drop") |>
    dplyr::group_by(.data[[col$night]]) |>
    dplyr::mutate(proportion = .data$count / sum(.data$count),
      sleep_stage = factor(.data[[col$sleep_stage]], levels = names(sleep_stage_labels), labels = sleep_stage_labels)
    )

  ggplot2::ggplot(stage_proportions, ggplot2::aes(x = .data[[col$night]], y = .data$proportion, fill = factor(.data$sleep_stage))) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::scale_y_continuous(labels = scales::percent_format()) +
    ggplot2::scale_fill_manual(values = sleep_stage_colors) +
    ggplot2::labs(
      x = NULL,
      y = NULL,
      fill = "Sleep Stage",
      title = NULL
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 12),
      axis.text.y = ggplot2::element_text(size = 12),
      legend.text = ggplot2::element_text(size = 12),
      legend.title = ggplot2::element_text(size = 14),
      legend.position = "bottom"
    )
}
