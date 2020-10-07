# Presidential Debate

library(tidyverse)

debate <- read_csv("presdebate2020.csv")

theme_set(theme_minimal()) 
theme_update(panel.grid.minor = element_blank(),
             text = element_text(family = "IBM Plex Sans"),
             axis.title = element_blank())

debate_clean <- debate %>% 
  filter(!is.na(names)) %>% 
  rename(speaker = names) %>% 
  mutate_all(.funs = tolower) %>% 
  mutate(speaker = case_when(speaker == "president" ~ "trump",
                             speaker == "joe" ~ "biden", 
                             TRUE ~ speaker),
         id = row_number())

distinct(debate_clean, speaker)

#statement

statements <- debate_clean %>% 
  group_by(speaker) %>% 
  count()

ggplot(data = statements, aes(x = speaker, y = n, fill = speaker)) +
  geom_bar(stat = "identity")

# wie viele worte

number_words <- debate_clean %>% 
  mutate(words = str_count(statements,'\\w+'))

number_words %>% 
  group_by(speaker) %>% 
  summarise(totalwords = sum(words))

number_words %>% 
  filter(speaker != "wallace") %>% 
  select(words, speaker) %>% 
  ggplot(aes(x = words, fill = speaker)) +
  geom_density(alpha = 0.5) +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        text = element_text(family = "IBM Plex Sans"))

#length of statemens over time

number_words %>% 
  filter(speaker != "wallace") %>% 
ggplot(aes(x = id, y = words, group = speaker, color = speaker)) +
  geom_line() +
  theme(panel.grid = element_blank(),
        legend.position = "bottom") 
