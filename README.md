# Exploratory Analysis of Dublin Bike Traffic and Weather Data 🚲🌦️

### Overview 📊

This repository contains the analysis conducted as part of Assignment 2, focusing on exploring bike traffic and weather data in Dublin. The dataset spans from September 1st, 2022, to August 31st, 2023, encompassing hourly records of bicycle traffic volumes from various cycle counters across Dublin city, along with weather conditions recorded by Met Éireann.

### Dataset 📂

- **Bicycle Traffic Data**: 🚴‍♂️ The dataset includes hourly bicycle traffic volumes from cycle counters located at different sites in Dublin, such as Clontarf, Griffith Avenue, Grove Road, and Richmond Street.
  
- **Weather Data**: 🌡️ It also incorporates weather-related variables like precipitation amount, air temperature, mean hourly wind speed, and cloud amount.

The data was sourced from the [Smart Dublin](https://data.smartdublin.ie) portal and [Met Éireann](https://www.met.ie), respectively.

### Tasks 📝

#### Task 1: Data Manipulation 🔧

1. **Loading and Preprocessing**: The dataset was loaded from `dublin-bikes.txt` and processed to ensure appropriate variable naming and data types.

2. **Data Quality Check**: The dataset's size and structure were examined, and necessary adjustments were made to ensure the correct storage of date and numeric variables.

3. **Factor Conversion**: The variable representing cloud amount was converted into an ordered factor for better analysis.

4. **Date-Time Splitting**: The `Time` column was split into separate columns for date and hour, facilitating further analysis.

#### Task 2: Data Analysis 📈

1. **Monthly Precipitation**: Utilizing base R functions, the highest and lowest monthly precipitation amounts were computed.

2. **Temperature Time Series**: Using ggplot2, a time series plot was generated to visualize the maximum and minimum daily temperatures over the study period.

3. **Weekend vs. Weekday Rainfall**: The dataset was analyzed to determine if there was more rain on weekends compared to weekdays.

4. **Daily Traffic Volume and Cloud Mode**: Focusing on a selected month, a plot depicting the daily traffic volume and cloud mode was created to explore any potential correlations.


![Rplot1](https://github.com/DivyaPariti/Exploratory-Analysis-of-Dublin-Bike-Traffic-and-Weather-Data/assets/65856784/5ee39d92-0225-46f5-8111-f2126e1fa66b)

![Rplot2](https://github.com/DivyaPariti/Exploratory-Analysis-of-Dublin-Bike-Traffic-and-Weather-Data/assets/65856784/e8a7d019-8ad2-443c-b8ba-0482a95ad04f)


#### Task 3: Creativity 🎨

- **Precipitation by Month**: A bar graph illustrating the total precipitation amount for each month was generated to identify seasonal patterns.

- **Mean Wind Speed by Month**: An aggregate table showing the mean wind speed for each month provided insights into seasonal variations in wind conditions.

![Rplot](https://github.com/DivyaPariti/Exploratory-Analysis-of-Dublin-Bike-Traffic-and-Weather-Data/assets/65856784/a2deee00-8cf0-4d5e-85f8-3599e9dfd8f1)


### Conclusion 🏁

This analysis provides valuable insights into bike traffic trends and weather patterns in Dublin. The findings contribute to a better understanding of the factors influencing bike usage and weather conditions in the city.

### License:
This project is licensed under the [MIT License](LICENSE), allowing for free use, modification, and distribution of the codebase. Refer to the LICENSE file for more details. 📜

### Contact:
For any questions, suggestions, or collaboration opportunities, contact the project maintainer:
- [Divya Pariti](mailto:divya.pariti@ucdconnect.ie) 📧
