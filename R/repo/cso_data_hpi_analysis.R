# Review the csodata package to interact with the API
# How to guide https://cran.r-project.org/web/packages/csodata/vignettes/quick_start_guide.html
# More in-depth details https://cran.r-project.org/web/packages/csodata/csodata.pdf

# TODO
# Add multiple lines to the plots to understand movements across time. Color option not working

# Package
library(csodata)
library(plotly)
library(tidyverse)
library(reshape2)
library(ggplot2)

# TOC
toc <- cso_get_toc()

# Metadata
meta <- cso_get_meta("HPM09")

# Display details on table
table_vars <- cso_get_vars("HPM09")

# Downloading data - version reviews monthly unemployment rate
# pivot_format adjusts format that of the data. NOTE: error when attempting option = "tidy"
tb1 <- cso_get_data("HPM09", pivot_format = "tall")

class(tb1$Month)
class(tb1)

# add the date variable
# substr(): used to extract section of the string variable
# word(): extracts the words contained within the string, second parameter shows element selected
# ISOdate(): allows for creating date with (year, month, day) format
tb1 <- tb1 %>%
  mutate(
    # Date1 = substr(Month, 1, 4),
    # Date2 = word(Month, 1),
    # Date3 = word(Month, 2),
    # Date4 = match(word(Month, 2), month.name),
    Date = as.Date(ISOdate(substr(Month, 1, 4), match(word(Month, 2), month.name), 1))
    )

# Add date variable to table - code does not work
#tb1 <- tb1 %>%
#  mutate(date_var = as.Date(as.character(Month), format = "%Y %B"))

# Filter for only the RPPI
tb_res <- tb1 %>% filter(Statistic == "Residential Property Price Index")

# Transpose by the Res Property Type
tb_res_trans <- tb_res %>% 
  pivot_wider(names_from = "Type.of.Residential.Property",
              values_from = value)

# Create figure of HPI
# fig <- plot_ly(tb_res, x = ~Month, y = ~value, color = "Type.of.Residential.Property") %>%
#   layout(xaxis = list(rangeslider = list(visible = T)))
# 
# fig <- fig %>% add_lines()
  ggplot(data = tb_res, aes(x = Date, y = value)) +
    geom_line(aes(colour = "Type.of.Residential.Property"))# fig

class(tb_res)
  
# Exclude rows that have missing data in ANY variable
tb_res_no_NA <- na.omit(tb_res)
summary(tb_res_no_NA)

 
  # # scale_color_viridis(discrete = TRUE) +
    # theme(
    #   legend.position="none",
    #   plot.title = element_text(size=14)
    # ) +
  #   ggtitle("A spaghetti chart of baby names popularity") 

unique(tb_res_no_NA$Type.of.Residential.Property)


# dummy data
set.seed(45)
df <- data.frame(x=rep(1:5, 9), val=sample(1:100, 45), 
                 variable=rep(paste0("category", 1:9), each=5))
# plot
ggplot(data = df, aes(x=x, y=val)) + geom_line(aes(colour=variable))
