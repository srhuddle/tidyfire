\name{tidy_fire_get}
\alias{tidy_fire_get}
\title{Query Aggregate Data}
\description{
Submit an aggregate query to the hosted API.
}
\usage{
tidy_fire_get(
  client,
  layer,
  years,
  geography_vintage,
  state_geoid = NULL,
  county_geoid = NULL,
  tract_geoids = NULL,
  fields
)
}
\arguments{
  \item{client}{A client created by \code{tidy_fire_client()}.}

  \item{layer}{Analytical layer to query.}

  \item{years}{One or more years to request.}

  \item{geography_vintage}{Required tract geography vintage, such as \code{"tract20"}.}

  \item{state_geoid}{Optional state GEOID filter.}

  \item{county_geoid}{Optional county GEOID filter.}

  \item{tract_geoids}{Optional vector of tract GEOIDs.}

  \item{fields}{Character vector of requested field names.}
}
\value{
A parsed JSON response containing response metadata and tract-level rows.
}
\examples{
\dontrun{
client <- tidy_fire_client(
  base_url = "https://usfa-agg.onrender.com",
  api_key = "demo-usfa-key"
)

tidy_fire_get(
  client = client,
  layer = "raw",
  years = 2021:2024,
  geography_vintage = "tract20",
  state_geoid = "11",
  fields = c(
    "total_fires",
    "primary_fire_count",
    "aid_fire_count"
  )
)

tidy_fire_get(
  client = client,
  layer = "corrected",
  years = 2021:2024,
  geography_vintage = "tract20",
  state_geoid = "11",
  fields = c(
    "total_fires",
    "primary_fire_count",
    "aid_fire_count"
  )
)

tidy_fire_get(
  client = client,
  layer = "estimated",
  years = 2021:2024,
  geography_vintage = "tract20",
  state_geoid = "11",
  fields = c("total_fires")
)

# Aggregate tract rows into a year-level table with columns:
# Year, Raw, Corrected, Estimated.

state_geoids_50dc <- sprintf("%02d", c(
  1, 2, 4, 5, 6, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19,
  20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33,
  34, 35, 36, 37, 38, 39, 40, 41, 42, 44, 45, 46, 47, 48,
  49, 50, 51, 53, 54, 55, 56
))

state_geoids_raw <- c("00", state_geoids_50dc)

pull_national_residential_totals <- function(field_name) {
  pieces <- lapply(state_geoids_raw, function(st) {
    result <- tidy_fire_get(
      client = client,
      layer = "raw",
      years = 2021:2024,
      geography_vintage = "tract20",
      state_geoid = st,
      fields = c(field_name)
    )

    df <- as.data.frame(result$data)

    data.frame(
      year = df$year,
      value = df[[field_name]]
    )
  })

  out <- do.call(rbind, pieces)
  aggregate(value ~ year, data = out, FUN = sum)
}

national_residential_fires <- pull_national_residential_totals("residential_fire_count")
national_residential_deaths <- pull_national_residential_totals("residential_fire_death_count")

national_residential_totals <- data.frame(
  Year = national_residential_fires$year,
  ResidentialFires = national_residential_fires$value,
  ResidentialFireDeaths = national_residential_deaths$value
)
}
}
