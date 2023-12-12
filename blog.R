
# vector containg all candidates name
candidate_name <- summary_div |> 
  html_elements("article.border-gray-10") |> 
  html_elements("p.font-jakarta.text-p_15_15.font-medium.text-gray-800") |> 
  html_text2()

# vector containg all candidates party name
candidate_party <- summary_div |> 
  html_elements("article.border-gray-10") |> 
  html_elements("div") |> 
  html_elements("p.font-jakarta.font-jakarta.text-p_15_15.font-light.text-gray-600") |> 
  html_text2()

# vector containg all candidates votes
candidate_votes <- summary_div |> 
  html_elements("article.border-gray-10") |> 
  html_elements("div") |> 
  html_elements("p.font-jakarta.font-jakarta.text-p_12_12.font-light.text-gray-800") |> 
  html_text2()

# vector containg all candidates percentage of the total votes count
candidate_pct_vote <- summary_div |> 
  html_elements("article.border-gray-10") |> 
  html_elements("div") |> 
  html_elements("p.font-jakarta.font-jakarta.text-p_12_12.font-light.text-gray-600.ml-1") |> 
  html_text2()

result_table <- tibble(
  "Candidate Name" = candidate_name,
  "Party" = candidate_party,
  "Number of Votes" = candidate_votes,
  "Percentage of Total Votes" = candidate_pct_vote
)
