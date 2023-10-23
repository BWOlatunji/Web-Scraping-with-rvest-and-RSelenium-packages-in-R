# Load packages
library(RSelenium)
library(rvest)
library(wdman)
library(netstat)
library(tidyverse)
# remote driver session
rs_driver_object <- rsDriver(browser = 'chrome',
                             chromever = "118.0.5993.70",
                             port = free_port(),
                             verbose = FALSE)

remDr <- rs_driver_object$client

# Navigate to the webpage
remDr$navigate('https://www.stears.co/elections/2023/president/')


# Define a list to store the resulting tables
result_tables <- list()

 # Find all path elements with the specified class attribute
path_elements <- remDr$findElements(using = "css", value = 'path.leaflet-interactive')

# Loop through the path elements and click on each one
for (path_element in path_elements) {
  
  path_element$clickElement()
  
  page_source <- remDr$getPageSource()
  page <- read_html(page_source[[1]])
  table <- page  |>  
    html_element("div.border.border-gray-200.overflow-scroll.mt-3.max-h-48") |> 
    html_element("table.table-auto.relative.border-separate.border-spacing-0.w-full")  |> 
    html_table()  %>%
    add_column(State = page %>%
                 html_element('p.font-jakarta.font-jakarta.text-p_18b.font-light.text-gray-600.my-auto') %>%
                 html_text2())
  
  # Append the table to the list
  result_tables <- append(result_tables, list(table))
}


# Close the browser
remDr$close()

# # Combine all the tables into a single data frame
combined_table <- do.call(rbind, result_tables)

# %>%
#   add_column(State = page %>%
#                html_element('p.font-jakarta.font-jakarta.text-p_18b.font-light.text-gray-600.my-auto') %>%
#                html_text2())


# Find all path elements with the specified class attribute
# path_elements <- remDr$findElements(using = "css", value = 'path.leaflet-interactive')
# 
# path_elements[[3]]$clickElement()
# 
# page_source <- remDr$getPageSource()
# page <- read_html(page_source[[1]])
# table <- page  |>  
#   html_element("div.border.border-gray-200.overflow-scroll.mt-3.max-h-48") |> 
#   html_element("table.table-auto.relative.border-separate.border-spacing-0.w-full")  |> 
#   html_table()  %>%
#   add_column(State = page %>%
#                html_element('p.font-jakarta.font-jakarta.text-p_18b.font-light.text-gray-600.my-auto') %>%
#                html_text2())
# 
# for (i in 1:length(path_elements)) {
#   print(i)
# }

