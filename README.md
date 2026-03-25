# tidyfire

`tidyfire` is a thin R client for querying hosted U.S. census-tract fire aggregate APIs.

Current responsibilities:
- authenticate with an API key
- query the hosted aggregate API
- retrieve API metadata for fields, availability, and current builds
- return parsed JSON responses for analysis in R

Current hosted prototype:
- Base URL: `https://usfa-agg.onrender.com`
- Demo API key: `demo-usfa-key`

## Current working slice

The current hosted slice supports:
- `layer = "raw"` for years `2021-2024`
- `layer = "corrected"` for years `2021-2024`
- `layer = "estimated"` for years `2021-2024`
- one or more requested years per query
- `geography_vintage = "tract20"`
- `state_geoid = "11"` for all DC tracts
- explicit field selection for raw:
  - `total_fires`
  - `primary_fire_count`
  - `aid_fire_count`
- explicit field selection for corrected:
  - `total_fires`
  - `primary_fire_count`
  - `aid_fire_count`
- explicit field selection for estimated:
  - `total_fires`
  - `total_fires_sd`
  - `total_fires_se`
  - `total_fires_ci_95_lower`
  - `total_fires_ci_95_upper`

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

# Query raw tract20 aggregates for all tracts in DC across 2021-2024.
raw_result <- tidy_fire_get(
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

# Query corrected tract20 aggregates for all tracts in DC across 2021-2024.
corrected_result <- tidy_fire_get(
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

# Query estimated tract20 aggregates for all tracts in DC across 2021-2024.
estimated_result <- tidy_fire_get(
  client = client,
  layer = "estimated",
  years = 2021:2024,
  geography_vintage = "tract20",
  state_geoid = "11",
  fields = c("total_fires")
)

# Pull the tract rows into plain data frames for analysis.
raw_df <- as.data.frame(raw_result$data)
corrected_df <- as.data.frame(corrected_result$data)
estimated_df <- as.data.frame(estimated_result$data)

# Sum total fires across tracts to compare DC-wide yearly totals by layer.
dc_year_totals <- rbind(
  data.frame(
    year = raw_df$year,
    layer = "raw",
    total_fires = raw_df$total_fires
  ),
  data.frame(
    year = corrected_df$year,
    layer = "corrected",
    total_fires = corrected_df$total_fires
  ),
  data.frame(
    year = estimated_df$year,
    layer = "estimated",
    total_fires = estimated_df$total_fires
  )
)

dc_year_totals <- aggregate(
  total_fires ~ year + layer,
  data = dc_year_totals,
  FUN = sum
)

# Reshape to a wide year-level comparison table.
dc_year_totals_wide <- reshape(
  dc_year_totals,
  idvar = "year",
  timevar = "layer",
  direction = "wide"
)

names(dc_year_totals_wide) <- c("Year", "Corrected", "Estimated", "Raw")
dc_year_totals_wide <- dc_year_totals_wide[, c("Year", "Raw", "Corrected", "Estimated")]
dc_year_totals_wide <- dc_year_totals_wide[order(dc_year_totals_wide$Year), ]

health
raw_result$meta
head(raw_df)
corrected_result$meta
head(corrected_df)
estimated_result$meta
head(estimated_df)
dc_year_totals_wide
```

## Current functions

- `tidy_fire_client(base_url, api_key)`
- `tidy_fire_get(client, layer, years, geography_vintage, state_geoid = NULL, county_geoid = NULL, tract_geoids = NULL, fields)`
- `tidy_fire_get_health(client)`
- `tidy_fire_get_fields(client)`
- `tidy_fire_get_availability(client)`
- `tidy_fire_get_current_builds(client)`

## Metadata helpers

```r
fields <- tidy_fire_get_fields(client)
availability <- tidy_fire_get_availability(client)
current_builds <- tidy_fire_get_current_builds(client)
```

## Current limitations

- unsupported layer, year, or field combinations should return validation errors from the API
