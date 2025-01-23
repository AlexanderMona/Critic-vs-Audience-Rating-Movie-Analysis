rm(list=ls())

rotten_tomatoes <- read.csv("rottentomatoes.csv", stringsAsFactors = FALSE)
rotten_tomatoes$summary <- NULL
library(xml2)
# install.packages("rvest")
library(rvest)
user_agent <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

Start <- Sys.time()

#26 Pages for 2016 alone

library(rvest)

user_agent <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
Start <- Sys.time()


# Initialize an empty data frame to store all movies data
all_movies_df <- data.frame(stringsAsFactors = FALSE)

for (i in 0:26) {
  print (i)
  curr_page <- paste("https://www.metacritic.com/browse/movie/all/all/2016/metascore/?page=", i, sep="")
  page <- read_html(curr_page, user_agent)
  
  movie_title <- xml_text(xml_find_all(page, "//div[@class ='c-finderProductCard_title']/h3/span[2]"))
  release_date <- xml_text(xml_find_all(page, "//span[@class ='u-text-uppercase']"))
  meta_score <- as.integer(xml_text(xml_find_all(page, xpath = "//span[@data-v-4cdca868='']")))
  summary <- xml_text(xml_find_all(page, xpath = "//div[@class='c-finderProductCard_description']"))
  
  rv <- sample(3:15, 1)
  Sys.sleep(rv)
  
  # Combine all summaries into a single character vector
  all_summaries <- unlist(summary)
  
  movies_df <- data.frame(movie_title, release_date, meta_score, summary = all_summaries)
  all_movies_df <- rbind(all_movies_df, movies_df)
}

# Horizontally merge rotten tomatoes data with metacritic data
merged_movie_reviews <- merge(rotten_tomatoes, all_movies_df, by.x = "movie_title", by.y = "movie_title")

# Clean data to only have 2016 original_release_date match up with release_date

library(lubridate)
library(dplyr)

# Extract the year from the original_release_date column
subset_merged <- merged_movie_reviews %>%
  mutate(year = year(mdy(original_release_date))) %>%
  filter(year == 2016)

# Clean the merged data set
subset_merged$year <- NULL

subset_merged$release_date <- NULL

mean_meta_score <- mean(subset_merged$meta_score, na.rm = TRUE)
mean_tomatometer_rating <- mean(subset_merged$tomatometer_rating, na.rm = TRUE)

# For loop to turn any non-ASCII characters to NA
for (col in names(subset_merged)) {
  if (is.character(subset_merged[[col]])) {
    subset_merged[[col]] <- iconv(subset_merged[[col]], to = "ASCII", sub = "")
  }
}

# Clean the data with gsub, removing unknown characters and numbers
subset_merged$directors <- gsub("\\?\\?", "", subset_merged$director)
subset_merged$actors <- gsub("\\?\\?", "", subset_merged$actors)
subset_merged$actors <- gsub("[^a-zA-Z0-9, ]", "", subset_merged$actors)

combo_score <- rowMeans(subset_merged[c("meta_score", "tomatometer_rating")], na.rm = TRUE)
subset_merged$combo_score <- combo_score

subset_merged$tomatometer_rating <- as.numeric(subset_merged$tomatometer_rating)
subset_merged$meta_score <- as.numeric(subset_merged$meta_score)
na.omit(subset_merged)

# Remove the movie still with NA values
subset_merged <- subset_merged[subset_merged$movie_title != "Yosemite", ]
subset_merged <- subset_merged[subset_merged$movie_title != "Equals", ]

# Structure of dataframe
str(subset_merged)

# Write CSV for merged dataframe subset
write.csv(subset_merged, "Subset_Merged.csv")

-------------------------------------------------------------------------------
### Analysis ###

library(ggplot2)

# Q1 (3.1) - How do Metacritic scores compare to Rotten Tomatoes scores for the same movies?
# Q1a 
cor.test(subset_merged$meta_score, subset_merged$tomatometer_rating)

# Q1b - Scatterplot Visualization
plot(subset_merged$tomatometer_rating, subset_merged$meta_score,
     xlab = "Tomatometer Rating", ylab = "Metascore",
     main = "Tomatometer vs Metascore Scatterplot",
     col = "red")

# Q1c - Histogram between the two variables
ggplot(subset_merged, aes(x = tomatometer_rating, fill = "Tomatometer")) +
  geom_histogram(binwidth = 5, color = "black", alpha = 0.7) +
  geom_histogram(aes(x = meta_score, fill = "Metascore"), binwidth = 5, color = "black", alpha = 0.7) +
  labs(title = "Comparison of Tomatometer and Metascore Rating Distribution",
       x = "Rating",
       y = "Frequency") +
  scale_fill_manual(values = c("Tomatometer" = "red", "Metascore" = "blue"))

# Q2 (3.2) - Do certain genres tend to receive higher or lower scores on Rotten Tomatoes compared to Metacritic?
# Q2a 
# Create genre_grouped variable to group genres
genre_grouped <- subset_merged %>%
  group_by(genres)

# Create genre_rating to calculate average Rotten Tomatoes rating (avg_rotten_rating) and the average Metacritic rating (avg_metacritic_rating) for each movie genre
genre_ratings <- genre_grouped %>%
  summarise(avg_rotten_rating = mean(tomatometer_rating, na.rm = TRUE),
            avg_metacritic_rating = mean(meta_score, na.rm = TRUE))
View(genre_ratings)

# Q2b - Geom Barplot to visualize genre score difference from genre_ratings dataframe
ggplot(genre_ratings, aes(x = genres)) +
  geom_bar(aes(y = avg_rotten_rating, fill = "Rotten Tomatoes"), stat = "identity", position = "dodge", alpha = 0.8) +
  geom_bar(aes(y = avg_metacritic_rating, fill = "Metacritic"), stat = "identity", position = "dodge", alpha = 0.8) +
  labs(title = "Average Ratings by Genre on Rotten Tomatoes vs. Metacritic",
       x = "Genre",
       y = "Average Rating") +
  scale_fill_manual(values = c("Rotten Tomatoes" = "red", "Metacritic" = "blue"), name = "Rating Source") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Q3 (3.3) - How do audience scores compare to Rotten Tomatoes scores?
# Q3a
cor.test(subset_merged$audience_rating, subset_merged$tomatometer_rating)

# Q3b
# Scatter plot Visualization between audience and Rotten Tomatoes
plot(subset_merged$audience_rating, subset_merged$tomatometer_rating,
     xlab = "Audience Rating", ylab = "Tomatometer Rating",
     main = "Audience Ratings vs Tomatometer Scatterplot",
     col = "purple")

# Q4 (3.4) - What directors and production companies are more popular among audience reviews than critic reviews?

# Create rating difference column in subset_merged with audience rating minus combo score (average between metascore and tomatometer)
subset_merged$rating_diff <- subset_merged$audience_rating - subset_merged$combo_score

# Q4a - Rank directors based on the mean positive difference in ratings
audience_director_ranking <- aggregate(subset_merged$rating_diff, by = list(directors = subset_merged$directors), FUN = mean, na.rm = TRUE)
colnames(audience_director_ranking) <- c("Director", "Mean_Rating_Difference")

# Put the audience's director ranking from highest to lowest difference
audience_director_ranking <- audience_director_ranking[order(audience_director_ranking$Mean_Rating_Difference, decreasing = TRUE), ]

top10_audience_directors <-head(audience_director_ranking, 10)

# Q4b - Rank production companies on the mean positive difference in ratings'
audience_company_ranking <- aggregate(subset_merged$rating_diff, by = list(production_company = subset_merged$production_company), FUN = mean, na.rm = TRUE)
colnames(audience_company_ranking) <- c("Production_Company", "Mean_Rating_Difference")

# Put the audience's production company ranking from highest to lowest difference
audience_company_ranking <- audience_company_ranking[order(audience_company_ranking$Mean_Rating_Difference, decreasing = TRUE), ]
top10_audience_companies <- head(audience_company_ranking, 10)
