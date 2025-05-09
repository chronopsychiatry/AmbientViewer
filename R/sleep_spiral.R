#' Plot Sleep Spiral
#'
#' @param epochs The epochs dataframe
#' @returns A ggplot object showing the sleep spiral
#' @importFrom rlang .data
#' @export
#' @family plot epochs
plot_sleep_spiral <- function(epochs) {
  sleep_stage_colors <- c(
    "1" = "#6A3A9A", # Deep sleep (dark purple)
    "2" = "#D3B9E6", # Light sleep (light purple)
    "3" = "#A074C4", # REM sleep (medium purple)
    "4" = "orange"  # Awake
  )

  reference_time <- epochs$timestamp |>
    parse_time() |>
    min() |>
    lubridate::floor_date(unit = "day")

  epochs <- epochs |>
    dplyr::mutate(
      timestamp = parse_time(.data$timestamp),
      sleep_stage = as.character(.data$sleep_stage),  # Convert sleep_stage to character for mapping
      sleep_stage = dplyr::if_else(.data$sleep_stage == "5", "4", .data$sleep_stage)  # Consider "no presence" as "awake"
    ) |>
    tidyr::complete(
      timestamp = seq(min(.data$timestamp), max(.data$timestamp), by = "1 min"),  # Fill gaps with 5-minute intervals
      fill = list(sleep_stage = "4")  # Mark missing data as "awake"
    ) |>
    dplyr::mutate(
      time_in_days = as.numeric(difftime(.data$timestamp, reference_time, units = "days")),
      time_in_min = as.numeric(difftime(.data$timestamp, reference_time, units = "mins")),
      angle = (.data$time_in_days %% 1) * 2 * pi,
      radius = .data$time_in_min
    )

  ggplot2::ggplot(epochs, ggplot2::aes(x = .data$angle, y = .data$radius, color = .data$sleep_stage)) +
    ggplot2::geom_point(size = 1, shape = 16) +
    ggplot2::scale_color_manual(values = sleep_stage_colors,
      labels = c(
        "1" = "Deep Sleep",
        "2" = "Light Sleep",
        "3" = "REM Sleep",
        "4" = "Awake"
      )
    ) +
    ggplot2::coord_polar(theta = "x") +
    ggplot2::scale_x_continuous(
      breaks = seq(0, 2 * pi, length.out = 25)[-25],  # Hourly labels (0 to 24)
      labels = 0:23
    ) +
    ggplot2::labs(
      x = NULL,
      y = NULL,
      color = NULL,
      title = NULL
    ) +
    ggplot2::guides(
      color = ggplot2::guide_legend(override.aes = list(size = 4))
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text.y = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_text(size = 12),
      legend.text = ggplot2::element_text(size = 14),
      legend.position = "right"
    )
}
