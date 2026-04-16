library(tidyfire)

# Set the geography for this example run.
state_geoid <- "42"
county_geoid <- "42001"
county_name <- "Adams County, PA"

# Create an authenticated client for the hosted prototype API.
client <- tidy_fire_client(
  base_url = "https://usfa-agg.onrender.com",
  api_key = "demo-usfa-key"
)

# Query yearly raw county totals for the selected state.
# tidyfire requests tract-level data from the API and returns county summaries
# aggregated from those census-tract records, then we keep the selected county.
raw <- subset(
  as.data.frame(tidy_fire_get_summary(
    client = client,
    layer = "raw",
    years = 2021:2024,
    geography_vintage = "tract20",
    summary_level = "county",
    state_geoid = state_geoid,
    fields = "total_fires"
  )$data),
  countyGEOID == county_geoid,
  select = c("year", "total_fires")
)

# Query yearly estimated county totals for the same county and years.
estimated <- subset(
  as.data.frame(tidy_fire_get_summary(
    client = client,
    layer = "estimated",
    years = 2021:2024,
    geography_vintage = "tract20",
    summary_level = "county",
    state_geoid = state_geoid,
    fields = "total_fires"
  )$data),
  countyGEOID == county_geoid,
  select = c("year", "total_fires")
)

# Print a simple console table of reported totals by year.
print(data.frame(
  county = county_name,
  year = raw$year,
  raw_total_fires = raw$total_fires
))

# Print a simple console table of estimated totals by year.
print(data.frame(
  county = county_name,
  year = estimated$year,
  estimated_total_fires = round(estimated$total_fires, 1)
))
