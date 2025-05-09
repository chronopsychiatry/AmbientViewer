#' Set minimum time in bed
#'
#' @param sessions The sessions dataframe
#' @param min_time_in_bed The minimum time in bed in hours
#' @returns The sessions dataframe with only the sessions that meet the minimum time in bed requirement
#' @export
#' @family filtering
#' @examples
#' filtered_sessions <- set_min_time_in_bed(example_sessions, 2)
set_min_time_in_bed <- function(sessions, min_time_in_bed) {
  if (!(class(min_time_in_bed) %in% c("numeric", "integer"))) {
    cli::cli_abort(c(
      "!" = "min_time_in_bed must be a numeric value (hours)."
    ))
  }
  sessions[sessions$time_in_bed >= min_time_in_bed * 60 * 60, ]
}

#' Set session start time range
#'
#' @param sessions The sessions dataframe
#' @param from_time Include sessions that started after this time (in format HH:MM)
#' @param to_time Include sessions that started before this time (in format HH:MM)
#' @returns The sessions dataframe with only the sessions that started within the specified time range
#' @export
#' @family filtering
#' @seealso [set_session_sleep_onset_range()] to filter sessions based on sleep onset time.
#' @examples
#' filtered_sessions <- set_session_start_time_range(example_sessions, "22:00", "06:00")
set_session_start_time_range <- function(sessions, from_time, to_time) {
  session_times <- parse_time(sessions$session_start) |> update(year = 0, month = 1, day = 1)
  from_time <- parse_time(from_time)
  to_time <- parse_time(to_time)

  if (from_time <= to_time) {
    sessions[session_times >= from_time & session_times <= to_time, ]
  } else {
    sessions[session_times >= from_time | session_times <= to_time, ]
  }
}

#' Set sleep onset time range
#'
#' @param sessions The sessions dataframe
#' @param from_time Include sessions where sleep started after this time (in format HH:MM)
#' @param to_time Include sessions where sleep started before this time (in format HH:MM)
#' @returns The sessions dataframe with only the sessions where sleep started within the specified time range
#' @export
#' @family filtering
#' @seealso [set_session_start_time_range()] to filter sessions based on start time.
#' @examples
#' filtered_sessions <- set_session_sleep_onset_range(example_sessions, "22:00", "06:00")
set_session_sleep_onset_range <- function(sessions, from_time, to_time) {
  sessions <- remove_sessions_no_sleep(sessions)

  session_times <- parse_time(sessions$time_at_sleep_onset) |> update(year = 0, month = 1, day = 1)
  from_time <- parse_time(from_time)
  to_time <- parse_time(to_time)

  if (from_time <= to_time) {
    sessions[session_times >= from_time & session_times <= to_time, ]
  } else {
    sessions[session_times >= from_time | session_times <= to_time, ]
  }
}

#' Remove sessions with no sleep
#'
#' @param sessions The sessions dataframe
#' @returns The sessions dataframe with only the sessions that have a sleep period greater than 0
#' @export
#' @family filtering
#' @examples
#' filtered_sessions <- remove_sessions_no_sleep(example_sessions)
remove_sessions_no_sleep <- function(sessions) {
  sessions[sessions$sleep_period > 0, ]
}

#' Get non-complying sessions (i.e. where there is more than one session on the same day)
#'
#' @param sessions The sessions dataframe
#' @returns The sessions dataframe with only the sessions that are non-complying
#' @export
#' @family data tables
#' @examples
#' duplicate_sessions <- get_non_complying_sessions(example_sessions)
get_non_complying_sessions <- function(sessions) {
  sessions[sessions$night %in% sessions$night[duplicated(sessions$night)], ]
}

#' Get a table of sessions that were removed during filtering
#'
#' @param sessions The original sessions dataframe
#' @param filtered_sessions The filtered sessions dataframe
#' @returns The sessions dataframe with only the sessions that were removed during filtering
#' @export
#' @family data tables
#' @examples
#' filtered_sessions <- set_session_start_time_range(example_sessions, "22:00", "06:00")
#' removed_sessions <- get_removed_sessions(example_sessions, filtered_sessions)
get_removed_sessions <- function(sessions, filtered_sessions) {
  if (nrow(filtered_sessions) > nrow(sessions)) {
    cli::cli_abort(c(
      "!" = "There are more rows in filtered sessions than in sessions.",
      "i" = "Have you accidentally swapped the function arguments?",
      "i" = "get_removed_sessions(sessions, filtered_sessions)"
    ))
  }
  sessions |>
    dplyr::anti_join(filtered_sessions, by = "id") |>
    remove_sessions_no_sleep()
}
