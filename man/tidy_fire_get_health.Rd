\name{tidy_fire_get_health}
\alias{tidy_fire_get_health}
\title{Check API Health}
\description{
Perform an authenticated request to the API health endpoint.
}
\usage{
tidy_fire_get_health(client)
}
\arguments{
  \item{client}{A client created by \code{tidy_fire_client()}.}
}
\value{
A parsed JSON response, typically including service status and database name.
}
\examples{
\dontrun{
client <- tidy_fire_client(
  base_url = "https://usfa-agg.onrender.com",
  api_key = "demo-usfa-key"
)

tidy_fire_get_health(client)
}
}
