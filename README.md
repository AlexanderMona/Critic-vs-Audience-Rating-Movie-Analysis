# Critic-vs-Audience-Rating-Movie-Analysis

## Overview
The final report with graphics and explanations is found in the **Data Wrangling - Final Report** PDF file.

This project explores the relationship between movie critic reviews and audience ratings, focusing on data from Metacritic’s **Metascores** and Rotten Tomatoes’s **Tomatometer**. We aim to uncover patterns and underlying correlations in movie evaluations, examine genre-based score differences, and identify directors and production companies favored by audiences over critics.

The study integrates multiple datasets and employs data scraping, data preprocessing and cleaning, and statistical analysis techniques. We included visualizations to enhance understanding and interpretation of the results.

## Data Collection
1. **Metacritic Data**
We scraped the Metacritic website to collect the following attributes for movies released in 2016:
- Movie title
- Release date
- Summary
- Metascore (aka critic rating)

The scraping process included:
- Custom user-agent configuration for server compliance
- Random delays between page requests to prevent server overload
- HTML parsing using **rvest** in R to extract data fields.

2. **Rotten Tomatoes Data**
We were unable to scrape the Rotten Tomatoes website due to scraping restrictions, so we utilized a [Kaggle dataset](https://www.kaggle.com/datasets/subhajournal/movie-rating) containing:
- Tomatometer (critic rating)
- Audience rating
- Movie genres, directors, authors, and actors
- Production companies and runtime details

## Data Cleaning and Integration
The datasets were merged using the movie title as the key, resulting in a combined dataset with 376 observations and 16 variables. Key cleaning steps included:
- Removing duplicate or null entries
- Converting non-ASCII characters to valid formats
- Creating a combo_score (average of Metascore and Tomatometer) for comparative analysis

## Final Dataset Variables:
The dataset includes the following fields:
| **Column**           | **Type**  | **Source**        | **Description**                                      |
|-----------------------|-----------|-------------------|----------------------------------------------------|
| `movie_title`         | Text      | Both              | Title of the movie                                 |
| `director`            | Text      | Rotten Tomatoes   | Director of the movie                              |
| `summary`             | Text      | Both              | A description of the movie                        |
| `release_date`        | Date      | Both              | The month and year the movie was released         |
| `tomatometer_rating`  | Numeric   | Rotten Tomatoes   | The review score as decided by Rotten Tomatoes critics |
| `meta_score`          | Numeric   | Metacritic        | The review score as decided by Metacritic movie critics |
| `combo_score`         | Numeric   | Both              | The average critic review ranking between Metascore and Tomatometer |
| `audience_rating`     | Numeric   | Rotten Tomatoes   | The review score as decided by Rotten Tomatoes users |
| `content_rating`      | Text      | Rotten Tomatoes   | The motion picture rating of the movie (e.g., PG-13, R) |
| `genres`              | Text      | Rotten Tomatoes   | The genre of the movie                             |
| `authors`             | Text      | Rotten Tomatoes   | Writers or writer of the movie                    |
| `actors`              | Text      | Rotten Tomatoes   | Actors featured in the movie                      |
| `runtime`             | Numeric   | Rotten Tomatoes   | Runtime of the movie in minutes                   |
| `production_company`  | Text      | Rotten Tomatoes   | The production company of the movie               |
| `tomatometer_count`   | Numeric   | Rotten Tomatoes   | Total number of reviews by critics                |
| `audience_count`      | Numeric   | Rotten Tomatoes   | Total number of reviews by non-critics (audience) |
| `rating_diff`         | Numeric   | Both              | The audience rating minus the combo score         |


## How to Run the Code
1. Clone the repository.
2. Install the required R libraries: **rvest**, **dplyr**, **ggplot2**, **lubridate**.
3. Run the merge_with_rotten-1.R script to scrape, merge, and clean the datasets
4. View the final dataset (Subset_Merged.csv) and explore visualizations generated in the script.
   
## Contributors
- Alex Mona
- Jake Wis
