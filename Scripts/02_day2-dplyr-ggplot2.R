#------------------------------------------------------------------------------------
# R beginner workshop day 2
# Extracting, sorting, summarizing and visualizing data
# with the DPLYR and GGPLOT2 of the TIDYVERSE package
# -----------------------------------------------------------------------------------


# Recommended workflow for running analysis in R

# 1) start a new R Porject (File>New Project) or open your existing project
# 2) start fresh, clean workspace and re-start R often: Session > R restart (clears any libraries
#   previosuly installed, good practice)
# 3) Install any packages you need : install.packages("package_name", dependancies = TRUE)
# 4) Load the package for every instance of R session : library (package_name)
# 5) Upload your data : e.g. read_csv("path_to_data",)
# 6) Know what variables you are working with (char, numeric, factors)
# 7) Explore your data / build your code piece by piece 
# 8) Save your output (figure or a table)


#---------------------------------------------------------------------------
# Today we are going to work with the gapminder dataset. This is DATAFRAME (or TIBBLE)
# install.packages("gapminder", dependencies = TRUE) - mine is already installed

library(tidyverse) # has dplyr and ggplot, 
library(gapminder) # dataset we are going to be working with

# let's create an object for 
dat <- gapminder

# if you were to import your own data (as csv) you would use"
# dat <- read_csv("Data/my_data.csv")

#-------------------------------------------------------------------------
# let's find out what is in the gapminder dataset, to start
# asking questions about your data, you need to know what your
# dealing with!!!!


glimpse(dat) # glimpse() command is part of the dplyr package
head(dat) # top 6 rows
names(dat) # lists the variable names
dim(dat) #  tells me about the dimentions of my data it has 1704 observations by 6 cols
nrow(dat) # number of observations
summary(dat) # gives me summary statistics for every column/variable

# to access any of the variables in the dataframe we use the dollar sign $

summary(dat$lifeExp)

# recall that the countries and continents in the dat are categorical values called
# factors, any time you are dealing with factors you can use these commands to list their names

# CATEGORICAL DATA such as your STUDY AREAS or FISH SPECIES NAMES
levels(dat$continent) # lists continent names
nlevels(dat$country) # tells me how many countries there are



#------------------------------------------------------------------------------------------------
# let's mine this data for interesting information with the dply package
# 
# ***Advice: if you can avoid it, don't create lots of excerpts of data in your
# workspace***

# We are going to learn these verbs:

# EXPLAIN how to use the command. You say R filter and your inputs into the brackets
# filter()
# select()
# summarize()
# summarize_each()
# arrange()
# group_by()


# Let's say you are interested in data for Canada in year 1985
# filter(data_name,...)

filter(dat, country == "Canada", year < 1985)
filter(dat, country == "Canada", year > 2000)

# how about both?

filter(dat, country == "Canada", year < 1985 & year > 2000)

dat%>%filter(continent == "Europe")

