## Task 1 : Data Manipulation

#Firstly, we need to load the data set into R, and we can directly give the file path as we saved the document and the data set in the same project folder. To save the data as a tibble we need to use the function`as_tibble()` from `tibble` library. `as_tibble()` turns an existing object; in our case the data frame, into a tibble.
#Loading all the required libraries

library('tidyverse')
library('ggplot2')

# Read the dataset into R
# We are reading the dataset into a table as our dataset is not formatted as a CSV
db_data_set = read.table("dublin-bikes-v2.txt", header = TRUE, sep = "\t")

# Saving the data as a tibble
db_data_tibble = as_tibble(db_data_set) 

# Giving meaningful names to the variables related to the weather
db_data_tibble = rename(db_data_tibble,
                        Temperature = temp,
                        MeanWindSpeed = wdsp,
                        PrecipitationAmount = rain
)

# Checking if the above changes are applied to our dataset
head(db_data_set)
head(db_data_tibble)

# Finding the size of the data set
db_size = dim(db_data_tibble)
# `dim()` function sets the dimension of the given data frame

# Printing the number of rows
print(paste("The number of rows in dublin bikes dataset is - ", db_size[1]))

# Printing the number of columns
print(paste("The number of colummns in dublin bikes dataset is - ", db_size[2]))

# Firstly, let's check the type of `Time` variable
class(db_data_tibble$Time)

# Converting variable type of `Time` into the appropriate class using `as.Date()` method
db_data_tibble$Time = as.Date(db_data_tibble$Time, format = "%Y-%m-%dT%H:%M:%SZ", tz = "GMT")
# `as.Date()` function converts character representations into calendar dates.
# Displaying the structure of the data set
str(db_data_tibble, width = 84, strict.width = "cut")
#`str()` displays the structures of objects or the summary of the output produced.
# setting the arguments `width = 84, strict.width = "cut"` will ensure that the output is not going off the margin when rendered into a pdf.


#From the above output we can clearly say that there are `8760` rows and `12` columns in our data set. Initially the variable `Time` was stored as a character object. Later we changed it into it's appropriate class.

# converting the cloud amount - `clamt` variable into an ordered factor.
db_data_tibble$clamt = factor(db_data_tibble$clamt, ordered = TRUE) 
# `ordered = TRUE` condition is used to get the ordered factor of the cloud amount variable.
# Printing the levels of the output and checking again if the output is ordered
cat("Levels of Cloud Amount Information :", levels(db_data_tibble$clamt), "\n")
cat("Checking if Cloud Amount Information in ordered factors - (Y/N) :", is.ordered(db_data_tibble$clamt), "\n")


# Splitting the column `Time` into two columns
# Creating  - Date and no Time columns using `mutate` function to create changes in Time column inside the dataset
db_data_tibble = mutate(db_data_tibble, Date = as.Date(Time), Hour = hour(Time))
head(db_data_tibble)

# Checking whether we have 24 hours for each date
num_hours_daily = db_data_tibble %>%
  group_by(Date) %>%
  summarise(Count = n_distinct(Hour))

# Checking for 365 different dates
dates_check = db_data_tibble %>%
  distinct(Date)

cat(" Number of Hours per day count (24hr/day - Y/N): ", unique(db_data_tibble$Hour) == 24)
cat("\n Number of different dates: ", nrow(dates_check) )


# Creating a new column for days in a Week and generating an ordered factor using the `weekdays()` in-built function in R.
db_data_tibble$DaysinWeek = factor(weekdays(db_data_tibble$Time), ordered = TRUE)

# Creating a new column for months in a year and generating an ordered factor using the `months()` in-built function in R.
db_data_tibble$Month = factor(months(db_data_tibble$Time), ordered = TRUE)

# Checking if our newly added columns are ordered factors or not using the function `is.ordered()`.
ordered_days = is.ordered(db_data_tibble$DaysinWeek)
ordered_months = is.ordered(db_data_tibble$Month) 

print(names(db_data_tibble))

cat("\nChecking if Days in a Week in ordered factors - (Y/N) - \n")
print(ordered_days)
cat("\nChecking if Months in ordered factors - (Y/N) - \n")
print(ordered_months)


#From the above code output we can say that we have successfully added 2 new columns `DaysinWeek` and `Month` to our data frame and they are in a meaningful sequence.

library(dplyr)
# Removing the column `Time` from our data frame using `select()` function that is used to keep or drop columns.
db_data_tibble = select(db_data_tibble, -Time)

# Using `dplyr::relocate()` function to put the new columns with the `date`, `hour`, `day of the week`, and `month` as the first four columns of the data set
db_data_tibble =  relocate(db_data_tibble, Date, Hour, DaysinWeek, Month, .before = 1)

# Checking if the Time column is dropped and other columns are relocated correctly.
head(db_data_tibble)


## Task2 : Data Analysis
# Computing the month that has the highest and lowest precipitation
db_data_tibble$Month = format(as.Date(db_data_tibble$Date), "%m")

# Calculating precipitation amount for all months in the data frame
total_precipitation = aggregate(PrecipitationAmount ~ Month, db_data_tibble, sum)

# Calculating the month with the highest Precipitation Amount in our data frame
high_precipitation = total_precipitation$Month[which.max(total_precipitation$PrecipitationAmount)]
highest_precipitation_amount = max(total_precipitation$PrecipitationAmount)
cat("Month that has the highest precipitation amount is", high_precipitation,"\n")

# Calculating the month with the lowest Precipitation Amount in our data frame
low_precipitation = total_precipitation$Month[which.min(total_precipitation$PrecipitationAmount)]
cat("Month that has the lowest precipitation amount is",low_precipitation)

# Creating a time series plot using maximum and minimum daily temperatures
temp_data <- summarize(
  group_by(db_data_tibble, Date),
  Mx_Temp = max(Temperature),
  Mn_Temp = min(Temperature)
)
# Using `ggplot2` to create the data visualizations
ggplot(temp_data, aes(x = Date)) +
  geom_line(aes(y = Mx_Temp, color = "Maximum Temperatures"), linewidth = 1) +
  geom_line(aes(y = Mn_Temp, color = "Minimum Temperatures"), linewidth = 1) +
  labs(title = "Time Series Plot of Maximum and Minimum Temperatures",
       x = "Date",
       y = "Temperature") + 
  scale_color_manual(values = c("Maximum Temperatures" = "deepskyblue4", "Minimum Temperatures" = "darksalmon"))


#Above we have created a new data frame to store the maximum and minimum temperatures without altering the main data frame to create the time series plot. We can interpret from the above time series plot that lowest temperatures persist from months December to April whereas highest temperatures can be experienced from the months of May to July.

#For this, firstly let's add a new column to our data frame and will name it as `DaysinWeek`. Then let us check if the day falls under weekday or weekend and assign it's value accordingly. After which we will calculate the average rain during weekdays and weekends.

# creating new column to store average rainfall for weekdays and weekends 
db_data_tibble = mutate(db_data_tibble, DaysinWeek = ifelse(weekdays(Date) %in% c("Saturday", "Sunday"), "Week End", "Day in Week"))

# Calculating average rain on both weekdays and weekends
rainfall_average = db_data_tibble %>%
  group_by(DaysinWeek) %>%
  summarize(meanrainfall = mean(PrecipitationAmount))

cat("Average Rainfall during Mon-Fri is ")
print(rainfall_average$meanrainfall[1])

cat("Average Rainfall during Sat-Sun is ")
print(rainfall_average$meanrainfall[2])

#So, from above outputs, average rainfall during weekdays is approximately equal to 0.097 and average rainfall during weekends is approximately equal to 0.141 and from this we can deduce that according to the data set average rainfall is more during saturday and sunday

#First let's choose one month for which we want to create the daily traffic plot and also let's choose one location for which we want to observe the mode of cloud amount for each day.

# Choosing `May` as the month of choice and location of choice to be `Richmond.Street.Cyclists.2`
month_of_choice = "05"
street_of_choice = "Richmond.Street.Cyclists.2"

Mode = function(x) {
  uniq_x <- unique(x)
  uniq_x[which.max(tabulate(match(x, uniq_x)))]
}

# Extracting the data related to month of choice and street of choice. 
#maydata = filter(db_data_tibble, format(Date, "%m") == month_of_choice, !is.na(!!sym(street_of_choice)))
findings = filter(db_data_tibble, format(Date, "%m") == month_of_choice, !is.na(!!sym(street_of_choice))) %>%
  group_by(Date) %>%
  summarize(DTvolume = sum(!!sym(street_of_choice)),
            Modeclamt = Mode(clamt))

ggplot(data = findings, aes(x = Date)) +
  geom_line(aes(y = DTvolume, color = "Daily Traffic"), linewidth = 1) +
  geom_line(aes(y = as.numeric(Modeclamt), color = "Mode Cloud"), linewidth = 1) +
  scale_color_manual(values = c("Daily Traffic" = "deepskyblue4", "Mode Cloud" = "darksalmon")) +
  labs(title = "Time Series Plot of Traffic Volume vs. Mode of Cloud Amount",
       x = "Date",
       y = "Value")


#The above time series plot depicts the `daily-traffic-volume` vs `mode-of-cloud-amount` for `May` month at the location `Richmond.Street.Cyclists.2`. By this we can say that traffic volume at the chosen location - Richmond.Street.Cyclists.2 is always above 1000 vehicles per day. Mode of cloud amount is comparatively very low but we can see slight changes in the line plotted.

#First let plot the graph for precipitation amount for every month in our data set. We can do this using `ggplot` library

# Let's create a graph for Precipitation Amount for all Months 
ggplot(data = db_data_tibble, aes(x = Month, y = PrecipitationAmount, fill = factor(Month))) +
  geom_bar(stat = "identity") +
  labs(title = "Precipitation Amount of Every Month",
       x = "Number of Months",
       y = "Total Precipitation Amount") +
  theme_light()

#The above bar graph depicts the total precipitation amount for all months round the year from our data frame. We can interpret that `July` month weather has highest precipitation with 150mm and it constantly stays above 100mm from July till September whereas `February` has the lowest precipitation amount with around 15-20mm.

#Secondly, let's create a table for mean wind-speed for every month from our data frame.

# Let's do this using the usual base R function `aggregate`
meanwspd =  aggregate(MeanWindSpeed ~ Month, data = db_data_tibble, FUN = mean)

print(meanwspd)

#The above table gives us insights into mean wind-speed for all months in our data frame. We can clearly interpret that mean wind-speed is highest in the month of `January` and lowest in the month of `May`.


