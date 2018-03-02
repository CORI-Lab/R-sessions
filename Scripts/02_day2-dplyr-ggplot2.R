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

#------------------MUTATE----------------------------------------------
# BEFORE YOU ASSIGN RUN it and check
i_need_to_know_gdp <- dat%>%
  filter(continent == "Americas")%>%
  mutate(gdp = pop * gdpPercap)

summary(i_need_to_know_gdp$gdp)

# nlevels(i_need_to_know_gdp$continent)
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


#----------------GROUP_BY-AND-SUMMARIZE-------------------------------
# imagine
# YOU have your data and you want to calculate summary statistics
# for every station or experiment that you performed

# group_by() grouping information needed for computations within the groups.

# summarize() takes a dataset with n observations,
# computes requested summaries, and returns a dataset with 1 observation.

# we are typically interested in things like, mean, median, min, max, se, sd
# number of observations

# let's get this info for each continent and save it to a csv file
se <- function(x){sd(x)/sqrt(length(x))}

sum_stats <- dat %>%
  group_by(continent) %>%
  summarize(n = n(),
            mean_GDP = mean(gdpPercap),
            median_GDP = median(gdpPercap),
            stdev_GDP = sd(gdpPercap),
            se_GDP = se(gdpPercap),
            min_GDP = min(gdpPercap),
            max_GDP = max(gdpPercap))

# tidy_carbs <- na.omit(tidy_carbs)

write_csv(sum_stats,"01_summary-statistics-Nature-manuscript-final.csv")


#----------------RENAME-------------------------------------------------

dat %>%
  rename(life_exp = lifeExp,
         gdp_percap = gdpPercap,
         gdp_percap_rel = gdpPercapRel)






#-------------GRAPHS----------------------------------------------------

# The basics

ggplot(dat, aes(x = gdpPercap, y = lifeExp)) # nothing to plot yet!

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

ggplot(gapminder, aes(x = log10(gdpPercap), y = lifeExp)) +
  geom_point()

p1 <- dat %>%
      ggplot(aes(x = log10(gdpPercap), y = lifeExp), color = continent) + 
      geom_point(aes (color = continent),size = 3)
 
# EXPLORATORY DATA ANALYSIS
# WHAT IS THE MIN GPD per capita for each country in America
dat%>%
  filter(continent == "Americas")%>% # focusing on countries in America
  group_by(country)%>% # for each country...
  summarise(min_GDP = min(gdpPercap))%>% # compute the min and max of gdp per cap
  ggplot(aes(x = min_GDP, y = reorder(country, min_GDP),color = country))+ # for info on reorder ( ) read below
  geom_point(size = 3, stroke=1.25)+
  theme_bw()+
  theme(legend.position ="none")+ # removes the legend
  labs(title="GDP per Capita per country in Americas")+
  xlab("Minimum GDP per Capita")+
  ylab("Country")



#-------------------BOXPLOTS--------------------------------------------------

p2 <- dat%>%
  ggplot(aes(x=continent,y=gdpPercap,color=continent))+
  geom_boxplot()+
  geom_jitter(alpha=1/4)+
  coord_flip()+
  theme_bw()+
  labs(title="GDP per Capita at different continents")+
  xlab("Continent")+
  ylab("GDP per Capita")


p2 <- dat%>%
#  filter(Macro %in% c("P:C","N:C","S:C","C:N"))%>%
  ggplot(aes(x = continent,y = gdpPercap,color = continent))+
  geom_boxplot()+
  geom_point(alpha = 1/2)+
#  geom_jitter()
#  scale_color_manual(values=c("#00BA38", "#E7B800"))+
  ylab("GDP per Capita")+
#  facet_wrap( ~ Macro,nrow=1, scales="free")+
  theme_bw()
 
   theme( axis.text.x = element_blank(),
         axis.title.x = element_blank(),
         legend.title = element_blank(),
         panel.grid.major.x = element_blank(), 
         panel.grid.minor.x = element_blank(),
         panel.grid.major.y = element_blank(),
         panel.grid.minor.y = element_blank(),
         axis.title = element_text(size=14),
         axis.text = element_text(size=14),
         strip.text.x = element_text(size = 14,face= "bold"),
         legend.background = element_rect(fill="gray93"),
         panel.background = element_rect(fill="white"),
         plot.background  = element_rect(fill="gray93"))

#------------------ERROR-BARS--------------------------------------------------




#------------------MULTIPLE-PLOTS----------------------------------------------





#-----------------SAVING-PLOTS
library(cowplot)
plot <-plot_grid(p6,p1,p2,p3,p5,p4,align = "v",nrow=6)

save_plot (filename="Cu_effects-metallome.tiff", plot= plot, base_height= 6, base_width=5)

