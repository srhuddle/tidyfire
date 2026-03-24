\name{tidy_fire_get_fields}
\alias{tidy_fire_get_fields}
\title{Get Field Metadata}
\description{
Perform an authenticated request to the API field metadata endpoint.
}
\usage{
tidy_fire_get_fields(client)
}
}
\arguments{
  \item{client}{A \code{"tidy_fire_client"} object created by \code{tidy_fire_client()}.}
}
\value{
A parsed JSON response describing currently known API fields.
}
\examples{
\dontrun{
client <- tidy_fire_client(
  base_url = "https://usfa-agg.onrender.com",
  api_key = "demo-usfa-key"
)

tidy_fire_get_fields(client)
}
}
