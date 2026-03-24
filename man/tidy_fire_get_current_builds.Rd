\name{tidy_fire_get_current_builds}
\alias{tidy_fire_get_current_builds}
\title{Get Current Build Metadata}
\description{
Perform an authenticated request to the API current-builds metadata endpoint.
}
\usage{
tidy_fire_get_current_builds(client)
}
\arguments{
  \item{client}{A \code{"tidy_fire_client"} object created by \code{tidy_fire_client()}.}
}
\value{
A parsed JSON response describing current published builds.
}
\examples{
client <- tidy_fire_client(
  base_url = "https://usfa-agg.onrender.com",
  api_key = "demo-usfa-key"
)

tidy_fire_get_current_builds(client)
}
