
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




# find and click the "Select State" dropdown
state_dropdown <-
  remDr$findElement(using = 'id',
                    'headlessui-menu-button-:R356t6:')

# the dropdown is clicked to open it
state_dropdown$clickElement()

# scrape all state url from their generated anchors
page_source <- remDr$getPageSource()
page <- read_html(page_source[[1]])
state_anchor_hrefs <- page  |>  
  html_elements(".flex.flex-col.justify-start.align-middle") |> 
  html_elements("a.text-gray-800")  |> 
  html_attr("href")


# Concatenate the main URL to each element of the state_anchors_href vector
# to generate the state results full URLs
state_results_urls <- paste("https://www.stears.co", state_anchor_hrefs, sep = "")

state_page <- read_html(state_results_urls[[1]])

# extract all state names
result_tables <- state_page |> 
  html_element("div.px-6.py-10.bg-white.md\\:px-8.md\\:py-6") |> 
  html_elements("section.mb-4") |> 
  html_table()

lga_names <- state_page |> 
  html_element("div.px-6.py-10.bg-white.md\\:px-8.md\\:py-6") |> 
  html_elements("section.mb-4") |> 
  html_elements("p.font-jakarta.font-jakarta.text-p_20.font-medium.-md\\:hidden.mt-10.capitalize") |> 
  html_text2()

state_name <- state_page |>  
  html_element("h1.w-full.h-12.font-bold.font-jakarta.text-\\[28px\\].leading-\\[40px\\]") |> 
  html_text2()

lga_tbl <- result_tables[[1]] |> add_column(LGA=lga_names[[1]],
                                             STATE=state_name,
                             .before = "Candidate")


# Iterate through the list of tables and add a column from the vector
for (i in 1:length(lga_names)) {
  # Reference each table using their indices
  table_index <- i
  current_table <- result_tables[[table_index]]
  
  # Add a new column to the current table using the vector element
  current_table["LGA"] <- lga_names[i]
  current_table["STATE"] <- state_name
  
  # Update the current table in the list
  result_tables[[table_index]] <- current_table
}

# Print the modified list of tables
print(result_tables)



