#------------------------------------------------------------------------------------
# R beginner workshop day 2
# Extracting, sorting, summarizing and visualizing data
# with the DPLYR and GGPLOT2 of the TIDYVERSE package
# -----------------------------------------------------------------------------------


# Recommended workflow for running analysis in R

# 1) start a new R Project (File>New Project) or open your existing project
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

# let's create an object in our workspace. Remember that putting things
# into brackets will print it in the console
(dat <- gapminder)

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

# 
filter(dat, country == "Canada", year < 1985)
filter(dat, country == "Canada", year > 2000)

# how about both?
filter(dat, country == "Canada", year < 1985 & year > 2000)

# what about specific countries
filter(dat, country %in% c("Canada", "Poland"), year == 2000)

#subset the data on variables or columns. I typically use this when 
# I am creating a new dataframe
select(dat, country, lifeExp)


#-------------------PIPE--------------------------------------------
# PIPE
# working with the pipe operator

dat%>%filter(country %in% c("Canada", "Poland"), year == 2007)

# using the pipe let's us run multiple commands, without retyping
dat %>%
  filter(country == "Cambodia") %>%
  select(year, lifeExp)

# let's add some variables, create a new object, say you needed to focus
# on only the Americas and calculate the gdp

levels(dat$continent)

#------------------MUTATE-----------------------------------------------------
# When you do any of this, inspect if the outcome of your computation makes sense.
 
 
i_need_to_know_gdp <- dat%>%
  filter(continent == "Americas")%>%
  mutate(gdp = pop * gdpPercap)

# this is one way to check, for instance, was the
# computation only done for Americas?
summary(i_need_to_know_gdp)

# Another way to do a check could be to use nlevels()
# Note, this only works for variables that are FACTORS (not characters, but you can
# convert them to factors)
nlevels(i_need_to_know_gdp$continent)

# an example of when this is useful: normalizing chl concentration to  volume filtered

#-----------------ARRANGE---------------------------------------------
# Use arrange() to row-order data in a principled way

# WE'RE BUILDING ON THIS BEFORE WE MOVE TO GRAPHS/ EDA
# say you'd like to arrange your data by year, then country
dat %>%
  arrange(year, country)

dat %>%
  filter(country == "Canada", year > 1950) %>%
  arrange(lifeExp)

# descending or ascending order for life exp? no problem
dat %>%
  filter(year == 2007) %>%
  arrange(desc(lifeExp))


# Want to rename one of your variables? No problem, use rename()!
# rename(name_i_want = old_name)
dat %>%
  rename(life_exp = lifeExp,
         gdp_percap = gdpPercap,
         gdp_percap_rel = gdpPercapRel)


#----------------GROUP_BY-AND-SUMMARIZE-------------------------------
# Imagine, you have your data and you want to calculate summary statistics
# for every station or experiment that you performed. You need these verbs 
# (i.e.commands):
# group_by() grouping information needed for computations within the groups.
# summarize() takes a dataset with n observations,
# computes requested summaries, and returns a dataset with 1 observation.

# we are typically interested in things like, mean, median, min, max, se, sd
# number of observations

# here is a function to calculate standard error that
# is not in the base r 
se <- function(x){sd(x)/sqrt(length(x))}

# calculate summary statistics
sum_stats <- dat %>% # for stuff in dat perform the calcs below and put it in sum_stats
  group_by(continent) %>% # for every continent
  summarize(n = n(),      # estimate the number of observations and call it n
            mean_GDP = mean(gdpPercap), # calculate the mean and call it mean_GDP
            median_GDP = median(gdpPercap), # calculate the median and call it median_GDP
            stdev_GDP = sd(gdpPercap), #...you get the idea
            se_GDP = se(gdpPercap),
            min_GDP = min(gdpPercap),
            max_GDP = max(gdpPercap))

# save your output as a csv file
# write_csv(R object where you saved the stats, name you want to give your csv in quotations)
write_csv(sum_stats,"01_summary-statistics-Nature-manuscript-final.csv")


#-----------------------------------------------------------------
# COMBINE THE ABOVE WITH GRAPHS, VERY POWERFULL
#-----------------------------------------------------------------

# The basics. You first need to specif what data is going to be plotted
# you call on the ggplot(), then you put the name of your data (in our 
# case an object called dat), and you follow this by word "aes" (stands for
# aesthetics) and in brakets what goes on x axis and what goes on y axis

ggplot(dat, aes(x = gdpPercap, y = lifeExp)) # runs this, nothing to plot yet!

# the next step is to specify what kind of a plot you would like. To do this we
# use these things called geoms, some of the examples include:
# geom_point() - makes scatterplots
# geom_bar() - makes bar charts
# geom_line() - makes line graphs
# geom_histogram() - makes histograms

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

ggplot(gapminder, aes(x = log10(gdpPercap), y = lifeExp)) +
  geom_point()

# Ok, so this is the basics of a graph, let's go back to pipe so that we can 
# combine graphs with the dplyr verbs such as filter and select

# p1 stands for plot1. Notice p1 will appear in your environment. If you ever want to 
# check that plot again, instead of running the whole command, just type p1 and press 
# control + ENTER 
p1 <- dat %>%
      ggplot(aes(x = log10(gdpPercap), y = lifeExp)) + 
      geom_point(aes (color = continent),size = 3) # in the brackets you can customize anything 
                                                   # related to points, such as their size
                                                   # or maybe you want different continents
                                                  # to have diff. colors? 
p1
#-----------------------------------
# EXPLORATORY DATA ANALYSIS
#-----------------------------------

# WHAT IS THE MIN GPD per capita for each country in America
p2 <-dat%>%
  filter(continent == "Americas")%>% # focusing on countries in America
  group_by(country)%>% # for each country...
  summarise(min_GDP = min(gdpPercap))%>% # compute the min and max of gdp per cap
  ggplot(aes(x = min_GDP, y = reorder(country, min_GDP),color = country))+ # for info on reorder ( ) read below
  geom_point(size = 3, stroke=1.25)+ # stroke is the thickness of the points
  theme_bw()+ # this command is for a specific design of the graph, subsititute with theme_dark()
  theme(legend.position ="none")+ # removes the legend
  labs(title="GDP per Capita per country in Americas")+ # adds title 
  xlab("Minimum GDP per Capita")+ # adds x axis label
  ylab("Country")


# let's try a boxplot
p3 <- dat%>%
  ggplot(aes(x = continent,y = gdpPercap,color = continent))+
  geom_boxplot()+
  geom_jitter(alpha=1/4)+
  coord_flip()+ # if you include this command, x will be where y axis generally is
  theme_bw()+
  labs(title="GDP per Capita at different continents")+
  xlab("Continent")+
  ylab("GDP per Capita")


# let's make a jitterpoint plot. It is good practice to show
# the data points you used in calculation of a mean or when generating
# a boxplot
p4 <- dat%>%
  ggplot(aes(x = continent,y = gdpPercap,color = continent))+
  geom_boxplot()+
  geom_jitter()+
  ylab("GDP per Capita")
  
  

#----------------------------------------------------------------------
# Multiple graphs
#----------------------------------------------------------------------

# to create multiple plots we call on the FACET command. There are 
# two options:
# facet_grid
# facer_wrap

p5 <- dat%>%
  ggplot(aes(x = lifeExp,y = gdpPercap,color = continent))+
  geom_point()+
  facet_grid(~continent)+
  ylab("GDP per Capita")
  
p6 <- dat%>%
  ggplot(aes(x = lifeExp,y = gdpPercap,color = continent))+
  geom_point()+
  facet_wrap(~continent)+
  ylab("GDP per Capita")

#---------------------------------------------------
# Saving your plots
#---------------------------------------------------
  
# There are different ways to do it, I like to use the
# the command from the cowplot package

library(cowplot)
plot <-plot_grid(p1, p3,align = "h",nrow = 2)

save_plot (filename="Gapminder.tiff", plot = plot, base_height= 6, base_width=5)
plot
