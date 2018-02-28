#-----------------------
# Today I learn some R
#-----------------------

# Now I do SIMPLE OPERATIONS
height_cm <- 172
height_inch <- 172 * 0.39

# alternative
height_cm * 0.39
(height_inch <- height_cm * 0.39)

rm(list = ls())

#------------------------------
# Now I explore what functions are

? 
log(height_inch)
abs(height_inch)
exp(height_inch)
round(height_inch)



#------------------------------
# now I explore data types

fish_weights_g <- c(50, 60, 65, 82)
fish_weights_g <- fish_weights_g/2
fish_weights_g

animals <- c("whale", "otter", "fish") # a character vector
a <- c(1,2,5.3,6,-2,4) # numeric vector
c <- c(TRUE,TRUE,TRUE,FALSE,TRUE,FALSE) #logical vector

animals_other <- c(whale, otter, fish)

animals
length(animals)
class(animals)

# everything is a vector
length(gapminder$country)

#------------------------------
# now I explore what packages are

#install.packages("gapminder")
#install.packages("tidyverse")
install.packages(co2)

library(gapminder)
library(tidyverse)

str(gapminder)
length(gapminder)
#glimpse(gapminder)
head(gapminder)
summary(gapminder)

?gapminder

plot(gapminder$year, gapminder$lifeExp)
boxplot(gapminder$lifeExp ~ gapminder$continent)
# other datasets to practice with

library(co2)

glimpse(co2)
class(co2)
plot(co2)


library(car)
?car

#----------------
# DATA FRAME
#---------------

# tabular data structure in R, each column is a vector of the same type, e.g character, dbl
#Data frames are the de facto data structure for most tabular data, and what we use for statistics and plotting.

gapminder

# or you can create one

d <- c(1,2,3,4) # creating a numeric vector for col 1
e <- c("red", "white", "red", NA) # creating characters for col 2
f <- c(TRUE,TRUE,TRUE,FALSE) # creating logical values for col3
my_data <- data.frame(d,e,f)
names(my_data) <- c("ID","Color","Passed") # variable names
my_data

# or you can import from your excell spreadsheet

my_data <- read_csv("~/Data/R_intro.csv")
