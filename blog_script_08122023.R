# Load packages
library(RSelenium)
library(rvest)
library(netstat)
library(tidyverse)

# remote driver session using rsDriver() from  the RSelenium package
rs_driver_object <- rsDriver(browser = 'chrome',
                             chromever = "120.0.6099.71",
                             # from netstat package
                             port = free_port(),
                             verbose = FALSE)

remDr <- rs_driver_object$client


# Navigate to the web page

election_result_url <- 'https://www.stears.co/elections/2023/president/'
remDr$navigate(election_result_url)

# Find the button element by its class name
button <- remDr$findElement(using = "css selector", value = ".h-full.w-full.flex.flex-row")

# Click the button
button$clickElement()

# scrape all state url from their generated anchors
page_source <- remDr$getPageSource()
page <- read_html(page_source[[1]])
state_anchor_hrefs <- page  |>  
  html_elements(".flex.flex-col.justify-start.align-middle") |> 
  html_elements("a.text-gray-800")  |> 
  html_attr("href")

print(state_anchor_hrefs)


state_results_urls <- paste("https://www.stears.co", state_anchor_hrefs, sep = "")

print(state_results_urls)





abia_state_page <- read_html(state_results_urls[[1]])

# extract all state names
abia_result_tables <- abia_state_page |>
  html_element("div.px-6.py-10.bg-white.md\\:px-8.md\\:py-6") |>
  html_elements("section.mb-4") |>
  html_table()

abia_lga_names <- abia_state_page |>
  html_element("div.px-6.py-10.bg-white.md\\:px-8.md\\:py-6") |>
  html_elements("section.mb-4") |>
  html_elements(
    "p.font-jakarta.font-jakarta.text-p_20.font-medium.-md\\:hidden.mt-10.capitalize"
  ) |>
  html_text2()

# print(abia_lga_names)

abia_state_name <- abia_state_page |>
  html_element("h1.w-full.h-12.font-bold.font-jakarta.text-\\[28px\\].leading-\\[40px\\]") |>
  html_text2()

# first lga i.e. Umuahia North
Umuahia_North_lga_tbl <- abia_result_tables[[1]] |>
  add_column(LGA = abia_lga_names[[1]],
             STATE = abia_state_name,
             .before = "Candidate")

print(Umuahia_North_lga_tbl)



all_states_results <- list()
# loop through the url for each state
for (state_results_url in state_results_urls) {
  state_page <- read_html(state_results_url)
  
  # extract all state results by lga. The result for each lga is kept in a table
  # on the page
  result_tables <- state_page |>
    html_element("div.px-6.py-10.bg-white.md\\:px-8.md\\:py-6") |>
    html_elements("section.mb-4") |>
    html_table()
  
  lga_names <- state_page |>
    html_element("div.px-6.py-10.bg-white.md\\:px-8.md\\:py-6") |>
    html_elements("section.mb-4") |>
    html_elements(
      "p.font-jakarta.font-jakarta.text-p_20.font-medium.-md\\:hidden.mt-10.capitalize"
    ) |>
    html_text2()
  
  state_name <- state_page |>
    html_element("h1.w-full.h-12.font-bold.font-jakarta.text-\\[28px\\].leading-\\[40px\\]") |>
    html_text2()
  
  
  # Iterate through the list of tables and add the STATE and LGA columns
  for (i in 1:length(lga_names)) {
    # Reference each table using their indices
    table_index <- i
    current_table <- result_tables[[table_index]]
    
    # Add LGA and STATE columns to the current table using the vector element
    current_table["LGA"] <- lga_names[i]
    current_table["STATE"] <- state_name
    
    # Update the current table in the list
    result_tables[[table_index]] <- current_table
  }
  
  all_states_results <- append(all_states_results, result_tables)
  
}

print(all_states_results)

# Print the modified list of tables
print(all_states_results[[1]])
print(all_states_results[[100]])
print(all_states_results[[774]])


# Bind all tables in the all_states_results together
combined_tibble <- bind_rows(all_states_results) |>
  select(-`Votes Margin`) |>
  replace_na(list(Votes = "0", Percent = "0%"))

print(combined_tibble)












