\name{tidy_fire_get}
\alias{tidy_fire_get_tract}
\alias{tidy_fire_get}
\title{Query Tract Data}
\description{
Submit a tract query to the hosted API.
}
\usage{
tidy_fire_get_tract(
  client,
  layer,
  years,
  geography_vintage,
  state_geoid = NULL,
  county_geoid = NULL,
  tract_geoids = NULL,
  fields
)

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

tidy_fire_get_tract(
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

tidy_fire_get_tract(
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

tidy_fire_get_tract(
  client = client,
  layer = "estimated",
  years = 2021:2024,
  geography_vintage = "tract20",
  state_geoid = "11",
  fields = c("total_fires")
)

# Roll tract rows up into a year-level table with columns:
# Year, Raw, Corrected, Estimated.

national_summary <- tidy_fire_get_summary(
  client = client,
  layer = "raw",
  years = 2021:2024,
  geography_vintage = "tract20",
  summary_level = "national",
  fields = c(
    "residential_fire_count",
    "residential_fire_death_count"
  )
)
}
}
