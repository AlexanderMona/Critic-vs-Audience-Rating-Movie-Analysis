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

   
## Contributors
- Alex Mona
- Jake Wis
