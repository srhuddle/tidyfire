\name{tidy_fire_get_reference}
\alias{tidy_fire_get_reference}
\title{Query Reference Data}
\description{
Submit a reference-series query to the hosted API.
}
\usage{
tidy_fire_get_reference(
  client,
  metric_name,
  years,
  series_names = NULL,
  source_systems = NULL
)
}
\arguments{
  \item{client}{A client created by \code{tidy_fire_client()}.}

  \item{metric_name}{Reference metric to query, such as \code{"total_fires"}.}

  \item{years}{One or more years to request.}

  \item{series_names}{Optional vector of reference series names such as \code{"all_fires"}.}

  \item{source_systems}{Optional vector of source systems such as \code{"NFPA"}.}
}
\value{
A parsed JSON response containing response metadata and reference-series rows.
}
\examples{
\dontrun{
client <- tidy_fire_client(
  base_url = "https://usfa-agg.onrender.com",
  api_key = "demo-usfa-key"
)

tidy_fire_get_reference(
  client = client,
  metric_name = "total_fires",
  years = 2021:2023,
  series_names = "all_fires",
  source_systems = "NFPA"
)
}
}
