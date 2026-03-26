\name{tidy_fire_get_summary}
\alias{tidy_fire_get_summary}
\title{Query Summary Aggregates}
\description{
Submit a summary aggregate query to the hosted API.
}
\usage{
tidy_fire_get_summary(
  client,
  layer,
  years,
  geography_vintage,
  summary_level,
  state_geoid = NULL,
  county_geoid = NULL,
  fields
)
}
\arguments{
  \item{client}{A client created by \code{tidy_fire_client()}.}

  \item{layer}{Analytical layer to query.}

  \item{years}{One or more years to request.}

  \item{geography_vintage}{Required tract geography vintage, such as \code{"tract20"}.}

  \item{summary_level}{Summary geography level such as \code{"national"}, \code{"state"}, or \code{"county"}.}

  \item{state_geoid}{Optional state GEOID filter.}

  \item{county_geoid}{Optional county GEOID filter.}

  \item{fields}{Character vector of requested summary field names.}
}
\value{
A parsed JSON response containing response metadata and summary rows.
}
\examples{
\dontrun{
client <- tidy_fire_client(
  base_url = "https://usfa-agg.onrender.com",
  api_key = "demo-usfa-key"
)

tidy_fire_get_summary(
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
