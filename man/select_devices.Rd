% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filtering.R
\name{select_devices}
\alias{select_devices}
\title{Select devices by ID}
\usage{
select_devices(sessions, device_ids, col_names = NULL, flag_only = FALSE)
}
\arguments{
\item{sessions}{The sessions dataframe}

\item{device_ids}{The device IDs to select}

\item{col_names}{A list to override default column names. This function uses columns:
\itemize{
\item \code{device_id}
}}

\item{flag_only}{If TRUE, only flags the filtered sessions without removing them from the table}
}
\value{
The sessions dataframe with only the sessions recorded by the specified devices
}
\description{
Select devices by ID
}
\examples{
filtered_sessions <- select_devices(example_sessions, c("VTGVSRTHCA"))
}
\seealso{
\code{\link[=select_subjects]{select_subjects()}} to select sessions by subject ID.

Other filtering: 
\code{\link{filter_by_age_range}()},
\code{\link{filter_by_night_range}()},
\code{\link{filter_by_sex}()},
\code{\link{filter_epochs_from_sessions}()},
\code{\link{remove_sessions_no_sleep}()},
\code{\link{select_subjects}()},
\code{\link{set_min_time_in_bed}()},
\code{\link{set_session_sleep_onset_range}()},
\code{\link{set_session_start_time_range}()}
}
\concept{filtering}
