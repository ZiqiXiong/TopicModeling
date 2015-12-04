require(tidyr)
require(dplyr)
require(ggplot2)
require(lubridate)
source('helpers.R')

# load articles
articles <- readData()

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
sections = c('news','ls','ops','sports')

# FIGURE OUT HOW TO GET SECTION IN GRAPH TITLE
# consider manually (or via code) going back through profiles.csv and
# identifying who the guest writers are by matching to online text (jk don't
# think it's possible)
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

# get info on the top writer


# get info on average/median retention rate
articles = articles %>%
  mutate(yearPublished = year(published_date)) %>%
  mutate(monthPublished = month(published_date)) %>%
  mutate(dayPublished = day(published_date)) %>%
  mutate(semester = ifelse(monthPublished < 6, 'spring', 'fall'))

articles %>%
  group_by(profile_id) %>%
  summarise(yearDiff = max(yearPublished) - min(yearPublished)) %>%
  group_by(yearDiff) %>%
  summarise(n = n()) %>%
  ggplot(aes(x = yearDiff)) + geom_line(aes(y=n)) + geom_point(aes(y=n))
            
            
            maxYear = max(yearPublished),
            semesterOff = ifelse(is.element('spring',articles[which(yearPublished)==maxYear,]$semester)))

vector = c()
for (id in articles$profile_id) {
  indices = which(articles$profile_id == id)
  maxYear = max(articles[indices,]$yearPublished)
  semesterOff = which(articles$yearPublished == maxYear)
  semesterOff = articles[semesterOff,]$semester
  vector = c(vector, semesterOff)
}
# get info on the retention rate by section

# get info on the retention rate by year

# get info on most popular topic of all time

# get info on most viewed pieces

# get info on least viewed pieces
