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

.tidy_fire_request <- function(client, path) {
  httr2::request(paste0(client$base_url, path)) |>
    httr2::req_headers(`x-api-key` = client$api_key)
}

tidy_fire_get_health <- function(client) {
  resp <- .tidy_fire_request(client, "/health") |>
    httr2::req_perform()

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
    httr2::req_perform()

  httr2::resp_body_json(resp, simplifyVector = TRUE)
}
