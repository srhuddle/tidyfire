tidy_fire_client <- function(base_url, api_key) {
  stopifnot(is.character(base_url), length(base_url) == 1, nzchar(base_url))
  stopifnot(is.character(api_key), length(api_key) == 1, nzchar(api_key))

  structure(
    list(
      base_url = sub("/+$", "", base_url),
      api_key = api_key
    ),
    class = "tidy_fire_client"
  )
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

.tidy_fire_request <- function(client, path) {
  httr2::request(paste0(client$base_url, path)) |>
    httr2::req_headers(`x-api-key` = client$api_key)
}

.tidy_fire_extract_error <- function(resp) {
  body <- tryCatch(
    httr2::resp_body_json(resp, simplifyVector = TRUE),
    error = function(e) NULL
  )

  if (is.null(body)) {
    return(NULL)
  }

  detail <- body$detail %||% body$error
  if (is.null(detail)) {
    return(NULL)
  }

  detail
}

.tidy_fire_abort_from_response <- function(resp) {
  detail <- .tidy_fire_extract_error(resp)

  if (is.null(detail)) {
    status <- httr2::resp_status(resp)
    stop(sprintf("API request failed with HTTP %s.", status), call. = FALSE)
  }

  if (is.character(detail)) {
    stop(detail, call. = FALSE)
  }

  if (is.data.frame(detail) && "msg" %in% names(detail)) {
    lines <- c("API request failed.")
    inputs <- unique(as.character(detail$input %||% character()))
    inputs <- inputs[nzchar(inputs)]
    messages <- unique(as.character(detail$msg))

    if (length(inputs) > 0) {
      lines <- c(lines, "", "Invalid fields:", paste0("- ", inputs))
    }

    lines <- c(lines, "", "Validation details:", paste0("- ", messages))
    stop(paste(lines, collapse = "\n"), call. = FALSE)
  }

  if (is.list(detail) && length(detail) > 0 && !is.null(detail[[1]]) && is.list(detail[[1]]) && !is.null(detail[[1]]$msg)) {
    lines <- c("API request failed.")
    messages <- unique(vapply(detail, function(item) item$msg %||% "Validation error", character(1)))
    inputs <- unique(vapply(detail, function(item) as.character(item$input %||% ""), character(1)))
    inputs <- inputs[nzchar(inputs)]

    if (length(inputs) > 0) {
      lines <- c(lines, "", "Invalid fields:", paste0("- ", inputs))
    }

    lines <- c(lines, "", "Validation details:", paste0("- ", messages))
    stop(paste(lines, collapse = "\n"), call. = FALSE)
  }

  lines <- c(detail$message %||% "API request failed.")

  if (!is.null(detail$invalidFields) && length(detail$invalidFields) > 0) {
    lines <- c(lines, "", "Invalid fields:", paste0("- ", detail$invalidFields))
  }

  if (!is.null(detail$supportedFields) && length(detail$supportedFields) > 0) {
    lines <- c(lines, "", sprintf("Supported fields for %s:", detail$layer %||% "this layer"), paste0("- ", detail$supportedFields))
  }

  if (!is.null(detail$suggestion) && nzchar(detail$suggestion)) {
    lines <- c(lines, "", "Suggestion:", detail$suggestion)
  }

  stop(paste(lines, collapse = "\n"), call. = FALSE)
}

.tidy_fire_perform <- function(req) {
  tryCatch(
    httr2::req_perform(req),
    httr2_http = function(cnd) {
      resp <- cnd$resp %||% cnd$response
      if (is.null(resp)) {
        stop(conditionMessage(cnd), call. = FALSE)
      }
      .tidy_fire_abort_from_response(resp)
    }
  )
}

tidy_fire_get_health <- function(client) {
  resp <- .tidy_fire_request(client, "/health") |>
    .tidy_fire_perform()

  httr2::resp_body_json(resp, simplifyVector = TRUE)
}

tidy_fire_get_fields <- function(client) {
  resp <- .tidy_fire_request(client, "/v1/metadata/fields") |>
    .tidy_fire_perform()

  httr2::resp_body_json(resp, simplifyVector = TRUE)
}

tidy_fire_get_availability <- function(client) {
  resp <- .tidy_fire_request(client, "/v1/metadata/availability") |>
    .tidy_fire_perform()

  httr2::resp_body_json(resp, simplifyVector = TRUE)
}

tidy_fire_get_current_builds <- function(client) {
  resp <- .tidy_fire_request(client, "/v1/metadata/builds/current") |>
    .tidy_fire_perform()

  httr2::resp_body_json(resp, simplifyVector = TRUE)
}

tidy_fire_get <- function(
  client,
  layer,
  years,
  geography_vintage,
  state_geoid = NULL,
  county_geoid = NULL,
  tract_geoids = NULL,
  fields
) {
  stopifnot(is.character(layer), length(layer) == 1, nzchar(layer))
  stopifnot(length(years) >= 1)
  stopifnot(is.character(geography_vintage), length(geography_vintage) == 1, nzchar(geography_vintage))
  stopifnot(length(fields) >= 1)

  body <- list(
    layer = layer,
    years = as.list(years),
    geography = list(
      geographyVintage = geography_vintage
    ),
    fields = as.list(fields)
  )

  if (!is.null(state_geoid)) {
    body$geography$stateGEOID <- state_geoid
  }
  if (!is.null(county_geoid)) {
    body$geography$countyGEOID <- county_geoid
  }
  if (!is.null(tract_geoids)) {
    body$geography$tractGEOIDs <- as.list(tract_geoids)
  }

  resp <- .tidy_fire_request(client, "/v1/aggregates/query") |>
    httr2::req_body_json(body, auto_unbox = TRUE) |>
    .tidy_fire_perform()

  httr2::resp_body_json(resp, simplifyVector = TRUE)
}
