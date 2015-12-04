require(tidyr)
require(dplyr)
require(ggplot2)
require(lubridate)
source('helpers.R')

# load articles
articles <- readData()


### ARTICLES PER WRITER ###
# get dataframe of number of articles written by each unique writer
articles_per_writer = articles %>%
  group_by(profile_id) %>%
  summarise(total = n())

# histogram of how many different pieces writers have written
articles_per_writer %>%
  ggplot(aes(x = total)) + geom_histogram(binwidth = 1)

# important to note in the above that at least some of the counts include guest
# writers for opinions pieces who only write one or maybe a few pieces in their
# time in Claremont

# FIGURE OUT HOW TO GET SECTION IN GRAPH TITLE
# consider manually (or via code) going back through profiles.csv and
# identifying who the guest writers are by matching to online text (jk don't
# think it's possible)
sections = c('news','ls','ops','sports')
for (num in 1:4) {
  print(typeof(toString(sections[num])))
  section_articles_per_writer = articles %>%
    filter(section_id == num) %>%
    group_by(profile_id) %>%
    summarise(total = n()) %>%
    ggplot(aes(x = total)) + geom_histogram(binwidth = 1) + ggtitle(
    'articles per writer') + xlab('number of articles written') + ylab('number of writers')
  
  print(section_articles_per_writer)
}

### TOP WRITER ###

### RETENTION RATE ###
# break down date published into component parts, determine semester published
articles = articles %>%
  mutate(yearPublished = year(published_date)) %>%
  mutate(monthPublished = month(published_date)) %>%
  mutate(dayPublished = day(published_date)) %>%
  mutate(semester = ifelse(monthPublished < 6, 'spring', 'fall'))

# plot retention rate by year
articles %>%
  group_by(profile_id) %>%
  summarise(yearDiff = max(yearPublished) - min(yearPublished)) %>%
  group_by(yearDiff) %>%
  summarise(n = n()) %>%
  ggplot(aes(x = yearDiff)) + geom_line(aes(y=n)) + geom_point(aes(y=n))
            
# the above may be flawed, though, since people who maybe start writing in the spring
# and quit at the end of the fall have written for a while, whereas people who 
# start and quit in the fall don't write as much

# plot retention rate by semester
retention = articles %>%
  group_by(profile_id) %>%
  mutate(maxYear = max(yearPublished),
         minYear = min(yearPublished),
         semesterOff = ifelse(maxYear==yearPublished & semester=='fall','fall','spring'),
         semesterJoin = ifelse(minYear==yearPublished & semester=='spring','spring','fall'),
         semestersTotal = ifelse(semesterOff==semesterJoin,(maxYear-minYear)*2+1, (maxYear-minYear)*2))

retention %>%
  group_by(semestersTotal) %>%
  summarise(n = n()) %>%
  ggplot(aes(x = semestersTotal)) + geom_line(aes(y=n)) + geom_point(aes(y=n))

# get info on the retention rate by section
sections = c('news','ls','ops','sports')

retention %>%
  group_by(semestersTotal, section_id) %>%
  summarise(n = n()) %>%
  ggplot(aes(x = semestersTotal, y=n)) + geom_point(aes(color = section_id)) + geom_line(aes(color=section_id))

# get info on most popular topic of all time

# get info on most viewed pieces
articles %>%
  ggplot(aes(x = section_id, y=)
# get info on least viewed pieces
