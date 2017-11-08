dracula<-gutenberg_download(345)

#In the console, type dim(dracula)so you see number of lines

dracula$line<-1:15568

#Get rid of the this column so we just have line id and text

dracula$gutenberg_id<-NULL

#head(dracula) in the console to see the first few lines of the book

#text is the column that the words are in

dracula_words<-dracula%>%
  unnest_tokens(word,text)

#Want blocks of 80 lines at a time so in console use 65 %/% 80 meaning goes into 
#80 once which means line 65 is in the first block of 80

dracula_words$group<-dracula_words$line %/% 80

#Use the the lexicon bing to assign +1 or -1 to each word for positive or negative
#sentiment

bing<-get_sentiments('bing')

#Add another column to dracula_words dataframe - view in console by typing 
#dracula_words

dracula_words<-inner_join(dracula_words,bing)

#Add another column that is score and populate it with -1 where sentiment word
#is negative

dracula_words$score<-1
rows<-which(dracula_words$sentiment == 'negative')
dracula_words$score[rows]<--1

#Now put all words together with the same score so we can see there the biggest blocks
#of positive or negative words are found.  Type dracula_sent in console.  To see all of
#the lines, type print(dracula_sent, n-10000)

dracula_sent<-dracula_words%>%
  group_by(group)%>%
  summarize(group_sentiment=sum(score))

#Use geom_point with stat='identity' at the end inside the () to see a scatter plot 
#but it is not telling so use geom_col to see a bar graph.

ggplot()+
  geom_col(data=dracula_sent,aes(x=group,y=group_sentiment), fill='orange', color='black')

#In the console, get_sentiments('afinn') gives a list of words
