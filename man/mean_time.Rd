% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/time_utils.R
\name{mean_time}
\alias{mean_time}
\title{Calculate the mean time from a vector of time strings}
\usage{
mean_time(time_vector, unit = "HH:MM")
}
\arguments{
\item{time_vector}{A vector of time strings in format "YYYY-MM-DD HH:MM:SS", "HH:MM:SS" or "HH:MM".}

\item{unit}{The unit of time for the result. Can be "HH:MM" (default), "hour", "minute" or "second".}
}
\value{
A string representing the mean time in the format "HH:MM".
}
\description{
This function calculates the mean time from a vector of time strings in the format "YYYY-MM-DD HH:MM:SS".
}
\examples{
# Use on a vector of time strings representing full dates
time_vector <- c("2025-04-08 23:00:00", "2025-04-09 01:00:00")
mean_time(time_vector)

# Use on time-only strings
time_vector <- c("22:56", "01:32")
mean_time(time_vector)

# Use on a dataframe column
mean_time(example_sessions$time_at_sleep_onset)
}
\seealso{
Other time processing: 
\code{\link{group_epochs_by_night}()},
\code{\link{group_sessions_by_night}()},
\code{\link{max_time}()},
\code{\link{min_time}()},
\code{\link{sd_time}()},
\code{\link{shift_times_by_12h}()},
\code{\link{time_diff}()}
}
\concept{time processing}
