\name{tidy_fire_get_availability}
\alias{tidy_fire_get_availability}
\title{Get Data Availability Metadata}
\description{
Perform an authenticated request to the API availability metadata endpoint.
}
\usage{
tidy_fire_get_availability(client)
}
\arguments{
  \item{client}{A \code{"tidy_fire_client"} object created by \code{tidy_fire_client()}.}
}
\value{
A parsed JSON response describing currently published availability by layer, year, and geography.
}
\examples{
\dontrun{
client <- tidy_fire_client(
  base_url = "https://usfa-agg.onrender.com",
  api_key = "demo-usfa-key"
)

tidy_fire_get_availability(client)
}
}
