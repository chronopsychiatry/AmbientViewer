#' Make a summary of session information
#'
#' This function summarises session information, including the number of sessions, mean session length,
#' mean time at sleep onset and wakeup, subject and device ID.
#' @param sessions The sessions dataframe.
#' @param col_names A list to override default column names. This function uses columns:
#' - `time_at_sleep_onset`
#' - `time_at_wakeup`
#' - `time_in_bed`
#' - `sleep_period`
#' @returns A single-row dataframe summarizing session information.
#' @importFrom rlang .data
#' @export
#' @family data tables
#' @examples
#' get_sessions_summary(example_sessions)
#' @seealso [get_epochs_summary()] to summarise epoch information.
get_sessions_summary <- function(sessions, col_names = NULL) {
  if (nrow(sessions) == 0) {
    return(data.frame(
      total_sessions = 0,
      mean_sleep_onset = NA,
      mean_wakeup_time = NA,
      mean_time_in_bed = NA,
      sleep_efficiency = NA
    ))
  }
  col <- get_session_colnames(sessions, col_names)

  summary <- sessions |>
    dplyr::summarise(
      total_sessions = dplyr::n(),
      mean_sleep_onset = if (!is.null(col$time_at_sleep_onset)) mean_time(.data[[col$time_at_sleep_onset]]) else NA,
      mean_wakeup_time = if (!is.null(col$time_at_wakeup)) mean_time(.data[[col$time_at_wakeup]]) else NA,
      mean_time_in_bed = if (!is.null(col$time_in_bed)) mean(.data[[col$time_in_bed]]) / 3600 else NA,
      sleep_efficiency = if (!is.null(col$time_in_bed) && !is.null(col$sleep_period)) {
        paste0(as.integer(round(mean(sessions[[col$sleep_period]], na.rm = TRUE) / mean(sessions[[col$time_in_bed]], na.rm = TRUE) * 100)), "%")
      } else {
        NA
      },
    )

  if ("annotation" %in% colnames(sessions)) {
    annot <- sessions$annotation[sessions$annotation != ""]
    summary$annotations <- dplyr::n_distinct(annot)
  }
  summary
}

#' Summarise epoch information
#'
#' This function displays the number of sessions in the epoch data, as well as the start and end dates of the epoch data
#' @param epochs The epochs dataframe
#' @param col_names A list to override default column names. This function uses columns:
#' - `timestamp`
#' - `session_id`
#' @returns A single-row dataframe summarising epoch information
#' @importFrom rlang .data
#' @export
#' @family data tables
#' @examples
#' get_epochs_summary(example_epochs)
#' @seealso [get_sessions_summary()] to summarise session information.
get_epochs_summary <- function(epochs, col_names = NULL) {
  if (nrow(epochs) == 0) {
    return(data.frame(total_sessions = 0, start_date = NA, end_date = NA))
  }
  col <- get_epoch_colnames(epochs, col_names)

  epochs |>
    dplyr::summarise(
      total_sessions = dplyr::n_distinct(.data[[col$session_id]]),
      start_date = if (!is.null(col$timestamp)) format(min(parse_time(.data[[col$timestamp]]), na.rm = TRUE), "%Y-%m-%d") else NA,
      end_date = if (!is.null(col$timestamp)) format(max(parse_time(.data[[col$timestamp]]), na.rm = TRUE), "%Y-%m-%d") else NA
    )
}

get_col <- function(df, col) {
  if (is.null(col) || !col %in% colnames(df)) {
    rep(list(NULL), nrow(df))
  } else {
    df[[col]]
  }
}
