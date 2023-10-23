

## Web Scraping Intro -----------------------------------

## Installing the libraries -----------------------------
install.packages("rvest")
install.packages("RSelenium")
install.packages("wdman")
install.packages("netstat")


## Loading libraries ------------------------------------
library(RSelenium)
library(rvest)
library(wdman)
library(netstat)
library(tidyverse)


## Navigating to a web page -----------------------------
presidential_result_page <- read_html("https://www.stears.co/elections/2023/president/")


## Explore the HTML elements ----------------------------
presidential_result_title <- presidential_result_page |> 
  html_element(".font-jakarta.hidden.md\\:block.font-medium.text-\\[20px\\].leading-\\[32px\\]") |> 
  html_text()


## Looking at single and multiple elements --------------

# -   single elements



# -   multiple elements


## Scraping the 2023 Presidential results ---------------

# - Summarized results



# - Scrape all results down to State and LGA levels




