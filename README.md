# tidyfire

`tidyfire` is a thin R client for querying hosted U.S. census-tract fire aggregate APIs.

Current responsibilities:
- authenticate with an API key
- query the hosted aggregate API
- return parsed JSON responses for analysis in R

Current hosted prototype:
- Base URL: `https://usfa-agg.onrender.com`
- Demo API key: `demo-usfa-key`

## Current working slice

The current hosted slice supports:
- `layer = "corrected"`
- `years = 2021`
- `geography_vintage = "tract20"`
- `state_geoid = "11"` for all DC tracts
- explicit field selection for:
  - `total_fires`
  - `total_fires_median`
  - `total_fires_ci_95_lower`
  - `total_fires_ci_95_upper`
  - `total_fires_zero_count`

The response includes tract-level rows plus response-level build and definition metadata.

## Install

Development install from GitHub:

```r
install.packages("remotes")
remotes::install_github("srhuddle/tidyfire")
```

Then load the package:

```r
library(tidyfire)
```

## Minimal example

```r
library(tidyfire)

# Create an authenticated client for the hosted prototype API.
client <- tidy_fire_client(
  base_url = "https://usfa-agg.onrender.com",
  api_key = "demo-usfa-key"
)

# Confirm the service is up before running a data query.
health <- tidy_fire_get_health(client)

# Query corrected 2021 tract20 aggregates for all tracts in DC.
result <- tidy_fire_get(
  client = client,
  layer = "corrected",
  years = 2021,
  geography_vintage = "tract20",
  state_geoid = "11",
  fields = c(
    "total_fires",
    "total_fires_median",
    "total_fires_ci_95_lower",
    "total_fires_ci_95_upper",
    "total_fires_zero_count"
  )
)

# Pull the tract rows into a plain data frame for analysis.
result_df <- as.data.frame(result$data)

health
result$meta
head(result_df)
```

## Current functions

- `tidy_fire_client(base_url, api_key)`
- `tidy_fire_get(client, layer, years, geography_vintage, state_geoid = NULL, county_geoid = NULL, tract_geoids = NULL, fields)`
- `tidy_fire_get_health(client)`

## Current limitations

- the function signature is intentionally broader than the currently implemented backend slice
- the hosted API currently supports the first corrected query pattern only
- unsupported combinations should return validation errors from the API
