source('dependencies.R')
source('helpers.R')

df <- readData()

# 20 topics
load('20 topics')
topic.terms <- get.topic.terms(topic.model,20)
topic.terms

topic20labels <- data.frame(matrix(nrow = 20, ncol = 2))
colnames(topic20labels) <- c('topic.id','topic.label')
topic20labels[,1] <- c(1:20)
topic20labels[,2] <- c('PP Athletics','Sustainability','Theater/Film','Track and Field','Back to School','Tennis','Race/Ethnicity in Culture','Sports','Social Life','Campus/Residence Hall Life','Campus Justice','5C Administration','Student Government','Musical Performances','Nights Out','National Politics','Education','Campus Climate/Alcohol','Art','Sexual Assault')
topic20labels

# 25 topics
load('25 topics')
topic.terms <- get.topic.terms(topic.model,20)
topic.terms

topic25labels <- data.frame(matrix(nrow = 25, ncol = 2))
colnames(topic25labels) <- c('topic.id','topic.label')
topic25labels[,1] <- c(1:25)
topic25labels[,2] <- c('PP Athletics','Sustainability','Theater/Film','Track and Field','Study Abroad','Athletics','Racial/Ethnicity in Culture','Football','Social Life','Campus/Residence Hall Life','Campus Justice','5C Administration','Student Government','Musical Performances','Nights Out','National Politics','Education','Campus Climate/Alcohol','Technology','Sexual Assault','Misc.','Social Issues','Arts and Humanities','Research, Scholarships, Competitions','Soccer')
topic25labels
# make note of topic 19. its labels seem like it's about fashion but the articles are more about tech
# also 21 is like wtf

# 30 topics
load('30 topics')
topic.terms <- get.topic.terms(topic.model,20)
topic.terms

topic30labels <- data.frame(matrix(nrow = 30, ncol = 2))
colnames(topic30labels) <- c('topic.id','topic.label')
topic30labels[,1] <- c(1:30)
topic30labels[,2] <- c('PP Athletics','Sustainability','Theater/Film','Soccer','International Initiatives/Programs','Parties','Race/Ethnicity in Culture','Daily Life','?','Race-Based Campus Issues','Campus Justice','Campus/Residence Hall Life','Student Government','Musical Performances','Nights Out','National Politics','Internationalism at 5Cs','Campus Climate/Alcohol','Technology','Sexual Assault','?','Mental Health','Art','Curriculum/Faculty/Academic Resources','Off-Campus Adventures','5C Administration','Admissions/Financial Aid/Marketing','Track and Field','?','?')
topic30labels
# uncertain about 7, 8, 9, 17, 19 (again same as above), 21, 22 (words sound like mental health, articles sound like sexuality), 29, 30 (TOO MANY SPORTS TOPICS)

# 45 topics
load('45 topics')
topic.terms <- get.topic.terms(topic.model,20)
topic.terms

topic45labels <- data.frame(matrix(nrow = 45, ncol = 2))
colnames(topic45labels) <- c('topic.id','topic.label')
topic45labels[,1] <- c(1:45)
topic45labels[,2] <- c('PP Athletics','5C Finances','Theater/Film','Soccer','International Initiatives/Programs','Athletics','Sustainability','Football','Entertainment','?','Campus Justice','Cuisine','Student Government','Visiting Guests/Speakers','Sex','National Politics','?','Campus Safety','Fashion','Sexual Assault','Games?','Sexuality','Art','Technology','Off-Campus Adventures','On-Campus Parties','Student Orientation/First-Year Experience','Track and Field','Community Engagement','Tennis?','Student Protests','Harvey Mudd Initiatives, Recognition','Admissions/Financial Aid/Marketing','Construction Projects','?','Jobs/Careers','Gender','Scripps Administration','CMC and Pitzer Student Gov./Admin.','Musical Performances','Politics of Race','Campus Diversity and Inclusion','Curriculum, Liberal Arts','Literature','?')
topic45labels
# uncertain about 4, 6, 9 (seems to be about arts/entertainment, e.g. movies/albums, but hte words don't suggest that)
# 10, 17, 21, 22 (articles seem to be about sexuality, but the words sound like religion), 30, 35, 41 (indigenous studies?), 45

# read these to CSV files