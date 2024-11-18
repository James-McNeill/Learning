# Review the csodata package to interact with the API
# How to guide https://cran.r-project.org/web/packages/csodata/vignettes/quick_start_guide.html
# More in-depth details https://cran.r-project.org/web/packages/csodata/csodata.pdf

# Package
library(csodata)
library(plotly)
library(tidyverse)

# TOC
toc <- cso_get_toc()

# Metadata
meta <- cso_get_meta("HPM09")

# Downloading data - version reviews monthly unemployment rate
# pivot_format adjusts format that of the data. NOTE: error when attempting option = "tidy"
tb1 <- cso_get_data("MUM01", pivot_format = "tall")

class(tb1$Month)

# Add date variable to table
tb1 <- tb1 %>%
  mutate(date_var = as.Date(as.character(Month), format = "%Y %B"))

# Meta information
# meta <- cso_get_meta("MUM01")
# cso_disp_meta("MUM01")

# Create figure of unemployment rate
fig <- plot_ly(tb1, type = "scatter", mode = "lines", color = "Sex") %>%
  add_trace(x = ~Month, y = ~value) %>%
  layout(xaxis = list(rangeslider = list(visible = T)))

fig
