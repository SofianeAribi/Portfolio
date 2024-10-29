#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np


# In[73]:


movies = pd.read_csv(r"C:\Users\So\Downloads\movies.csv")
movies.head()


# In[63]:


pd.set_option('display.max.rows',11000)
pd.set_option('display.max.columns',22)


# In[30]:


movies.info()


# In[ ]:





# # Data cleaning 

# In[ ]:


#Cleaning duplicates and Null values


# In[5]:


movies[movies.duplicated()]


# In[65]:


movies.drop_duplicates(inplace = True)


# In[6]:


movies[movies['genres'].isnull()]


# In[7]:


movies.dropna(subset = ['genres'], inplace = True)


# In[ ]:


#Add new columnt 'profit'


# In[8]:


movies['profit'] = movies['revenue'] - movies['budget']


# In[ ]:


#Dropping columns:


# In[133]:


movies_genres = movies[['popularity','budget','revenue', 'original_title', 'runtime', 'genres', 'release_date','vote_count','vote_average','profit', ]]
movies_genres.head()


# In[134]:


movies_genres_year = movies[['popularity','budget','revenue', 'original_title', 'runtime', 'genres', 'release_year','vote_count','vote_average','profit', ]]
movies_genres_year.head()


# In[11]:


from pandas import Series, DataFrame


# In[12]:


split = movies_genres['genres'].str.split('|').apply(Series, 1).stack()
split.index = split.index.droplevel(-1)
split
split.name = 'split_genre'
del movies_genres['genres']
movies_genres = movies_genres.join(split)


# In[13]:


movies_genres


# In[ ]:


### Answering Questions:

## 1. Which genres are the most common ? ( number of movies made)


# In[84]:


movies_genres.groupby('split_genre')['original_title'].count().sort_values(ascending = False).head()


# In[103]:


genres_count = pd.DataFrame(movies_genres.groupby('split_genre').original_title.nunique()).sort_values(by= 'original_title', ascending = True)


# In[104]:


genres_count


# In[110]:


genres_count['original_title'].plot.barh(title = 'Movies count per Genre', color = 'red', figsize = (10,5))
plt.show()


# In[ ]:


## 2. Which genres have high.avg budget and revenue ?


# In[53]:


genres_avg = movies_genres.groupby('split_genre').mean(numeric_only=True)
pd.options.display.float_format = '{:2f}'.format
genres_avg


# In[54]:


genres_avg.sort_values('budget', ascending = True, inplace = True)
genres_avg


# In[55]:


genres_avg[['budget', 'revenue']].plot.barh(title = 'AVG Bugdet and revenue per Genre', color = ('DarkBlue','DarkGreen'), figsize = (10,5))
plt.ylabel('Genre')
plt.show()


# In[ ]:


## 2.5 Which genre have most avg.profit ?


# In[56]:


genres_avg_profit = pd.DataFrame(genres_avg.groupby('split_genre')['profit'].mean(numeric_only = True).sort_values(ascending = True))
genres_avg_profit


# In[59]:


genres_avg_profit.plot.barh(title = 'Profit per genre', color = 'lime', figsize = (10,5))

plt.show()


# In[ ]:


## 3 Which genre have high.avg popularity ?


# In[60]:


genre_avg_pop = pd.DataFrame(genres_avg.groupby('split_genre')['popularity'].mean(numeric_only = True).sort_values())
genre_avg_pop


# In[61]:


genre_avg_pop['popularity'].plot.barh(title = 'Average popularity per Genre', color = 'purple', figsize = (10,5))

plt.show()


# In[ ]:


## 4. Which genre have highest number of movies with a voting.avg >= 8 ?


# In[16]:


movies_genres.head()


# In[65]:


genre_vote = movies_genres[(movies_genres['vote_count'] >= 50)  & (movies_genres['vote_average'] >= 8)]
genre_vote


# In[66]:


genre_vote_zero = movies_genres[(movies_genres['vote_count'] >= 0)  & (movies_genres['vote_average'] >= 8)]
genre_vote_zero


# In[41]:


vote = pd.DataFrame(genre_vote.groupby('split_genre').vote_average.nunique().sort_values(ascending = True))
vote


# In[69]:


vote_zero = pd.DataFrame(genre_vote.groupby('split_genre').vote_average.nunique().sort_values(ascending = True))
vote_zero


# In[67]:


vote.plot.barh(title = 'Highest genre votes > 50', color = 'DarkGreen', figsize = (10,5))

plt.show()


# In[72]:


vote_zero.plot.barh(title = 'Highest genre votes > 0', color = 'Grey', figsize = (10,5))

plt.show()


# # Research Hypotheses:

# In[ ]:


# The best movies according to vote.avg return profit:


# In[82]:


movies.drop_duplicates(inplace = True)
movies['profit'] = movies['revenue'] - movies['budget']
movies_genres = movies[['popularity','budget','revenue', 'original_title', 'runtime', 'genres', 'release_date','vote_count','vote_average','profit', ]]


# In[76]:


movies_genres.head()


# In[94]:


movies_has_profit = pd.DataFrame(movies_genres[(movies_genres['budget']>0) & (movies_genres['revenue']>0)])


# In[95]:


movies_has_profit


# In[98]:


vote_fifty = movies_has_profit[movies_has_profit['vote_count'] >= 50]
vote_fifty


# In[105]:


vote_fifty_corr = vote_fifty.corr(numeric_only = True)


# In[121]:


plt.figure(figsize = (10,5))
sns.regplot(x = 'vote_average', y= 'profit', data = vote_fifty, line_kws = {'color' : 'red'})

plt.show()


# In[ ]:


# 2. The best movie according to popularity, return profit:


# In[115]:


vote_fifty.corr(numeric_only = True)


# In[120]:


plt.figure(figsize = (10,5))
sns.regplot(x = 'popularity', y= 'profit', data = vote_fifty,color = 'green', line_kws = {'color' : 'red'})

plt.show()


# In[ ]:


#3. High budgeted movies return profit:


# In[124]:


plt.figure(figsize = (10,5))
sns.regplot(x = 'budget', y= 'profit', data = vote_fifty,color = 'red', line_kws = {'color' : 'blue'})

plt.show()


# In[ ]:


#4. Highly budgeted movies have high popularity:


# In[127]:


plt.figure(figsize = (10,5))
sns.regplot(x = 'budget', y= 'popularity', data = vote_fifty,color = 'black', line_kws = {'color' : 'orange'})

plt.show()


# In[176]:


#5. Take a look at Profit per Genre per year:


# In[137]:


movies_genres_year.head()


# In[136]:


split = movies_genres_year['genres'].str.split('|').apply(Series, 1).stack()
split.index = split.index.droplevel(-1)
split
split.name = 'split_genre'
del movies_genres_year['genres']
movies_genres_year = movies_genres_year.join(split)


# In[155]:


time_genre = pd.DataFrame(movies_genres_year.groupby(['release_year', 'split_genre'])['profit'].mean())


pd.set_option('display.max.rows',11000)
time_genre


# In[157]:


pivot_time_genre = pd.pivot_table(time_genre, values = 'profit', index = ['split_genre'], columns = 'release_year')


# In[175]:


plt.figure(figsize = (13,8))

sns.heatmap(data =pivot_time_genre, cmap = 'YlGnBu', linewidth = 0.6)

plt.title('Genres by Profit per year')

plt.show()


# In[ ]:





# In[ ]:





# In[ ]:




