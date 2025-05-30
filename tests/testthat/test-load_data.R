test_folder <- tempdir()
write.csv(example_sessions, file.path(test_folder, "2025-03-03_2025-03-04_sessions_reports.csv"), row.names = FALSE)
write.csv(example_epochs, file.path(test_folder, "2025-03-03_2025-03-04_epoch_data.csv"), row.names = FALSE)

test_that("load_sessions loads sessions correctly", {
  sessions <- load_sessions(file.path(test_folder, "2025-03-03_2025-03-04_sessions_reports.csv"))

  expect_equal(nrow(sessions), 124)
  expect_equal(sessions$id[1], "VEhDQRkEEQwuDQAA")
  expect_equal(sessions$.data_type[1], "somnofy_v2")
})

test_that("load_sessions throws error for missing sessions file", {
  expect_error(
    load_sessions(file.path(test_folder, "non_existent_file.csv")),
    "Sessions file not found"
  )
})

test_that("load_sessions gives warning and returns NULL for empty sessions file", {
  empty_file <- file.path(test_folder, "empty_sessions.csv")
  write.csv(example_sessions[0, ], empty_file, row.names = FALSE)

  expect_warning(
    result <- load_sessions(empty_file),
    "Sessions table is empty"
  )
  expect_null(result)
})

test_that("load_epochs loads epochs correctly", {
  epochs <- load_epochs(file.path(test_folder, "2025-03-03_2025-03-04_epoch_data.csv"))

  expect_equal(nrow(epochs), 18755)
  expect_equal(epochs$.data_type[1], "somnofy_v2")
})

test_that("load_epochs throws error for missing epochs file", {
  expect_error(
    load_epochs(file.path(test_folder, "non_existent_file.csv")),
    "Epochs file not found"
  )
})

test_that("load_epochs gives warning and returns NULL for empty epochs file", {
  empty_file <- file.path(test_folder, "empty_epochs.csv")
  write.csv(example_epochs[0, ], empty_file, row.names = FALSE)

  expect_warning(
    result <- load_epochs(empty_file),
    "Epochs table is empty"
  )
  expect_null(result)
})

test_that("set_data_type sets the data type correctly", {
  sessions <- data.frame(id = 1:5)
  epochs <- data.frame(session_id = 1:5)

  sessions <- set_data_type(sessions, "somnofy_v1")
  epochs <- set_data_type(epochs, "somnofy_v1")

  expect_equal(sessions$.data_type[1], "somnofy_v1")
  expect_equal(epochs$.data_type[1], "somnofy_v1")
})

test_that("get_sessions_format returns the correct format for somnofy_v2", {
  result <- get_sessions_format(example_sessions)
  expect_equal(result, "somnofy_v2")
})

test_that("get_epochs_format returns the correct format for somnofy_v2", {
  result <- get_epochs_format(example_epochs)
  expect_equal(result, "somnofy_v2")
})
