# presidential debate 2020

library(rvest)
library(tidyverse)

debate <- read_html("https://eu.usatoday.com/story/news/politics/elections/2020/09/30/presidential-debate-read-full-transcript-first-debate/3587462001/")

debate_clean <- debate %>% 
  html_nodes("p") %>% 
  html_text()

debate_clean <- debate_clean[-c(1,2,504)]

names <- debate_clean[seq(debate_clean) %% 2 == 1]

statements <- debate_clean[seq(debate_clean) %% 2 != 1]


df <- as_tibble(cbind(names, statements))

df_clean <- df %>% 
 mutate(names = str_extract(names, "[A-Za-z]+"))

write_csv(df_clean, "presdebate2020.csv")
