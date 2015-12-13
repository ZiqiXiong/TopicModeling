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
  ggplot(aes(x = total)) + geom_histogram(binwidth = 1, col=I('gray')) + ggtitle('Histogram of Articles per Writer') + xlab('Number of Writers') + ylab('Number of Articles Written')

# important to note in the above that at least some of the counts include guest
# writers for opinions pieces who only write one or maybe a few pieces in their
# time in Claremont

sections = c('News','L&S','Ops','Sports')
for (num in 1:4) {
  section <- sections[num]
  title <- paste('Histogram of', bquote(.(section)), 'Articles per Writer')
  section_articles_per_writer = articles %>%
    filter(section_id == num) %>%
    group_by(profile_id) %>%
    summarise(total = n()) %>%
    ggplot(aes(x = total)) + geom_histogram(binwidth = 1, col=I('gray')) + ggtitle(title) + xlab('Number of Articles Written') + ylab('Number of Writers')
  
  print(section_articles_per_writer)
  }

### TOP WRITER ###
# get top writer
sort(articles_per_writer$total)

# Wes Haas PO '14
row(articles_per_writer)[articles_per_writer[,2]==68]
articles_per_writer[69,]$profile_id
top_writer = articles %>%
  filter(profile_id==81) %>%
  View()

# Editorial Board
row(articles_per_writer)[articles_per_writer[,2]==64]
articles_per_writer[34,]$profile_id
top_writer = articles %>%
  filter(profile_id==39) %>%
  View()

# Editorial Board
row(articles_per_writer)[articles_per_writer[,2]==61]
articles_per_writer[148,]$profile_id
top_writer = articles %>%
  filter(profile_id==176) %>%
  View()

# Tim Taylor
row(articles_per_writer)[articles_per_writer[,2]==57]
articles_per_writer[88,]$profile_id
top_writer = articles %>%
  filter(profile_id==103) %>%
  View()

# The Student Life Staff
row(articles_per_writer)[articles_per_writer[,2]==51]
articles_per_writer[147,]$profile_id
top_writer = articles %>%
  filter(profile_id==175) %>%
  View()

# Nachi Baru PO '17 (sports)
row(articles_per_writer)[articles_per_writer[,2]==48]
articles_per_writer[562,]$profile_id
top_writer = articles %>%
  filter(profile_id==634) %>%
  View()

### REGRAPH IN LIGHT OF THE ABOVE ###
sections = c('News','L&S','Ops','Sports')
for (num in 1:4) {
  section <- sections[num]
  title <- paste('Histogram of', bquote(.(section)), 'Articles per Writer')
  section_articles_per_writer = articles %>%
    filter(section_id == num) %>%
    filter(profile_id !=39 & profile_id !=176 & profile_id != 175) %>%
    group_by(profile_id) %>%
    summarise(total = n()) %>%
    ggplot(aes(x = total)) + geom_histogram(binwidth = 1, col=I('gray')) + ggtitle(title) + xlab('Number of Articles Written') + ylab('Number of Writers')
  
  print(section_articles_per_writer)
}

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
  ggplot(aes(x = yearDiff)) + geom_line(aes(y=n)) + geom_point(aes(y=n)) + xlab('Number of Years Writing for TSL') + ylab('Number of Writers') + ggtitle('Writer Count by Number of Years Writing for TSL')
            
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

retention = retention[!duplicated(retention[,6]),]

retention %>%
  group_by(semestersTotal) %>%
  summarise(n = n()) %>%
  ggplot(aes(x = semestersTotal)) + geom_line(aes(y=n)) + geom_point(aes(y=n)) + xlab('Number of Semesters Writing for TSL') + ylab('Number of Writers') + ggtitle('Retention Rate of TSL Writers')

# get info on the retention rate by section
retention %>%
  filter(section_id != 5) %>%
  group_by(semestersTotal, section_id) %>%
  summarise(n = n()) %>%
  ggplot(aes(x = semestersTotal, y=n, color=factor(section_id))) + geom_point() + geom_line() + scale_color_discrete(name="Section", labels = c('News','Sports','Opinions','L&S')) + xlab('Number of Semesters Writing for TSL') + ylab('Number of Writers') + ggtitle('Retention Rate by Section')

# same thing, but x-axis is on a log scale now
retention %>%
  filter(section_id != 5) %>%
  group_by(semestersTotal, section_id) %>%
  summarise(n = n()) %>%
  ggplot(aes(x = log(semestersTotal), y=n, color=factor(section_id))) + geom_point() + geom_line() + scale_color_discrete(name="Section", labels = c('News','Sports','Opinions','L&S')) + xlab('log(Number of Semesters Writing for TSL)') + ylab('Number of Writers') + ggtitle('Retention Rate by Section')

# get info on most popular topic of all time

# get info on most viewed pieces
clicks <- read.csv('articles.csv')
clicks <- clicks[,c(1,4)]
names(clicks) <- c('id','clicks')

# most viewed articles (title, date published, writer, number of clicks)
(articles %>%
  left_join(clicks, by = 'id') %>%
  arrange(desc(clicks)) %>%
  slice(1:10))[,c(2,4,7,12)]

# for convenience, since from now on we'll be filtering fall 2015 only
clicks <- articles %>%
  filter(yearPublished == 2015 & semester == 'fall') %>%
  left_join(clicks, by = 'id')

# get info on least viewed pieces
(clicks %>%
  arrange(clicks) %>%
  slice(1:10))[,c(2,4,7,12)]

# interesting that they were all from the 12/4 issue. might be because
# it was the last issue and nothing really happened (right after Thanksgiving break).
# exclude those from the data
(clicks %>%
  filter(published_date != as.Date('2015-12-04')) %>%
  arrange(clicks) %>%
  slice(1:10))[,c(2,4,7,12)]

# plot distribution of views in fall 2015
clicks %>%
  ggplot(aes(x = semester, y = clicks)) + geom_boxplot() + xlab('Semester') + ylab('Cumulative Number of Clicks') + ggtitle('Distribution of Clicks of TSL Fall 2015 Articles')

# exclude outliers from view
clicks %>%
  ggplot(aes(x = semester, y = clicks)) + geom_boxplot() + scale_y_continuous(limits = c(0,500)) + xlab('Semester') + ylab('Cumulative Number of Clicks') + ggtitle('Distribution of Clicks of TSL Fall 2015 Articles')

# do the same but by section
clicks %>%
  filter(section_id != 5) %>%
  mutate(section = ifelse(section_id==1, 'News', ifelse(section_id==2, 'Sports', ifelse(section_id==3, 'Opinions', 'L&S')))) %>%
  ggplot(aes(x = factor(section), y = clicks)) + geom_boxplot() + ylab('Cumulative Number of Clicks') + ggtitle('Distribution of Clicks by Section of TSL Fall 2015 Articles')

# exclude outliers from view
clicks %>%
  filter(section_id != 5) %>%
  mutate(section = ifelse(section_id==1, 'News', ifelse(section_id==2, 'Sports', ifelse(section_id==3, 'Opinions', 'L&S')))) %>%
  ggplot(aes(x = factor(section), y = clicks)) + geom_boxplot() + scale_y_continuous(limits = c(0,1250)) + ylab('Cumulative Number of Clicks') + ggtitle('Distribution of Clicks by Section of TSL Fall 2015 Articles')

# statistical analysis of clicks by section
summary(aov(clicks ~ factor(section_id), clicks %>% filter(section_id!=5)))

# we can try to identify the most clicked writers on average
(clicks %>%
  filter(section_id != 5) %>%
  group_by(author_name) %>%
  summarise(avg = mean(clicks), n=n()) %>%
  arrange(desc(avg)) %>%
  slice(1:10))

# a lot of these are one-hit pieces. let's see among the more consistent writers
(clicks %>%
  filter(section_id != 5) %>%
  group_by(author_name) %>%
  summarise(avg = mean(clicks), n=n()) %>%
  filter(n>3) %>%
  arrange(desc(avg)) %>%
  slice(1:10))

# same but for least clicked writers on average
(clicks %>%
  filter(section_id != 5) %>%
  group_by(author_name) %>%
  summarise(avg = mean(clicks), n=n()) %>%
  arrange(avg) %>%
  slice(1:10))

# again with repeat writers only
(clicks %>%
  filter(section_id != 5) %>%
  group_by(author_name) %>%
  summarise(avg = mean(clicks), n=n()) %>%
  filter(n>3) %>%
  arrange(avg) %>%
  slice(1:10))

# most mentioned people/groups/names in TSL articles
