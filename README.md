# Critic-vs-Audience-Rating-Movie-Analysis

## Overview
The final report with graphics and explanations is found in the **Final Report** Word document.

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
| Column Name        | Description                                  | Data Type |
|--------------------|----------------------------------------------|-----------|
| `movie_title`      | Title of the movie                          | Text      |
| `summary`          | Short description of the movie              | Text      |
| `release_date`     | Movie's release date                        | Date      |
| `meta_score`       | Critic score from Metacritic                | Numeric   |
| `tomatometer`      | Critic score from Rotten Tomatoes           | Numeric   |
| `combo_score`      | Average of `meta_score` and `tomatometer`   | Numeric   |
| `audience_rating`  | Audience score from Rotten Tomatoes         | Numeric   |
| `genres`           | Movie genres                                | Text      |
| `directors`        | Director(s) of the movie                    | Text      |
| `production_company` | Production company of the movie           | Text      |

## How to Run the Code
1. Clone the repository.
2. Install the required R libraries: **rvest**, **dplyr**, **ggplot2**, **lubridate**.
3. Run the merge_with_rotten-1.R script to scrape, merge, and clean the datasets
4. View the final dataset (Subset_Merged.csv) and explore visualizations generated in the script.
   
## Contributors
- Alex Mona
- Jake Wis
