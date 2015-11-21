require('tm')
require('topicmodels')
require('SnowballC')
require('dplyr')
source('readData.R')
articles <- readData()

load('40 topics')
topic.terms = terms(topic.model,20)
article.topics = data.frame(t(data.frame(topics(topic.model,5))))


topic.labels <- c('campus news','gender','campus sports','technology & business', 'social media & life',
                  'environment & sustainability', 'academics', 'sexual assault', 'fashion & style',
                  '', 'party & social life', 'education & career', 'varsity sports', 
                  'reflection & past and future','faculty, presidency and college committee', 'musical perfomance',
                  'food', 'professors & research', 'campus events & organizations', 'sports competitions', 
                  'student government', 'financial aid & admission', 'sexual life', 'team sports', '')
