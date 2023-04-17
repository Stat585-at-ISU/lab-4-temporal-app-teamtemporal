
<!-- README.md is generated from README.Rmd. Please edit that file -->

# AmesPD

<!-- badges: start -->

[![R-CMD-check](https://github.com/Stat585-at-ISU/AmesPD/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Stat585-at-ISU/AmesPD/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of AmesPD is to filter and visualize service calls to the Ames
Police Department (2021-2023) or ISU Police (2012-2019). We introduce a
shiny app as an interactive way for users to filter these calls based on
dates, types of incidents, locations, etc.

## Installation

You can install the development version of AmesPD from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Stat585-at-ISU/AmesPD")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(AmesPD)
## basic example code
```

There are two sources of data to choose from: Ames PD and ISU Police.

``` r
head(presslog_ames)
#> # A tibble: 6 × 7
#>   `Call Received Date/Time` Incident I…¹ How C…² Natur…³ Locat…⁴ Repor…⁵ Closi…⁶
#>   <dttm>                           <dbl> <chr>   <chr>   <chr>     <dbl> <chr>  
#> 1 2021-02-09 02:30:00          210202114 PHONE   DISTUR… 4211 L… NA      NAT    
#> 2 2021-02-09 01:52:00          210202108 PHONE   PRIVAT… 1206 S… NA      PTOW   
#> 3 2021-02-09 00:05:00          210202101 PHONE   DISTUR… 624-20… NA      NOR    
#> 4 2021-02-08 23:55:00          210202100 PHONE   SCAM    1118 S…  2.10e7 RPT    
#> 5 2021-02-08 23:19:00          210202095 W911    BURGLA… 2919 O…  2.10e7 RPT    
#> 6 2021-02-08 22:39:00          210202091 PHONE   CIVIL … 219-11… NA      NOR    
#> # … with abbreviated variable names ¹​`Incident ID`, ²​`How Call was Rec'd`,
#> #   ³​`Nature Code Description`, ⁴​`Location Address`,
#> #   ⁵​`Report Number Assigned to Event`, ⁶​`Closing Disposition or Cancel Code`
head(presslog_isu)
#> # A tibble: 6 × 9
#>   Case.Num…¹ Date.Time.Reported  Earliest.Occurrence Latest.Occurrence   Gener…²
#>   <chr>      <dttm>              <dttm>              <dttm>              <chr>  
#> 1 12-000003  2012-01-01 00:35:00 2012-01-01 00:35:00 2012-01-01 00:35:00 Chambe…
#> 2 12-000009  2012-01-01 01:46:00 2012-01-01 01:46:00 2012-01-01 01:46:00 Lincol…
#> 3 12-000017  2012-01-01 03:26:00 2012-01-01 03:26:00 2012-01-01 03:26:00 Frankl…
#> 4 12-000024  2012-01-01 14:00:00 NA                  NA                  Schill…
#> 5 12-000107  2012-01-05 10:58:00 2012-01-05 10:58:00 2012-01-05 10:58:00 Memori…
#> 6 12-000120  2012-01-05 22:56:00 2012-01-05 22:56:00 2012-01-05 22:56:00 Linden…
#> # … with 4 more variables: Disposition <chr>, Classification <chr>,
#> #   longitude <dbl>, latitude <dbl>, and abbreviated variable names
#> #   ¹​Case.Number, ²​General.Location
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />
