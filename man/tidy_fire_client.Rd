\name{tidy_fire_client}
\alias{tidy_fire_client}
\title{Create a Tidyfire API Client}
\description{
Create a client object for authenticated requests to a hosted fire aggregate API.
}
\usage{
tidy_fire_client(base_url, api_key)
}
\arguments{
  \item{base_url}{Base URL for the hosted API.}

  \item{api_key}{API key sent in the \code{x-api-key} request header.}
}
\value{
A list with class \code{"tidy_fire_client"} containing connection settings.
}
\examples{
client <- tidy_fire_client(
  base_url = "https://usfa-agg.onrender.com",
  api_key = "demo-usfa-key"
)
}
